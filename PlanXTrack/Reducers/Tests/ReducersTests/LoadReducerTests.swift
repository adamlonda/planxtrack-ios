//
//  LoadReducerTests.swift
//  Reducers
//
//  Created by Adam Londa on 10.08.2025.
//

import Core
import Dependencies
@testable import Reducers
import StorageMocks
import Testing

@MainActor struct LoadReducerTests {
    // MARK: - HealthKit Errors

    @Test func loadHealthKitNotAvailable() async throws {
        let store = withDependencies {
            $0.healthKitAvailabilityChecking = .unavailable
        } operation: {
            Store<LoadReducer>(initialState: .idle)
        }
        store.send(.load)

        await store.change(of: \.state)
        #expect(store.state == .loaded([]))
    }
}
