//
//  PlanxStorageMock.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Foundation
import Model
import Storage

// periphery:ignore
public class PlanxStorageMock: PlanxStorage, @unchecked Sendable {
    private let load: Result<[PlankRecord], StorageError>
    private let record: Result<Void, StorageError>

    init(
        load: Result<[PlankRecord], StorageError> = .success([]),
        record: Result<Void, StorageError> = .success(())
    ) {
        self.load = load
        self.record = record
    }

    public func load() async throws -> [PlankRecord] {
        switch load {
        case .success(let records):
            return records
        case .failure(let error):
            throw error
        }
    }

    public func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws {
        switch record {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

public extension PlanxStorage where Self == PlanxStorageMock {
    static func loadSuccessful(_ records: [PlankRecord]) -> Self {
        return .init(load: .success(records))
    }
    static func loadFailed(_ error: StorageError) -> Self {
        return .init(load: .failure(error))
    }
}
