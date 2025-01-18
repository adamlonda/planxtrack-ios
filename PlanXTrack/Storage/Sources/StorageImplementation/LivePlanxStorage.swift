//
//  LivePlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 17.11.2024.
//

import Foundation
import Model
import Storage

public final class LivePlanxStorage: PlanxStorage {
    private let checker: AvailabilityChecking
    private let authorizer: Authorizing
    private let loader: Loading
    private let recording: Recording

    public init(checker: AvailabilityChecking, authorizer: Authorizing, loader: Loading, recording: Recording) {
        self.checker = checker
        self.authorizer = authorizer
        self.loader = loader
        self.recording = recording
    }

    public func load() async -> [PlankRecord] {
        guard checker.isHealthKitAvailable else {
            return []
        }
        do {
            try await authorizer.authorizeHealthKit()
            return await loader.loadHealthKit()
        } catch {
            return []
        }
    }

    public func record(duration: TimeInterval, date: Date) async throws {
        // TODO: Recording & caching 🚧
    }
}
