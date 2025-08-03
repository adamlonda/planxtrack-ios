//
//  HealthKitRecordingSpy.swift
//  Storage
//
//  Created by Adam Londa on 04.01.2025.
//

import Foundation
import Storage

actor HealthKitRecordingSpy: HealthKitRecording {
    // periphery:ignore
    struct Call: Equatable {
        let start: Date
        let end: Date
        let id: UUID
        let feedback: String
    }
    private(set) var calls: [Call] = []
    private let result: Result<Void, Error>

    init(result: Result<Void, Error>) {
        self.result = result
    }

    func record(from start: Date, to end: Date, id: UUID, feedback: String) async throws {
        calls.append(.init(start: start, end: end, id: id, feedback: feedback))
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

extension HealthKitRecording where Self == HealthKitRecordingSpy {
    static var success: Self {
        .init(result: .success(()))
    }
    static var healthKitNotRecorded: Self {
        .init(result: .failure(StorageError.healthKitNotRecorded))
    }
}
