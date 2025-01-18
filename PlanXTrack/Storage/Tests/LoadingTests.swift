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
    @Test func successfulHealthKitLoad() async {
        let idToday = UUID()
        let endToday = Date()
        let durationToday: TimeInterval = 140

        let idYesterday = UUID()
        let endYesterday = endToday.addingTimeInterval(-24 * 60 * 60)
        let durationYesterday: TimeInterval = 120

        let workouts = [
            HKWorkout(id: idToday, duration: durationToday, end: endToday),
            HKWorkout(id: idYesterday, duration: durationYesterday, end: endYesterday)
        ]
        let expectedRecords: [PlankRecord] = [
            .init(
                id: .init(idToday),
                date: .init(endToday),
                duration: .init(rawValue: .init(durationToday))
            ),
            .init(
                id: .init(idYesterday),
                date: .init(endYesterday),
                duration: .init(rawValue: .init(durationYesterday))
            )
        ]

        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .success(with: workouts))
        let result = await sut.loadHealthKit()

        #expect(result == expectedRecords)
    }

    @Test func failedHealthKitLoad() async {
        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .failure)
        let result = await sut.loadHealthKit()
        #expect(result.isEmpty)
    }
}

// MARK: - Convenience

private extension HKWorkout {
    convenience init(id: UUID, duration: TimeInterval, end: Date) {
        self.init(
            activityType: .coreTraining,
            start: end.addingTimeInterval(-duration),
            end: end,
            workoutEvents: nil,
            totalEnergyBurned: nil,
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: String.brandName,
                .recordID: id.uuidString
            ]
        )
    }
}
