//
//  ReducerType.swift
//  Core
//
//  Created by Adam Londa on 10.11.2024.
//

public protocol ReducerType {
    associatedtype State
    associatedtype Action: Sendable
    associatedtype Dependencies

    func reduce(state: inout State, action: Action) -> Effect<Action>
}
