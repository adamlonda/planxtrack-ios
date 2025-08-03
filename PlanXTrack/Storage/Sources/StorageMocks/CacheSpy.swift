//
//  CacheSpy.swift
//  Storage
//
//  Created by Adam Londa on 02.03.2025.
//

import Model
import Storage

actor CacheSpy: Cache {
    enum Call: Equatable {
        case save(PlankRecord)
        case load
    }
    private(set) var calls: [Call] = []

    private let saveResult: Result<Void, CacheError>
    private let loadResult: Result<[PlankRecord], CacheError>

    init(saveResult: Result<Void, CacheError>, loadResult: Result<[PlankRecord], CacheError>) {
        self.saveResult = saveResult
        self.loadResult = loadResult
    }

    func save(_ record: PlankRecord) async throws {
        calls.append(.save(record))
        if case .failure(let error) = saveResult {
            throw error
        }
    }

    func load() async throws -> [PlankRecord] {
        calls.append(.load)
        switch loadResult {
        case .success(let records):
            return records
        case .failure(let error):
            throw error
        }
    }
}

extension Cache where Self == CacheSpy {
    static var empty: Self {
        return .init(saveResult: .success(()), loadResult: .success([]))
    }
    static func loaded(_ records: [PlankRecord]) -> Self {
        .init(saveResult: .success(()), loadResult: .success(records))
    }
    static var saveError: Self {
        return .init(saveResult: .failure(CacheError.saveError), loadResult: .success([]))
    }
    static var loadError: Self {
        return .init(saveResult: .success(()), loadResult: .failure(CacheError.loadError))
    }
}
