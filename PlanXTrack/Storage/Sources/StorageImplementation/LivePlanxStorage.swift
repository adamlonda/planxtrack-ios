//
//  LivePlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 17.11.2024.
//

import Model
import Storage

public final class LivePlanxStorage: PlanxStorage {
    private let checker: AvailabilityChecking
    private let authorizer: Authorizing

    public init(checker: AvailabilityChecking, authorizer: Authorizing) {
        self.checker = checker
        self.authorizer = authorizer
    }

    public func load() async throws -> [PlankRecord] {
        guard checker.isHealthKitAvailable else {
            throw StorageError.healthKitNotAvailable
        }
        try await authorizer.authorizeHealthKit()
        return [] // TODO: Real data 🚧
    }
}
