//
//  StorageTests.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import Storage
import StorageImplementation
@testable import StorageMocks
import Testing

struct StorageTests {
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
}

// MARK: - Convenience

extension LivePlanxStorage {
    convenience init(checker: AvailabilityChecking) {
        self.init(checker: checker, authorizer: .success, loader: .empty, recording: .success)
    }

    convenience init(authorizer: Authorizing) {
        self.init(checker: .available, authorizer: authorizer, loader: .empty, recording: .success)
    }

    convenience init(loader: Loading) {
        self.init(checker: .available, authorizer: .success, loader: loader, recording: .success)
    }
}
