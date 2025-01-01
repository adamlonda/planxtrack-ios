//
//  LoadingTests.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import HealthKit
import Model
import Storage
@testable import StorageImplementation
import StorageMocks
import Testing

struct LoadingTests {
    @Test func successfulLoad() async throws {
        let endToday = Date()
        let durationToday: TimeInterval = 140

        let endYesterday = endToday.addingTimeInterval(-24 * 60 * 60)
        let durationYesterday: TimeInterval = 120

        let workouts = [
            HKWorkout(duration: durationToday, end: endToday),
            HKWorkout(duration: durationYesterday, end: endYesterday)
        ]
        let expectedRecords: [PlankRecord] = [
            .init(date: endToday, duration: durationToday),
            .init(date: endYesterday, duration: durationYesterday)
        ]

        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .success(with: workouts))
        let result = try await sut.load()

        #expect(result == expectedRecords)
    }

    @Test func failedLoad() async {
        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .failure)
        await #expect(throws: StorageError.loadingError) {
            try await sut.load()
        }
    }
}

// MARK: - Convenience

private extension HKWorkout {
    convenience init(duration: TimeInterval, end: Date) {
        self.init(
            activityType: .coreTraining,
            start: end.addingTimeInterval(-duration),
            end: end,
            workoutEvents: nil,
            totalEnergyBurned: nil,
            totalDistance: nil,
            metadata: [HKMetadataKeyWorkoutBrandName: String.brandName]
        )
    }
}
