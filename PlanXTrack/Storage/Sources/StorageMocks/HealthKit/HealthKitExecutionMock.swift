//
//  HealthKitExecutionMock.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import HealthKit
import Storage

enum MockError: Error {
    case mockError
}

// periphery:ignore
public final class HealthKitExecutionMock: HealthKitExecution {
    private let result: Result<[HKWorkout], MockError>

    init(result: Result<[HKWorkout], MockError>) {
        self.result = result
    }

    public func execute<T>(
        _ descriptor: HKSampleQueryDescriptor<T>,
        with healthStore: HKHealthStore
    ) async throws -> [T] {
        switch result {
        case .success(let workouts):
            return workouts.filterAndSort(with: descriptor) as? [T] ?? []
        case .failure:
            throw MockError.mockError
        }
    }
}

// MARK: - Filter & Sort

fileprivate extension [HKWorkout] {
    func filterAndSort<T>(with descriptor: HKSampleQueryDescriptor<T>) -> Self {
        guard let descriptor = descriptor as? HKSampleQueryDescriptor<HKWorkout> else {
            return []
        }

        let filtered = filter { workout in
            descriptor.predicates.allSatisfy { predicate in
                predicate.nsPredicate?.evaluate(with: workout) ?? true
            }
        }
        let sorted = descriptor.sortDescriptors.reduce(filtered) { partial, sortDescriptor in
            partial.sorted { lhs, rhs in
                sortDescriptor.compare(lhs, rhs) == .orderedAscending
            }
        }

        return sorted
    }
}

// MARK: - Convenience

public extension HealthKitExecution where Self == HealthKitExecutionMock {
    static func success(with workouts: [HKWorkout]) -> Self {
        .init(result: .success(workouts))
    }

    static var failure: Self {
        .init(result: .failure(.mockError))
    }
}
