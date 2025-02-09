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
    // MARK: - Load

    @Test func loadHealthKitNotAvailable() async {
        let sut = LivePlanxStorage(checker: .unavailable)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadUnauthorized() async {
        let sut = LivePlanxStorage(authorizer: .failure)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    @Test func loadSuccess() async {
        let sut = LivePlanxStorage(loader: .empty)
        let records = await sut.load()
        #expect(records.isEmpty)
    }

    // MARK: - Record

    @Test(arguments: Feedback.allCases + [nil])
    func recordSuccess(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now
        let recordingSpy: RecordingSpy = .success

        let sut = LivePlanxStorage(recording: recordingSpy, uuid: .mock(uuid: uuid))
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            RecordingSpy.Call(
                start: date.addingTimeInterval(-duration), end: date, id: uuid, feedback: feedback?.rawValue ?? ""
            )
        ]
        #expect(await recordingSpy.calls == expectedCalls)
    }

    @Test(arguments: Feedback.allCases + [nil])
    func failedRecord(feedback: Feedback?) async throws {
        let uuid = UUID()
        let duration: TimeInterval = 120
        let date: Date = .now
        let recordingSpy: RecordingSpy = .healthKitNotRecorded

        let sut = LivePlanxStorage(recording: recordingSpy, uuid: .mock(uuid: uuid))
        try await sut.record(duration: duration, date: date, feedback: feedback)

        let expectedCalls = [
            RecordingSpy.Call(
                start: date.addingTimeInterval(-duration), end: date, id: uuid, feedback: feedback?.rawValue ?? ""
            )
        ]
        #expect(await recordingSpy.calls == expectedCalls)
    }
}

// MARK: - Convenience

extension LivePlanxStorage {
    convenience init(checker: AvailabilityChecking) {
        self.init(checker: checker, authorizer: .success, loader: .empty, recording: .success, uuid: .mock())
    }

    convenience init(authorizer: Authorizing) {
        self.init(checker: .available, authorizer: authorizer, loader: .empty, recording: .success, uuid: .mock())
    }

    convenience init(loader: Loading) {
        self.init(checker: .available, authorizer: .success, loader: loader, recording: .success, uuid: .mock())
    }

    convenience init(recording: Recording, uuid: UUIDProviding) {
        self.init(checker: .available, authorizer: .success, loader: .empty, recording: recording, uuid: uuid)
    }
}
