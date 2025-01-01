//
//  PlanxStorageMock.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Model
import Storage

public class PlanxStorageMock: PlanxStorage, @unchecked Sendable {
    private let result: Result<[PlankRecord], StorageError>

    init(_ result: Result<[PlankRecord], StorageError>) {
        self.result = result
    }

    public func load() async throws -> [PlankRecord] {
        switch result {
        case .success(let records):
            return records
        case .failure(let error):
            throw error
        }
    }
}

public final class EmptyPlanxStorageMock: PlanxStorageMock, @unchecked Sendable {
    public convenience init() {
        self.init(.success([]))
    }
}

public extension PlanxStorage where Self == PlanxStorageMock {
    static var empty: Self {
        EmptyPlanxStorageMock()
    }

    static var healthKitNotAvailable: Self {
        .init(.failure(.healthKitNotAvailable))
    }

    static var unauthorizedHealthKitAccess: Self {
        .init(.failure(.unauthorizedHealthKitAccess))
    }

    static var loadingError: Self {
        .init(.failure(.loadingError))
    }
}
