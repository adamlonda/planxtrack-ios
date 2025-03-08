//
//  LiveHealthKitExecution.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import HealthKit
import Storage

public final class LiveHealthKitExecution: HealthKitExecution {
    public init() {}

    public func execute<T>(
        _ descriptor: HKSampleQueryDescriptor<T>,
        with healthStore: HKHealthStore
    ) async throws -> [T] {
        return try await descriptor.result(for: healthStore)
    }
}
