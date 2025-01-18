//
//  ExecutionMock.swift
//  Storage
//
//  Created by Adam Londa on 30.12.2024.
//

import HealthKit
import Storage

enum MockError: Error {
    case mockError
}

public final class ExecutionMock: Execution {
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
            return workouts as? [T] ?? []
        case .failure:
            throw MockError.mockError
        }
    }
}

public extension Execution where Self == ExecutionMock {
    static func success(with workouts: [HKWorkout]) -> Self {
        .init(result: .success(workouts))
    }

    static var failure: Self {
        .init(result: .failure(.mockError))
    }
}
