//
//  LoadingTests.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import Core
import HealthKit
import Model
import Storage
@testable import StorageImplementation
import StorageMocks
import Testing

struct LoadingTests {
    @Test func successfulLoad() async throws {
        let now = Date.now
        let calendar = Calendar.current

        let endToday = now
        let durationToday: TimeInterval = 140

        let endYesterday = calendar.date(byAdding: .day, value: -1, to: endToday)!
        let durationYesterday: TimeInterval = 120

        let endMonthAgo = calendar.date(byAdding: .month, value: -1, to: endToday)!
        let durationMonthAgo: TimeInterval = 60

        let workouts = [
            HKWorkout(activityType: .gymnastics),
            HKWorkout(brandName: "XXX Workout"),
            HKWorkout(duration: durationMonthAgo, end: endMonthAgo),
            HKWorkout(duration: durationYesterday, end: endYesterday),
            HKWorkout(duration: durationToday, end: endToday)
        ]
        let expectedRecords: [PlankRecord] = [
            .init(date: endToday, duration: durationToday),
            .init(date: endYesterday, duration: durationYesterday)
        ]

        let sut = LiveLoading(
            healthStore: HKHealthStore(),
            exec: .success(with: workouts),
            calendar: .mock(calendar: calendar, now: now)
        )
        let result = try await sut.load()

        #expect(result == expectedRecords)
    }

    @Test func failedLoad() async {
        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .failure, calendar: .mock())
        await #expect(throws: StorageError.loadingError) {
            try await sut.load()
        }
    }
}

// MARK: - Convenience

private extension HKWorkout {
    convenience init(
        duration: TimeInterval = 0,
        end: Date = .now,
        activityType: HKWorkoutActivityType = .coreTraining,
        brandName: String = .brandName
    ) {
        self.init(
            activityType: activityType,
            start: end.addingTimeInterval(-duration),
            end: end,
            workoutEvents: nil,
            totalEnergyBurned: nil,
            totalDistance: nil,
            metadata: [HKMetadataKeyWorkoutBrandName: brandName]
        )
    }
}
