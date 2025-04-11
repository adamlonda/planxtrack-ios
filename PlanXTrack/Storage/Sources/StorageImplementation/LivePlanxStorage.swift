//
//  LivePlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 17.11.2024.
//

import Dependencies
import Foundation
import Model
import Storage

actor LivePlanxStorage: PlanxStorage {
    @Dependency(\.healthKitAvailabilityChecking) private var healthKitChecker
    @Dependency(\.healthKitAuthorizing) private var healthKitAuthorizer
    @Dependency(\.healthKitLoading) private var healthKitLoader
    @Dependency(\.healthKitRecording) private var healthKitRecording
    @Dependency(\.cache) private var cache
    @Dependency(\.uuid) private var uuid

    // MARK: - Load

    // TODO: Load from cache as well 🚧
    func load() async -> [PlankRecord] {
        guard healthKitChecker.isHealthKitAvailable else {
            return []
        }
        do {
            try await healthKitAuthorizer.authorize()
            return await healthKitLoader.load()
        } catch {
            return []
        }
    }

    // MARK: - Record

    func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws {
        let id = uuid()

        async let healthKitTask: Void = healthKitRecording.record(
            from: date.addingTimeInterval(-duration),
            to: date,
            id: id,
            feedback: feedback?.rawValue ?? ""
        )
        async let cacheTask: Void = cache.save(
            PlankRecord(
                id: .init(id),
                date: .init(date),
                duration: .init(.init(duration)),
                feedback: .init(feedback)
            )
        )
        _ = try? await healthKitTask
        try await cacheTask
    }
}
