//
//  Dependencies+Assemble.swift
//  Assemble
//
//  Created by Adam Londa on 20.12.2024.
//

import Core
import HealthKit
import Storage
import StorageImplementation
import StorageMocks

// MARK: - Runtime

extension Dependencies {
    public func runtimeSetup() async {
        await self
            .withSingleton(HKHealthStore.self) { HKHealthStore() }
            .withSingleton(Execution.self) { LiveExecution() }
            .withSingleton(AvailabilityChecking.self) { LiveAvailabilityChecking() }
            .withSingleton(CalendarProviding.self) { .live }
            .withSingleton(UUIDProviding.self) { .live }
            .withSingleton(Authorizing.self) { LiveAuthorizing() }
            .withSingleton(Loading.self) { LiveLoading() }

        await self.withSingleton(Recording.self) { LiveRecording(healthStore: await self.resolve()) }
        await self.withSingleton(PlanxStorage.self) {
            LivePlanxStorage(
                checker: await self.resolve(),
                authorizer: await self.resolve(),
                loader: await self.resolve(),
                recording: await self.resolve(),
                uuid: await self.resolve()
            )
        }
    }
}

// MARK: - Mocks

extension Dependencies {
    public func mockedSetup() async {
        await self.runtimeSetup()
        self.with(PlanxStorage.self) { .emptyLoad }
    }
}
