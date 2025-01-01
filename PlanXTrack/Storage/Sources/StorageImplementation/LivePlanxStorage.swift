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
    private let loader: Loading

    public init(checker: AvailabilityChecking, authorizer: Authorizing, loader: Loading) {
        self.checker = checker
        self.authorizer = authorizer
        self.loader = loader
    }

    public func load() async throws -> [PlankRecord] {
        guard checker.isHealthKitAvailable else {
            throw StorageError.healthKitNotAvailable
        }
        try await authorizer.authorizeHealthKit()
        return try await loader.load()
    }
}
