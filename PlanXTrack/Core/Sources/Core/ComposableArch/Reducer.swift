//
//  Reducer.swift
//  Core
//
//  Created by Adam Londa on 10.11.2024.
//

public protocol Reducer: Sendable {
    associatedtype State: Equatable, Sendable
    associatedtype Action: Sendable

    init()
    func reduce(state: inout State, action: Action) async -> Effect<Action>
}
