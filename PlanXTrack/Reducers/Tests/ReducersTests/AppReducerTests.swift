//
//  AppReducerTests.swift
//  Reducers
//
//  Created by Adam Londa on 17.11.2024.
//

import Core
import CoreTesting
import Dependencies
import Foundation
import Model
import ModelMocks
@testable import Reducers
import Storage
import StorageMocks
import Testing

@MainActor struct AppReducerTests {
    @Test(arguments: Feedback.allCasesWithNil)
    func onAppearSuccessfulLoad(feedback: Feedback?) async {
        let now = Date.now
        let today = PlankRecord.today(now: now, feedback: feedback)
        let yesterday = PlankRecord.yesterday(now: now, calendar: Calendar.current, feedback: feedback)
        let expectedRecords: [PlankRecord] = [today, yesterday]

        let store = withDependencies {
            $0.planxStorage = .loadSuccessful(expectedRecords)
        } operation: {
            Store<AppReducer>(initialState: .idle)
        }
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .loaded(expectedRecords))
    }

    @Test func onAppearFailedLoad() async {
        let expectedError = StorageError.unauthorizedHealthKitAccess
        let store = withDependencies {
            $0.planxStorage = .loadFailed(expectedError)
        } operation: {
            Store<AppReducer>(initialState: .idle)
        }
        store.send(.onAppear)

        await store.change(of: \.state)
        #expect(store.state == .loading)

        await store.change(of: \.state)
        #expect(store.state == .error(expectedError.equatable))
    }
}
