//
//  LiveLoading.swift
//  Storage
//
//  Created by Adam Londa on 28.12.2024.
//

import HealthKit
import Model
import Storage

public final class LiveLoading: Loading {
    private let healthStore: HKHealthStore
    private let exec: Execution

    public init(healthStore: HKHealthStore, exec: Execution) {
        self.healthStore = healthStore
        self.exec = exec
    }

    public func load() async throws -> [PlankRecord] {
        let plankPredicate = HKQuery.predicateForWorkouts(with: .coreTraining)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(plankPredicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: .loadLimit
        )
        do {
            let workouts = try await exec.execute(descriptor, with: healthStore)
            let planxTrackWorkouts = workouts.filter {
                $0.metadata?[HKMetadataKeyWorkoutBrandName] as? String == "PlanXTrack"
            }
            return planxTrackWorkouts.map {
                PlankRecord(date: $0.endDate, duration: $0.endDate.timeIntervalSince($0.startDate))
            }
        } catch {
            throw StorageError.loadingError
        }
    }
}
