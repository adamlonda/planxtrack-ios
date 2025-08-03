//
//  DependencyValues.swift
//  Storage
//
//  Created by Adam Londa on 13.04.2025.
//

import Dependencies
import HealthKit
import Storage

extension DependencyValues {
    var healthKitAvailabilityChecking: HealthKitAvailabilityChecking {
        get { self[HealthKitAvailabilityCheckingValueKey.self] }
        set { self[HealthKitAvailabilityCheckingValueKey.self] = newValue }
    }

    var hkHealthStore: HKHealthStore {
        get { self[HKHealthStoreValueKey.self] }
        set { self[HKHealthStoreValueKey.self] = newValue }
    }

    var healthKitAuthorizing: HealthKitAuthorizing {
        get { self[HealthKitAuthorizingValueKey.self] }
        set { self[HealthKitAuthorizingValueKey.self] = newValue }
    }

    var healthKitLoading: HealthKitLoading {
        get { self[HealthKitLoadingValueKey.self] }
        set { self[HealthKitLoadingValueKey.self] = newValue }
    }

    var healthKitExecution: HealthKitExecution {
        get { self[HealthKitExecutionValueKey.self] }
        set { self[HealthKitExecutionValueKey.self] = newValue }
    }

    var healthKitRecording: HealthKitRecording {
        get { self[HealthKitRecordingValueKey.self] }
        set { self[HealthKitRecordingValueKey.self] = newValue }
    }

    var cache: Cache {
        get { self[CacheValueKey.self] }
        set { self[CacheValueKey.self] = newValue }
    }

    public var planxStorage: PlanxStorage {
        get { self[PlanxStorageValueKey.self] }
        set { self[PlanxStorageValueKey.self] = newValue }
    }
}
