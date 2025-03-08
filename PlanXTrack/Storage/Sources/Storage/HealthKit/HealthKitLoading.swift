//
//  HealthKitLoading.swift
//  Storage
//
//  Created by Adam Londa on 27.12.2024.
//

import Model

public protocol HealthKitLoading: Sendable {
    func load() async -> [PlankRecord]
}
