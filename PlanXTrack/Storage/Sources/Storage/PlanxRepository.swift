//
//  PlanxRepository.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Model

public protocol PlanxRepository: Sendable {
    func load() async -> [PlankRecord]
}
