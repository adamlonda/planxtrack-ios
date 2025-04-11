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
    private let load: [PlankRecord]
    private let record: Result<Void, StorageError>

    init(load: [PlankRecord], record: Result<Void, StorageError> = .success(())) {
        self.load = load
        self.record = record
    }

    public func load() async -> [PlankRecord] {
        load
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
    static var emptyLoad: Self {
        .init(load: [])
    }
}
