//
//  AppReducerTests.swift
//  Reducers
//
//  Created by Adam Londa on 17.11.2024.
//

import Core
import CoreAssemble
import CoreTesting
@testable import Reducers
import Storage
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

    @Test func onAppearHealthKitNotAvailable() async {
        let store = Store<AppReducer>(initialState: .idle, dependencies: await .mocked(with: .healthKitNotAvailable))
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .healthKitNotAvailable)
    }

    @Test func onAppearUnauthorizedHealthKitAccess() async {
        let store = Store<AppReducer>(
            initialState: .idle,
            dependencies: await .mocked(with: .unauthorizedHealthKitAccess)
        )
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .unauthorizedHealthKitAccess)
    }

    @Test func onAppearLoadingError() async {
        let store = Store<AppReducer>(initialState: .idle, dependencies: await .mocked(with: .loadingError))
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .loadingError)
    }
}
