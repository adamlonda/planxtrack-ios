//
//  HealthKitAvailabilityChecking.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

public protocol HealthKitAvailabilityChecking: Sendable {
    var isHealthKitAvailable: Bool { get }
}
