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
    // MARK: - HealthKit Load

    @Test func loadHealthKitNotAvailable() async {
        let sut = LivePlanxStorage.with(healthKitChecker: .unavailable)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadHealthKitUnauthorized() async {
        let sut = LivePlanxStorage.with(healthKitAuthorizer: .failure)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadHealthKitSuccess() async {
        let sut = LivePlanxStorage.with(healthKitLoader: .empty)
        let records = await sut.load()
        #expect(records.isEmpty)
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
