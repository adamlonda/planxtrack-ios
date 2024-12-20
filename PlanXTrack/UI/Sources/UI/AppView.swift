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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    WithReducer(.idle,
        dependencies: { await .mocked },
        display: { AppView(store: $0) }
    )
}
