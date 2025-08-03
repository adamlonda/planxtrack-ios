//
//  HealthKitExecution.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import HealthKit

public protocol HealthKitExecution: Sendable {
    func execute<T>(_ descriptor: HKSampleQueryDescriptor<T>, with healthStore: HKHealthStore) async throws -> [T]
}
