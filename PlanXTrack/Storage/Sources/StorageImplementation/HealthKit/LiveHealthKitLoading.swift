//
//  LiveHealthKitLoading.swift
//  Storage
//
//  Created by Adam Londa on 28.12.2024.
//

import Dependencies
import HealthKit
import Model
import Storage

actor LiveHealthKitLoading: HealthKitLoading {
    @Dependency(\.hkHealthStore) private var healthStore
    @Dependency(\.healthKitExecution) private var exec
    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar

    func load() async -> [PlankRecord] {
        let now = date.now
        let threeWeeksAgo = calendar.date(byAdding: .day, value: -21, to: now)!

        let datePredicate = HKQuery.predicateForSamples(
            withStart: threeWeeksAgo,
            end: now,
            options: .strictStartDate
        )
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(datePredicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)]
        )
        guard let workouts = try? await exec.execute(descriptor, with: healthStore) else {
            return []
        }
        return workouts
            .filter { $0.workoutActivityType == .coreTraining && $0.hasPlanXTrackBrand }
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
            feedback: .init(rawValue: .init(rawValue: metadata?[.feedback] as? String ?? ""))
        )
    }

    var hasPlanXTrackBrand: Bool {
        metadata?[HKMetadataKeyWorkoutBrandName] as? String == .brandName
    }
}
