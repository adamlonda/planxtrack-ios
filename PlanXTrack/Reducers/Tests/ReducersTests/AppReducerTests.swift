//
//  AppReducerTests.swift
//  Reducers
//
//  Created by Adam Londa on 17.11.2024.
//

import Assemble
import Core
import CoreTesting
@testable import Reducers
import Testing

@MainActor struct AppReducerTests {
    @Test func onAppearEmpty() async {
        let store = Store<AppReducer>(initialState: .idle, dependencies: await .mocked)
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .loaded([]))
    }
}
