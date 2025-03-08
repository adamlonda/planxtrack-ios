//
//  HealthKitAvailabilityCheckingMock.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

import Storage

final class HealthKitAvailabilityCheckingMock: HealthKitAvailabilityChecking {
    private let available: Bool

    init(available: Bool) {
        self.available = available
    }

    var isHealthKitAvailable: Bool {
        available
    }
}

extension HealthKitAvailabilityChecking where Self == HealthKitAvailabilityCheckingMock {
    static var available: Self {
        .init(available: true)
    }
    static var unavailable: Self {
        .init(available: false)
    }
}
