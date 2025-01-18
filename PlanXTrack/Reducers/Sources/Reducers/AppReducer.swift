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
    @Inject var storage: PlanxStorage

    // MARK: - Reduce Methods

    public func reduce(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return reduceOnAppear(&state)
        case .display(let records):
            return reduceDisplay(&state, records: records)
        }
    }

    private func reduceOnAppear(_ state: inout State) -> Effect<Action> {
        state = .loading
        return .async { [weak self] in
            let records = await self?.storage.load()
            return .display(records ?? [])
        }
    }

    private func reduceDisplay(_ state: inout State, records: [PlankRecord]) -> Effect<Action> {
        state = .loaded(records)
        return .none
    }
}
