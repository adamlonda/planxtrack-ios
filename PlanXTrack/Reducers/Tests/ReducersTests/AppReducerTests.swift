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

@MainActor class AppReducerTests {
    init() async {
        await Dependencies.global.mockedSetup()
    }

    deinit {
        Task { await Dependencies.global.clear() }
    }

    @Test func onAppearEmpty() async {
        let store = Store<AppReducer>(initialState: .idle)
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .loaded([]))
    }
}
