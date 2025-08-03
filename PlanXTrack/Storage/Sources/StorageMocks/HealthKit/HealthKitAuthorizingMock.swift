//
//  HealthKitAuthorizingMock.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

import Storage

final class HealthKitAuthorizingMock: HealthKitAuthorizing {
    private let result: Result<Void, StorageError>

    init(_ result: Result<Void, StorageError>) {
        self.result = result
    }

    func authorize() throws {
        if case .failure(let error) = result {
            throw error
        }
    }
}

extension HealthKitAuthorizing where Self == HealthKitAuthorizingMock {
    static var success: Self {
        .init(.success(()))
    }
    static var failure: Self {
        .init(.failure(StorageError.unauthorizedHealthKitAccess))
    }
}
