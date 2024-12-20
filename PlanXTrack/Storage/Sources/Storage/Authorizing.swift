//
//  Authorizing.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

public protocol Authorizing: Sendable {
    func authorizeHealthKit() async throws
}
