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
    public static var runtime: Dependencies {
        get async {
            let factory = await Dependencies()
                .withSingleton(HKHealthStore.self) { HKHealthStore() }
                .withSingleton(HealthKitExecution.self) { LiveHealthKitExecution() }

            await factory
                .withSingleton(HealthKitAvailabilityChecking.self) { LiveHealthKitAvailabilityChecking() }
                .withSingleton(HealthKitAuthorizing.self) {
                    LiveHealthKitAuthorizing(healthStore: await factory.resolve())
                }
                .withSingleton(HealthKitRecording.self) { LiveHealthKitRecording(healthStore: await factory.resolve()) }
                .withSingleton(CalendarProviding.self) { .live }
                .withSingleton(HealthKitLoading.self) {
                    LiveHealthKitLoading(
                        healthStore: await factory.resolve(),
                        exec: await factory.resolve(),
                        calendar: await factory.resolve()
                    )
                }
                .withSingleton(UUIDProviding.self) { .live }
                .withSingleton(Cache.self) { LiveCache() }

            return await factory.withSingleton(PlanxStorage.self) {
                LivePlanxStorage(
                    healthKitChecker: await factory.resolve(),
                    healthKitAuthorizer: await factory.resolve(),
                    healthKitLoader: await factory.resolve(),
                    healthKitRecording: await factory.resolve(),
                    uuid: await factory.resolve(),
                    cache: await factory.resolve()
                )
            }
        }
    }
}

// MARK: - Mocks

extension Dependencies {
    public static var mocked: Dependencies {
        get async {
            await Dependencies.runtime
                .with(PlanxStorage.self) { .emptyLoad }
        }
    }
}
