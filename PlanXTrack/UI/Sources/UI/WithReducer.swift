//
//  WithReducer.swift
//  UI
//
//  Created by Adam Londa on 20.12.2024.
//

import Core
import SwiftUI

struct WithReducer<R: ReducerType, ViewToDisplay: View>: View {
    @State private var store: Store<R>?

    private let initialState: R.State
    private let dependenciesSetup: () async -> Void
    private let viewToDisplay: (Store<R>) -> ViewToDisplay

    init(
        _ initialState: R.State,
        dependenciesSetup: @escaping () async -> Void,
        @ViewBuilder display: @escaping (Store<R>) -> ViewToDisplay
    ) {
        self.initialState = initialState
        self.dependenciesSetup = dependenciesSetup
        self.viewToDisplay = display
    }

    var body: some View {
        content
            .task {
                await dependenciesSetup()
                store = .init(initialState: initialState)
            }
            .onDisappear {
                Task {
                    await Dependencies.global.clear()
                }
            }
    }

    @ViewBuilder private var content: some View {
        if let store {
            viewToDisplay(store)
        } else {
            Text("Building dependencies...")
        }
    }
}
