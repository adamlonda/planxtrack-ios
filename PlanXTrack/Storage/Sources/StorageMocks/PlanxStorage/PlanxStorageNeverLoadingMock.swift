//
//  PlanxStorageNeverLoadingMock.swift
//  Storage
//
//  Created by Adam Londa on 19.07.2025.
//

import Foundation
import Model
import Storage

// periphery:ignore
public struct PlanxStorageNeverLoadingMock: PlanxStorage {
    public func load() async throws -> [PlankRecord] {
        try await withCheckedThrowingContinuation { _ in
        }
    }

    public func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws {
    }
}

public extension PlanxStorage where Self == PlanxStorageNeverLoadingMock {
   static var neverLoading: Self { .init() }
}
