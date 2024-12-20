//
//  AppReducer.swift
//  Reducers
//
//  Created by Adam Londa on 16.11.2024.
//

import Convenience
import Core
import Model
import Storage

@Reducer public final class AppReducer {
    public enum State: Equatable {
        case idle
        case loading
        case loaded([PlankRecord])
    }
    public enum Action: Sendable {
        case onAppear
        case display([PlankRecord])
    }
    @Inject var repository: PlanxRepository

    public func reduce(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state = .loading
            return .async { [weak self] in
                let records = await self?.repository.load()
                return .display(records ?? [])
            }
        case .display(let records):
            state = .loaded(records)
            return .none
        }
    }
}
