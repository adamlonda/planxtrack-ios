//
//  StorageError.swift
//  Storage
//
//  Created by Adam Londa on 20.12.2024.
//

public enum StorageError: Error {
    case healthKitNotAvailable
    case unauthorizedHealthKitAccess
    case loadingError
}
