//
//  AssembleTests.swift
//  Core
//
//  Created by Adam Londa on 21.12.2024.
//

import Core
import CoreAssemble
import Storage
import StorageImplementation
import StorageMocks
import Testing

struct AssembleTests {
    @Test func availabilityCheckingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(AvailabilityChecking.self) is LiveAvailabilityChecking)
        await #expect(mocked.resolve(AvailabilityChecking.self) is LiveAvailabilityChecking)
    }

    @Test func authorizingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(Authorizing.self) is LiveAuthorizing)
        await #expect(mocked.resolve(Authorizing.self) is LiveAuthorizing)
    }

    @Test func planxStorageType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(PlanxStorage.self) is LivePlanxStorage)
        await #expect(mocked.resolve(PlanxStorage.self) is EmptyPlanxStorageMock)
    }
}
