//
//  LivePlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 17.11.2024.
//

import Core
import Foundation
import Model
import Storage

public final class LivePlanxStorage: PlanxStorage {
    private let checker: AvailabilityChecking
    private let authorizer: Authorizing
    private let loader: Loading

    private let recording: Recording
    private let uuid: UUIDProviding

    // MARK: - Init

    public init(
        checker: AvailabilityChecking,
        authorizer: Authorizing,
        loader: Loading,
        recording: Recording,
        uuid: UUIDProviding
    ) {
        self.checker = checker
        self.authorizer = authorizer
        self.loader = loader
        self.recording = recording
        self.uuid = uuid
    }

    // MARK: - Load

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

    // MARK: - Record

    public func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws {
        do {
            try await recording.healthKitRecord(
                from: date.addingTimeInterval(-duration),
                to: date,
                id: uuid.get(),
                feedback: feedback?.rawValue ?? ""
            )
        } catch {
        }
        // TODO: Caching 🚧
    }
}
