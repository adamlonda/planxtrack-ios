//
//  Store.swift
//  Core
//
//  Created by Adam Londa on 09.11.2024.
//

import Foundation

@MainActor @Observable public final class Store<R: Reducer> {
    public private(set) var state: R.State
    private let reducer: R

    public init(initialState: R.State) {
        self.state = initialState
        self.reducer = .init()
    }

    public func send(_ action: R.Action) {
        Task { @MainActor in
            await dispatch(action)
        }
    }

    private func dispatch(_ action: R.Action) async {
        var currentState = state
        let effect = reducer.reduce(state: &currentState, action: action)
        state = currentState

        switch effect {
        case .none:
            return
        case .async(let execute):
            let newAction = await execute()
            await dispatch(newAction)
        }
    }
}
