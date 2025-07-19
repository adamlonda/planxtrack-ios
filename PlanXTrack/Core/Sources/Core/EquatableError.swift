//
//  EquatableError.swift
//  Core
//
//  Created by Adam Londa on 22.06.2025.
//

public struct EquatableError: Error, Equatable {
    public let error: Error

    init(_ error: Error) {
        self.error = error
    }

    public static func == (lhs: EquatableError, rhs: EquatableError) -> Bool {
        String(reflecting: lhs.error) == String(reflecting: rhs.error)
    }
}

public extension Error {
    var equatable: EquatableError {
        EquatableError(self)
    }
}
