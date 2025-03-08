//
//  LivePlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 17.11.2024.
//

import Core
import Foundation
import Model
import Storage

public final class LivePlanxStorage: PlanxStorage {
    private let healthKitChecker: HealthKitAvailabilityChecking
    private let healthKitAuthorizer: HealthKitAuthorizing
    private let healthKitLoader: HealthKitLoading
    private let healthKitRecording: HealthKitRecording

    private let uuid: UUIDProviding
    private let cache: Cache

    // MARK: - Init

    public init(
        healthKitChecker: HealthKitAvailabilityChecking,
        healthKitAuthorizer: HealthKitAuthorizing,
        healthKitLoader: HealthKitLoading,
        healthKitRecording: HealthKitRecording,
        uuid: UUIDProviding,
        cache: Cache
    ) {
        self.healthKitChecker = healthKitChecker
        self.healthKitAuthorizer = healthKitAuthorizer
        self.healthKitLoader = healthKitLoader
        self.healthKitRecording = healthKitRecording
        self.uuid = uuid
        self.cache = cache
    }

    // MARK: - Load

    // TODO: Load from cache as well 🚧
    public func load() async -> [PlankRecord] {
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

    public func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws {
        let id = uuid.get()

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
