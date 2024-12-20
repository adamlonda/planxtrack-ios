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
        case healthKitNotAvailable
        case unauthorizedHealthKitAccess
    }
    public enum Action: Sendable {
        case onAppear
        case display([PlankRecord])
        case healthKitNotAvailable
        case unauthorizedHealthKitAccess
        case unknownError
    }
    @Inject var storage: PlanxStorage

    // MARK: - Reduce Methods

    public func reduce(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return reduceOnAppear(&state)
        case .display(let records):
            return reduceDisplay(&state, records: records)
        case .healthKitNotAvailable:
            return reduceHealthKitNotAvailable(&state)
        case .unauthorizedHealthKitAccess:
            return reduceUnauthorizedHealthKitAccess(&state)
        case .unknownError:
            return .none
        }
    }

    private func reduceOnAppear(_ state: inout State) -> Effect<Action> {
        state = .loading
        return .async { [weak self] in
            do {
                let records = try await self?.storage.load()
                return .display(records ?? [])
            } catch StorageError.healthKitNotAvailable {
                return .healthKitNotAvailable
            } catch StorageError.unauthorizedHealthKitAccess {
                return .unauthorizedHealthKitAccess
            } catch {
                return .unknownError
            }
        }
    }

    private func reduceDisplay(_ state: inout State, records: [PlankRecord]) -> Effect<Action> {
        state = .loaded(records)
        return .none
    }

    private func reduceHealthKitNotAvailable(_ state: inout State) -> Effect<Action> {
        state = .healthKitNotAvailable
        return .none
    }

    private func reduceUnauthorizedHealthKitAccess(_ state: inout State) -> Effect<Action> {
        state = .unauthorizedHealthKitAccess
        return .none
    }
}
