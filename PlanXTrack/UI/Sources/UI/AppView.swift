//
//  AppView.swift
//  UI
//
//  Created by Adam Londa on 16.11.2024.
//

import Core
import Dependencies
import Model
import ModelMocks
import Reducers
import Storage
import StorageMocks
import SwiftUI

public struct AppView: View {
    @State private var store: Store<AppReducer>

    public init(store: Store<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        content
            .padding()
            .onAppear {
                store.send(.onAppear)
            }
    }

    @ViewBuilder var content: some View {
        switch store.state {
        case .idle:
            Text("Should not be visible")
        case .loading:
            Text("Loading")
        case .loaded([]):
            Text("No data, yet")
        case .loaded(let data):
            Text("Loaded \(data.count) items")
        case .error(let error):
            Text("An error occurred: \(error.localizedDescription)")
        }
    }
}

// MARK: - Previews

fileprivate extension AppView {
    init(_ planxStorage: PlanxStorage) {
        self.init(
            store: withDependencies {
                $0.planxStorage = planxStorage
            } operation: {
                Store<AppReducer>(initialState: .idle)
            }
        )
    }
}

#Preview("Empty") {
    AppView(.loadSuccessful([]))
}

#Preview("Loaded") {
    let now = Date.now
    let items = [
        PlankRecord.today(now: now, feedback: .perfect),
        PlankRecord.yesterday(now: now, calendar: .current, feedback: .hard)
    ]
    AppView(.loadSuccessful(items))
}

#Preview("Loading Error") {
    AppView(.loadFailed(.unauthorizedHealthKitAccess))
}

#Preview("Loading") {
    AppView(.neverLoading)
}
