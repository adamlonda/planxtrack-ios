//
//  Dependencies+Assemble.swift
//  Core
//
//  Created by Adam Londa on 20.12.2024.
//

import Core
import Storage
import StorageImplementation
import StorageMocks

extension Dependencies {
    public static var runtime: Self {
        get async {
            await .init()
                .withSingleton(PlanxRepository.self) { LivePlanxRepository() }
        }
    }
}

extension Dependencies {
    public static var mocked: Self {
        get async {
            await .runtime
                .with(PlanxRepository.self) { .mock }
        }
    }
}
