//
//  StorageTests.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import Dependencies
import Foundation
import Model
import Storage
@testable import StorageImplementation
@testable import StorageMocks
import Testing

struct StorageTests {
    // MARK: - HealthKit Errors

    @Test func loadHealthKitNotAvailable() async throws {
        let sut = LivePlanxStorage.with(healthKitChecker: .unavailable)
        let records = try await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadHealthKitUnauthorized() async throws {
        let sut = LivePlanxStorage.with(healthKitAuthorizer: .failure)
        let records = try await sut.load()
        #expect(records.isEmpty)
    }

    // MARK: - Cache Errors

    @Test func loadCacheErrorWithNoHealthkit() async throws {
        let sut = LivePlanxStorage.with(healthKitLoader: .empty, cache: .loadError)
        await #expect(throws: CacheError.loadError) {
            try await sut.load()
        }
    }

    @Test(arguments: Feedback.allCasesWithNil)
    func loadCacheErrorWithSomeHealthkit(feedback: Feedback?) async throws {
        let now = Date.now
        let expectedRecords: [PlankRecord] = [
            PlankRecord.today(now: now, feedback: feedback),
            PlankRecord.yesterday(now: now, calendar: Calendar.current, feedback: feedback)
        ]
        let sut = LivePlanxStorage.with(healthKitLoader: .some(expectedRecords), cache: .loadError)
        let records = try await sut.load()
        #expect(records == expectedRecords)
    }

    // MARK: - Successful Load

    fileprivate struct Config {
        let healthKitResult: [PlankRecord]
        let cacheResult: [PlankRecord]
        let expected: [PlankRecord]
    }

    @Test(arguments: Feedback.allCasesWithNil)
    func loadSuccess(feedback: Feedback?) async throws {
        let now = Date.now
        let today = PlankRecord.today(now: now, feedback: feedback)
        let yesterday = PlankRecord.yesterday(now: now, calendar: Calendar.current, feedback: feedback)
        let map: [Config] = [
            .init(healthKitResult: [today, yesterday], cacheResult: [today, yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [today, yesterday], cacheResult: [today], expected: [today, yesterday]),
            .init(healthKitResult: [today, yesterday], cacheResult: [yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [today, yesterday], cacheResult: [], expected: [today, yesterday]),
            .init(healthKitResult: [today], cacheResult: [today, yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [today], cacheResult: [today], expected: [today]),
            .init(healthKitResult: [today], cacheResult: [yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [today], cacheResult: [], expected: [today]),
            .init(healthKitResult: [yesterday], cacheResult: [today, yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [yesterday], cacheResult: [today], expected: [today, yesterday]),
            .init(healthKitResult: [yesterday], cacheResult: [yesterday], expected: [yesterday]),
            .init(healthKitResult: [yesterday], cacheResult: [], expected: [yesterday]),
            .init(healthKitResult: [], cacheResult: [today, yesterday], expected: [today, yesterday]),
            .init(healthKitResult: [], cacheResult: [today], expected: [today]),
            .init(healthKitResult: [], cacheResult: [yesterday], expected: [yesterday]),
            .init(healthKitResult: [], cacheResult: [], expected: [])
        ]
        try await withThrowingTaskGroup { group in
            map.forEach { config in
                group.addTask {
                    try await loadSuccessTestWith(config)
                }
            }
            try await group.waitForAll()
        }
    }

    private func loadSuccessTestWith(_ config: Config) async throws {
        let sut = LivePlanxStorage.with(
            healthKitLoader: .some(config.healthKitResult), cache: .loaded(config.cacheResult)
        )
        let records = try await sut.load()
        #expect(records == config.expected)
    }

    // MARK: - HealthKit Record

    @Test(arguments: Feedback.allCasesWithNil)
    func healthKitRecorded(feedback: Feedback?) async throws {
        try await healthKitTestWith(feedback: feedback, healthKitRecording: .success)
    }

    @Test(arguments: Feedback.allCasesWithNil)
    func healthKitNotRecorded(feedback: Feedback?) async throws {
        try await healthKitTestWith(feedback: feedback, healthKitRecording: .healthKitNotRecorded)
    }

    private func healthKitTestWith(feedback: Feedback?, healthKitRecording: HealthKitRecordingSpy) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let sut = LivePlanxStorage.with(healthKitRecording: healthKitRecording, uuid: uuid)
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            HealthKitRecordingSpy.Call(
                start: date.addingTimeInterval(-duration), end: date, id: uuid, feedback: feedback?.rawValue ?? ""
            )
        ]
        #expect(await healthKitRecording.calls == expectedCalls)
    }

    // MARK: - Cache Record

    @Test(arguments: Feedback.allCasesWithNil)
    func cacheRecordSuccess(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let cacheSpy = CacheSpy.empty
        let sut = LivePlanxStorage.with(uuid: uuid, cache: cacheSpy)
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            CacheSpy.Call.save(
                .init(id: .init(uuid), date: .init(date), duration: .init(.init(duration)), feedback: .init(feedback))
            )
        ]
        #expect(await cacheSpy.calls == expectedCalls)
    }

    @Test(arguments: Feedback.allCasesWithNil)
    func cacheRecordError(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let cacheSpy = CacheSpy.saveError
        let sut = LivePlanxStorage.with(uuid: uuid, cache: cacheSpy)
        await #expect(throws: CacheError.saveError) {
            try await sut.record(duration: duration, date: date, feedback: feedback)
        }

        let expectedCalls = [
            CacheSpy.Call.save(
                .init(id: .init(uuid), date: .init(date), duration: .init(.init(duration)), feedback: .init(feedback))
            )
        ]
        #expect(await cacheSpy.calls == expectedCalls)
    }
}

// MARK: - Convenience

private extension LivePlanxStorage {
    static func with(
        healthKitChecker: HealthKitAvailabilityChecking = .available,
        healthKitAuthorizer: HealthKitAuthorizing = .success,
        healthKitLoader: HealthKitLoading = .empty,
        healthKitRecording: HealthKitRecording = .success,
        uuid: UUID = .init(),
        cache: Cache = .empty
    ) -> LivePlanxStorage {
        withDependencies {
            $0.healthKitAvailabilityChecking = healthKitChecker
            $0.healthKitAuthorizing = healthKitAuthorizer
            $0.healthKitLoading = healthKitLoader
            $0.healthKitRecording = healthKitRecording
            $0.uuid = .constant(uuid)
            $0.cache = cache
        } operation: {
            LivePlanxStorage()
        }
    }
}
