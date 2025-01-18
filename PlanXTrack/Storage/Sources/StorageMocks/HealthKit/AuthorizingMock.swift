//
//  AuthorizingMock.swift
//  Storage
//
//  Created by Adam Londa on 22.12.2024.
//

import Storage

final class AuthorizingMock: Authorizing {
    private let result: Result<Void, StorageError>

    init(_ result: Result<Void, StorageError>) {
        self.result = result
    }

    func authorizeHealthKit() throws {
        if case .failure(let error) = result {
            throw error
        }
    }
}

extension Authorizing where Self == AuthorizingMock {
    static var success: Self {
        .init(.success(()))
    }
    static var failure: Self {
        .init(.failure(StorageError.unauthorizedHealthKitAccess))
    }
}
