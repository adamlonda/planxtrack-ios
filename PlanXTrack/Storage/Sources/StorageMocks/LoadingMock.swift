//
//  LoadingMock.swift
//  Storage
//
//  Created by Adam Londa on 27.12.2024.
//

import Model
import Storage

final class LoadingMock: Loading {
    private let result: Result<[PlankRecord], StorageError>

    init(result: Result<[PlankRecord], StorageError>) {
        self.result = result
    }

    func load() async throws -> [PlankRecord] {
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Loading where Self == LoadingMock {
    static var empty: Self {
        .init(result: .success([]))
    }
    static var loadingError: Self {
        .init(result: .failure(StorageError.loadingError))
    }
}
