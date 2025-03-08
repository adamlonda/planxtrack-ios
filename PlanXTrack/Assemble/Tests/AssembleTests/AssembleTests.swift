//
//  AssembleTests.swift
//  Assemble
//
//  Created by Adam Londa on 21.12.2024.
//

import Assemble
import Core
import HealthKit
import Storage
import StorageImplementation
import StorageMocks
import Testing

struct AssembleTests {
    @Test func healthKitStoreType() async throws {
        let runtime = await Dependencies.runtime
        let store1 = await runtime.resolve(HKHealthStore.self)
        let store2 = await runtime.resolve(HKHealthStore.self)
        #expect(store1 === store2)
    }

    @Test func healthKitExecutionType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(HealthKitExecution.self) is LiveHealthKitExecution)
        await #expect(mocked.resolve(HealthKitExecution.self) is LiveHealthKitExecution)
    }

    @Test func calendarType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(CalendarProviding.self) is LiveCalendarProviding)
        await #expect(mocked.resolve(CalendarProviding.self) is LiveCalendarProviding)
    }

    @Test func uuidType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(UUIDProviding.self) is LiveUUIDProviding)
        await #expect(mocked.resolve(UUIDProviding.self) is LiveUUIDProviding)
    }

    @Test func healthKitAvailabilityCheckingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(HealthKitAvailabilityChecking.self) is LiveHealthKitAvailabilityChecking)
        await #expect(mocked.resolve(HealthKitAvailabilityChecking.self) is LiveHealthKitAvailabilityChecking)
    }

    @Test func healthKitAuthorizingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(HealthKitAuthorizing.self) is LiveHealthKitAuthorizing)
        await #expect(mocked.resolve(HealthKitAuthorizing.self) is LiveHealthKitAuthorizing)
    }

    @Test func healthKitLoadingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(HealthKitLoading.self) is LiveHealthKitLoading)
        await #expect(mocked.resolve(HealthKitLoading.self) is LiveHealthKitLoading)
    }

    @Test func healthKitRecordingType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(HealthKitRecording.self) is LiveHealthKitRecording)
        await #expect(mocked.resolve(HealthKitRecording.self) is LiveHealthKitRecording)
    }

    @Test func cacheType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(Cache.self) is LiveCache)
        await #expect(mocked.resolve(Cache.self) is LiveCache)
    }

    @Test func planxStorageType() async {
        let runtime = await Dependencies.runtime
        let mocked = await Dependencies.mocked
        await #expect(runtime.resolve(PlanxStorage.self) is LivePlanxStorage)
        await #expect(mocked.resolve(PlanxStorage.self) is EmptyLoadPlanxStorageMock)
    }
}
