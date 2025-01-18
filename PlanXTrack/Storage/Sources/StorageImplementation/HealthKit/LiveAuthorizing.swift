//
//  LiveAuthorizing.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

import HealthKit
import Storage

public final class LiveAuthorizing: Authorizing {
    private let healthStore: HKHealthStore

    private let readTypes: Set<HKSampleType> = [HKObjectType.workoutType()]
    private let writeTypes: Set<HKSampleType> = [HKObjectType.workoutType()]

    public init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    public func authorizeHealthKit() async throws {
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
        } catch {
            throw StorageError.unauthorizedHealthKitAccess
        }
    }
}
