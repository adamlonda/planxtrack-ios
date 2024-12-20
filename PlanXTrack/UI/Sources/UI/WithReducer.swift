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
    private let dependencyBuild: () async -> Dependencies
    private let viewToDisplay: (Store<R>) -> ViewToDisplay

    init(
        _ initialState: R.State,
        dependencies: @escaping () async -> Dependencies,
        @ViewBuilder display: @escaping (Store<R>) -> ViewToDisplay
    ) {
        self.initialState = initialState
        self.dependencyBuild = dependencies
        self.viewToDisplay = display
    }

    var body: some View {
        content.task {
            store = .init(initialState: initialState, dependencies: await dependencyBuild())
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
