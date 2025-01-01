//
//  AppView.swift
//  UI
//
//  Created by Adam Londa on 16.11.2024.
//

import Core
import CoreAssemble
import Reducers
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
        case .healthKitNotAvailable:
            Text("HealthKit not available")
        case .unauthorizedHealthKitAccess:
            Text("Unauthorized HealthKit access")
        case .loadingError:
            Text("Loading error")
        }
    }
}

// MARK: - Previews

#Preview {
    WithReducer(.idle,
        dependencies: { await .mocked },
        display: { AppView(store: $0) }
    )
}
