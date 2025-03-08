//
//  StorageTests.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import Core
import Foundation
import Model
import Storage
import StorageImplementation
@testable import StorageMocks
import Testing

struct StorageTests {
    // MARK: - HealthKit Load

    @Test func loadHealthKitNotAvailable() async {
        let sut = LivePlanxStorage(healthKitChecker: .unavailable)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadHealthKitUnauthorized() async {
        let sut = LivePlanxStorage(healthKitAuthorizer: .failure)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadHealthKitSuccess() async {
        let sut = LivePlanxStorage(healthKitLoader: .empty)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    // MARK: - HealthKit Record

    @Test(arguments: zip([nil] + Feedback.allCases, [HealthKitRecordingSpy.success, .healthKitNotRecorded]))
    func healthKitRecord(feedback: Feedback?, healthKitRecordingSpy: HealthKitRecordingSpy) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let sut = LivePlanxStorage(healthKitRecording: healthKitRecordingSpy, uuid: .mock(uuid: uuid))
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            HealthKitRecordingSpy.Call(
                start: date.addingTimeInterval(-duration), end: date, id: uuid, feedback: feedback?.rawValue ?? ""
            )
        ]
        #expect(await healthKitRecordingSpy.calls == expectedCalls)
    }

    // MARK: - Cache Record

    @Test(arguments: [nil] + Feedback.allCases)
    func cacheRecordSuccess(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let cacheSpy = CacheSpy.empty
        let sut = LivePlanxStorage(uuid: .mock(uuid: uuid), cache: cacheSpy)
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            CacheSpy.Call.save(
                .init(id: .init(uuid), date: .init(date), duration: .init(.init(duration)), feedback: .init(feedback))
            )
        ]
        #expect(await cacheSpy.calls == expectedCalls)
    }

    @Test(arguments: [nil] + Feedback.allCases)
    func cacheRecordError(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now

        let cacheSpy = CacheSpy.saveError
        let sut = LivePlanxStorage(uuid: .mock(uuid: uuid), cache: cacheSpy)
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

extension LivePlanxStorage {
    convenience init(healthKitChecker: HealthKitAvailabilityChecking) {
        self.init(
            healthKitChecker: healthKitChecker,
            healthKitAuthorizer: .success,
            healthKitLoader: .empty,
            healthKitRecording: .success,
            uuid: .mock(),
            cache: .empty
        )
    }

    convenience init(healthKitAuthorizer: HealthKitAuthorizing) {
        self.init(
            healthKitChecker: .available,
            healthKitAuthorizer: healthKitAuthorizer,
            healthKitLoader: .empty,
            healthKitRecording: .success,
            uuid: .mock(),
            cache: .empty
        )
    }

    convenience init(healthKitLoader: HealthKitLoading) {
        self.init(
            healthKitChecker: .available,
            healthKitAuthorizer: .success,
            healthKitLoader: healthKitLoader,
            healthKitRecording: .success,
            uuid: .mock(),
            cache: .empty
        )
    }

    convenience init(healthKitRecording: HealthKitRecording, uuid: UUIDProviding) {
        self.init(
            healthKitChecker: .available,
            healthKitAuthorizer: .success,
            healthKitLoader: .empty,
            healthKitRecording: healthKitRecording,
            uuid: uuid,
            cache: .empty
        )
    }

    convenience init(uuid: UUIDProviding, cache: Cache) {
        self.init(
            healthKitChecker: .available,
            healthKitAuthorizer: .success,
            healthKitLoader: .empty,
            healthKitRecording: .success,
            uuid: uuid,
            cache: cache
        )
    }
}
