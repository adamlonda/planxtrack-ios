//
//  LiveHealthKitAvailabilityChecking.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import HealthKit
import Storage

public final class LiveHealthKitAvailabilityChecking: HealthKitAvailabilityChecking {
    public init() {}

    public var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
}
