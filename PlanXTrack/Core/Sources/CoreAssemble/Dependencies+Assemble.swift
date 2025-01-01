//
//  Dependencies+Assemble.swift
//  Core
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
                .withSingleton(Loading.self) {
                    LiveLoading(healthStore: await factory.resolve(), exec: await factory.resolve())
                }

            return await factory.withSingleton(PlanxStorage.self) {
                LivePlanxStorage(
                    checker: await factory.resolve(),
                    authorizer: await factory.resolve(),
                    loader: await factory.resolve()
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
                .with(PlanxStorage.self) { .empty }
        }
    }

    public static func mocked(with storage: PlanxStorage) async -> Dependencies {
        await .mocked
            .with(PlanxStorage.self) { storage }
    }
}
