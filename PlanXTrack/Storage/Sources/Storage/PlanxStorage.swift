//
//  PlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Model

public protocol PlanxStorage: Sendable {
    func load() async throws -> [PlankRecord]
}
