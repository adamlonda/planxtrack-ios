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

    public func loadHealthKit() async -> [PlankRecord] {
        let plankPredicate = HKQuery.predicateForWorkouts(with: .coreTraining)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(plankPredicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)]
        )
        guard let workouts = try? await exec.execute(descriptor, with: healthStore) else {
            return []
        }
        return workouts
            .filter { $0.hasPlanXTrackBrand }
            .compactMap { $0.plankRecord }
    }
}

extension HKWorkout {
    var plankRecord: PlankRecord? {
        guard
            let stringID = metadata?[.recordID] as? String,
            let id = PlankRecord.ID(uuidString: stringID)
        else {
            return nil
        }
        return .init(
            id: id,
            date: .init(endDate),
            duration: .init(endDate.secondsSince(startDate)),
            feedback: .init(rawValue: nil)
        )
    }

    var hasPlanXTrackBrand: Bool {
        metadata?[HKMetadataKeyWorkoutBrandName] as? String == .brandName
    }
}
