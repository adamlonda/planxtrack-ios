//
//  Effect.swift
//  Core
//
//  Created by Adam Londa on 10.11.2024.
//

public enum Effect<Action> {
    case none
    case async(_ execute: @Sendable () async -> Action)
}
