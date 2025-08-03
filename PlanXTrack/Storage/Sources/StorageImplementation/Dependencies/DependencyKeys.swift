//
//  DependencyKeys.swift
//  Storage
//
//  Created by Adam Londa on 13.04.2025.
//

import Dependencies
import HealthKit
import Storage

enum HealthKitAvailabilityCheckingValueKey: DependencyKey {
    static let liveValue: HealthKitAvailabilityChecking = LiveHealthKitAvailabilityChecking()
}

enum HKHealthStoreValueKey: DependencyKey {
    static let liveValue: HKHealthStore = HKHealthStore()
    static let testValue: HKHealthStore = HKHealthStore()
}

enum HealthKitAuthorizingValueKey: DependencyKey {
    static let liveValue: HealthKitAuthorizing = LiveHealthKitAuthorizing()
}

enum HealthKitLoadingValueKey: DependencyKey {
    static let liveValue: HealthKitLoading = LiveHealthKitLoading()
}

enum HealthKitExecutionValueKey: DependencyKey {
    static let liveValue: HealthKitExecution = LiveHealthKitExecution()
}

enum HealthKitRecordingValueKey: DependencyKey {
    static let liveValue: HealthKitRecording = LiveHealthKitRecording()
}

enum CacheValueKey: DependencyKey {
    static let liveValue: Cache = LiveCache()
}

enum PlanxStorageValueKey: DependencyKey {
    static let liveValue: PlanxStorage = LivePlanxStorage()
}
