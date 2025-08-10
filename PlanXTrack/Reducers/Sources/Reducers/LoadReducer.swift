//
//  LoadReducer.swift
//  Reducers
//
//  Created by Adam Londa on 10.08.2025.
//

import Convenience
import Core
import Dependencies
import Model
import Storage

@Reducer actor LoadReducer {
    enum State: Equatable, Sendable {
        case idle
        case loaded([PlankRecord])
    }
    enum Action: Sendable {
        case load
    }
    @Dependency(\.healthKitAvailabilityChecking) private var healthKitChecker
}

nonisolated extension LoadReducer {
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}
