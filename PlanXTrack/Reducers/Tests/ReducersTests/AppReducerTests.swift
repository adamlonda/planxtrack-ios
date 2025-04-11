//
//  AppReducerTests.swift
//  Reducers
//
//  Created by Adam Londa on 17.11.2024.
//

import Core
import CoreTesting
import Dependencies
@testable import Reducers
import StorageMocks
import Testing

@MainActor struct AppReducerTests {
    @Test func onAppearEmpty() async {
        let store = withDependencies {
            $0.planxStorage = .emptyLoad
        } operation: {
            Store<AppReducer>(initialState: .idle)
        }
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .loaded([]))
    }
}
