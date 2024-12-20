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
        await #expect(throws: StorageError.healthKitNotAvailable) {
            try await sut.load()
        }
    }

    @Test func loadUnauthorized() async {
        let sut = LivePlanxStorage(authorizer: .failure)
        await #expect(throws: StorageError.unauthorizedHealthKitAccess) {
            try await sut.load()
        }
    }

    @Test func loadSuccess() async throws {
        let sut = LivePlanxStorage(checker: .available, authorizer: .success)
        let records = try await sut.load()
        #expect(records.isEmpty)
    }
}

extension LivePlanxStorage {
    convenience init(checker: AvailabilityChecking) {
        self.init(checker: checker, authorizer: .success)
    }

    convenience init(authorizer: Authorizing) {
        self.init(checker: .available, authorizer: authorizer)
    }
}
