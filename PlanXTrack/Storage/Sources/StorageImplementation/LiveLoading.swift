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
        let now = Date.now // TODO: Make .now injectable
        let threeWeeksAgo = Calendar.current.date(byAdding: .day, value: -21, to: now)! // TODO: Make Calendar injectable

        let datePredicate = HKQuery.predicateForSamples(
            withStart: threeWeeksAgo,
            end: now,
            options: .strictStartDate
        )
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(datePredicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)]
        )

        do {
            let workouts = try await exec.execute(descriptor, with: healthStore)
            return workouts.planxTrackCoreWorkoutsOnly()
                .map { .init(date: $0.endDate, duration: $0.endDate.timeIntervalSince($0.startDate)) }
        } catch {
            throw StorageError.loadingError
        }
    }
}

fileprivate extension [HKWorkout] {
    func planxTrackCoreWorkoutsOnly() -> Self {
        filter {
            $0.workoutActivityType == .coreTraining
                && $0.metadata?[HKMetadataKeyWorkoutBrandName] as? String == .brandName
        }
    }
}
