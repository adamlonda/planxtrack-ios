//
//  ReducerType.swift
//  Core
//
//  Created by Adam Londa on 10.11.2024.
//

public protocol ReducerType {
    associatedtype State: Equatable
    associatedtype Action: Sendable

    init()
    func reduce(state: inout State, action: Action) -> Effect<Action>
}
