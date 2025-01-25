//
//  LiveLoading.swift
//  Storage
//
//  Created by Adam Londa on 28.12.2024.
//

import Core
import HealthKit
import Model
import Storage

public final class LiveLoading: Loading {
    private let healthStore: HKHealthStore
    private let exec: Execution
    private let calendar: CalendarProviding

    public init(healthStore: HKHealthStore, exec: Execution, calendar: CalendarProviding) {
        self.healthStore = healthStore
        self.exec = exec
        self.calendar = calendar
    }

    public func load() async throws -> [PlankRecord] {
        let now = calendar.now
        let threeWeeksAgo = calendar.current.date(byAdding: .day, value: -21, to: now)!

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
