//
//  Store.swift
//  Core
//
//  Created by Adam Londa on 09.11.2024.
//

import Foundation

@MainActor @Observable public final class Store<R: ReducerType> {
    public private(set) var state: R.State
    private let reducer: R

    public init(initialState: R.State, dependencies: Dependencies) {
        self.state = initialState
        self.reducer = .init(dependencies: dependencies)
    }

    public func send(_ action: R.Action) {
        Task { @MainActor in
            await dispatch(action)
        }
    }

    private func dispatch(_ action: R.Action) async {
        let effect = reducer.reduce(state: &state, action: action)

        switch effect {
        case .none:
            return
        case .async(let execute):
            let newAction = await execute()
            await dispatch(newAction)
        }
    }
}
