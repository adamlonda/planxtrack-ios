//
//  LiveHealthKitAvailabilityChecking.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import HealthKit
import Storage

final class LiveHealthKitAvailabilityChecking: HealthKitAvailabilityChecking {
    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
}
