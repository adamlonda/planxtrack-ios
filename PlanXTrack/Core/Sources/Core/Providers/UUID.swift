//
//  UUID.swift
//  Core
//
//  Created by Adam Londa on 01.02.2025.
//

import Foundation

public protocol UUIDProviding: Sendable {
    func get() -> UUID
}

public final class LiveUUIDProviding: UUIDProviding {
    public init() { }

    public func get() -> UUID {
        UUID()
    }
}

// periphery:ignore
public final class UUIDProvidingMock: UUIDProviding {
    public let uuid: UUID

    public init(uuid: UUID) {
        self.uuid = uuid
    }

    public func get() -> UUID {
        uuid
    }
}

public extension UUIDProviding where Self == LiveUUIDProviding {
    static var live: Self {
        .init()
    }
}

public extension UUIDProviding where Self == UUIDProvidingMock {
    static func mock(uuid: UUID = UUID()) -> Self {
        .init(uuid: uuid)
    }
}
