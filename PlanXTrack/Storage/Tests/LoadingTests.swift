//
//  LoadingTests.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import Core
import HealthKit
import Model
import ModelMocks
@testable import StorageImplementation
import StorageMocks
import Testing

struct LoadingTests {

    // MARK: - Success

    @Test(arguments: Feedback.allCases + [nil])
    func successfulHealthKitLoad(expectedFeedback: Feedback?) async {
        let now = Date.now
        let calendar = Calendar.current

        let today = PlankRecord.today(now: now, feedback: expectedFeedback)
        let yesterday = PlankRecord.yesterday(now: now, calendar: calendar, feedback: expectedFeedback)

        let idToday = today.id.rawValue
        let durationToday = today.duration.rawValue.rawValue
        let endToday = today.date.rawValue

        let idYesterday = yesterday.id.rawValue
        let durationYesterday = yesterday.duration.rawValue.rawValue
        let endYesterday = yesterday.date.rawValue

        let endMonthAgo = calendar.date(byAdding: .month, value: -1, to: today.date.rawValue)!
        let durationMonthAgo: TimeInterval = 60

        let workouts = [
            HKWorkout(duration: durationYesterday, end: endYesterday, activityType: .gymnastics),
            HKWorkout(duration: durationYesterday, end: endYesterday, brandName: "XXX Workout"),
            HKWorkout(duration: durationMonthAgo, end: endMonthAgo),
            HKWorkout(
                id: idYesterday,
                duration: durationYesterday,
                end: endYesterday,
                feedback: expectedFeedback?.rawValue ?? ""
            ),
            HKWorkout(id: idToday, duration: durationToday, end: endToday, feedback: expectedFeedback?.rawValue ?? "")
        ]
        let expectedRecords = [today, yesterday]

        let sut = LiveLoading(
            healthStore: HKHealthStore(),
            exec: .success(with: workouts),
            calendar: .mock(calendar: calendar, now: now)
        )
        let result = await sut.loadHealthKit()

        #expect(result == expectedRecords)
    }

    // MARK: - Fail

    @Test func failedHealthKitLoad() async {
        let sut = LiveLoading(healthStore: HKHealthStore(), exec: .failure, calendar: .mock())
        let result = await sut.loadHealthKit()
        #expect(result.isEmpty)
    }
}

// MARK: - Convenience

private extension HKWorkout {
    convenience init(
        id: UUID = .init(),
        duration: TimeInterval,
        end: Date,
        activityType: HKWorkoutActivityType = .coreTraining,
        brandName: String = .brandName,
        feedback: String = ""
    ) {
        self.init(
            activityType: activityType,
            start: end.addingTimeInterval(-duration),
            end: end,
            workoutEvents: nil,
            totalEnergyBurned: nil,
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: brandName,
                .recordID: id.uuidString,
                .feedback: feedback
            ]
        )
    }
}
