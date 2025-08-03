//
//  LiveHealthKitAuthorizing.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

import Dependencies
import HealthKit
import Storage

actor LiveHealthKitAuthorizing: HealthKitAuthorizing {
    @Dependency(\.hkHealthStore) private var healthStore

    private let readTypes: Set<HKSampleType> = [HKObjectType.workoutType()]
    private let writeTypes: Set<HKSampleType> = [HKObjectType.workoutType()]

    func authorize() async throws {
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
        } catch {
            throw StorageError.unauthorizedHealthKitAccess
        }
    }
}
