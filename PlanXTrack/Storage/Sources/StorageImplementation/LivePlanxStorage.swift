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

    func load() async throws -> [PlankRecord] {
        async let healthKitTask = loadHealthKit()
        async let cacheTask = cache.load()

        do {
            let (healthKit, cache) = try await (healthKitTask, cacheTask)
            let merged = Set(healthKit + cache)
            return merged.sorted { $0.date > $1.date }
        } catch {
            let healthKit = await healthKitTask
            if healthKit.isEmpty { throw error }
            return healthKit
        }
    }

    private func loadHealthKit() async -> [PlankRecord] {
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
        try await withThrowingTaskGroup {
            $0.addTask {
                try? await self.healthKitRecording.record(
                    from: date.addingTimeInterval(-duration),
                    to: date,
                    id: id,
                    feedback: feedback?.rawValue ?? ""
                )
            }
            $0.addTask {
                try await self.cache.save(
                    PlankRecord(
                        id: .init(id),
                        date: .init(date),
                        duration: .init(.init(duration)),
                        feedback: .init(feedback)
                    )
                )
            }
            try await $0.waitForAll()
        }
    }
}
