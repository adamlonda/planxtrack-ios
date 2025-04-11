//
//  LiveHealthKitRecording.swift
//  Storage
//
//  Created by Adam Londa on 04.01.2025.
//

import Dependencies
import Foundation
import HealthKit
import Storage

actor LiveHealthKitRecording: HealthKitRecording {
    @Dependency(\.hkHealthStore) private var healthStore

    func record(from start: Date, to end: Date, id: UUID, feedback: String) async throws {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .coreTraining

        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: .local())
        let metadata = [
            HKMetadataKeyWorkoutBrandName: String.brandName,
            .recordID: id.uuidString,
            .feedback: feedback
        ]
        try await builder.addMetadata(metadata)

        try await builder.beginCollection(at: start)
        try await builder.endCollection(at: end)

        guard let workout = try await builder.finishWorkout() else {
            throw StorageError.healthKitNotRecorded
        }
        try await healthStore.save(workout)
    }
}
