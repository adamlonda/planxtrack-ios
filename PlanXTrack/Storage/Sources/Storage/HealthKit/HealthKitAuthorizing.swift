//
//  HealthKitAuthorizing.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

public protocol HealthKitAuthorizing: Sendable {
    func authorize() async throws
}
