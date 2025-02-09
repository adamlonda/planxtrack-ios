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
                .withSingleton(Execution.self) { LiveExecution() }

            await factory
                .withSingleton(AvailabilityChecking.self) { LiveAvailabilityChecking() }
                .withSingleton(Authorizing.self) { LiveAuthorizing(healthStore: await factory.resolve()) }
                .withSingleton(Recording.self) { LiveRecording(healthStore: await factory.resolve()) }
                .withSingleton(CalendarProviding.self) { .live }
                .withSingleton(Loading.self) {
                    LiveLoading(
                        healthStore: await factory.resolve(),
                        exec: await factory.resolve(),
                        calendar: await factory.resolve()
                    )
                }
                .withSingleton(UUIDProviding.self) { .live }

            return await factory.withSingleton(PlanxStorage.self) {
                LivePlanxStorage(
                    checker: await factory.resolve(),
                    authorizer: await factory.resolve(),
                    loader: await factory.resolve(),
                    recording: await factory.resolve(),
                    uuid: await factory.resolve()
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

    public static func mocked(with storage: PlanxStorage) async -> Dependencies {
        await .mocked
            .with(PlanxStorage.self) { storage }
    }
}
