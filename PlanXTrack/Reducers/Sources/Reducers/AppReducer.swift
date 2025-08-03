//
//  AppReducer.swift
//  Reducers
//
//  Created by Adam Londa on 16.11.2024.
//

import Convenience
import Core
import Dependencies
import Model
import Storage
import StorageImplementation

@Reducer public actor AppReducer {
    public enum State: Equatable, Sendable {
        case idle
        case loading
        case loaded([PlankRecord])
        case error(EquatableError)
    }
    public enum Action: Sendable {
        case onAppear
        case display(Result<[PlankRecord], Error>)
    }
    @Dependency(\.planxStorage) var storage
}

// MARK: - Reduce Methods

nonisolated extension AppReducer {
    public func reduce(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return reduceOnAppear(&state)
        case .display(let result):
            return reduceDisplay(&state, result: result)
        }
    }

    private func reduceOnAppear(_ state: inout State) -> Effect<Action> {
        state = .loading
        return .async { [weak self] in
            do {
                let records = try await self?.storage.load()
                return .display(.success(records ?? []))
            } catch {
                return .display(.failure(error))
            }
        }
    }

    private func reduceDisplay(_ state: inout State, result: Result<[PlankRecord], Error>) -> Effect<Action> {
        switch result {
        case .success(let records):
            state = .loaded(records)
            return .none
        case .failure(let error):
            state = .error(error.equatable)
            return .none
        }
    }
}
