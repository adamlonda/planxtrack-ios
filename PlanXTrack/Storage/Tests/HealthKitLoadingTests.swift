//
//  HealthKitLoadingTests.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import Dependencies
import HealthKit
import Model
import ModelMocks
import Storage
@testable import StorageImplementation
import StorageMocks
import Testing

struct HealthKitLoadingTests {

    // MARK: - Success

    @Test(arguments: Feedback.allCasesWithNil)
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

        let sut = LiveHealthKitLoading.with(exec: .success(with: workouts), now: now, calendar: calendar)
        let result = await sut.load()

        #expect(result == expectedRecords)
    }

    // MARK: - Fail

    @Test func failedHealthKitLoad() async {
        let sut = LiveHealthKitLoading.with(exec: .failure)
        let result = await sut.load()
        #expect(result.isEmpty)
    }
}

// MARK: - Convenience

private extension LiveHealthKitLoading {
    static func with(
        exec: HealthKitExecution,
        now: Date = .now,
        calendar: Calendar = .current
    ) -> LiveHealthKitLoading {
        withDependencies {
            $0.healthKitExecution = exec
            $0.date.now = now
            $0.calendar = calendar
        } operation: {
            LiveHealthKitLoading()
        }
    }
}

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
