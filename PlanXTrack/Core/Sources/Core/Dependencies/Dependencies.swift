//
//  Dependencies.swift
//  Core
//
//  Created by Adam Londa on 15.12.2024.
//

import Foundation

public actor Dependencies {
    public static let global: Dependencies = Dependencies() // TODO: Rename to shared?
    public init() {}

    private(set) var factories = [String: @Sendable () async -> Sendable]()
    private(set) var singletons = [String: Sendable]()

    // MARK: - Registration

    @discardableResult public func with<T: Sendable>(
        _ type: T.Type,
        factory: @escaping @Sendable () async -> T
    ) -> Self {
        let key = String(describing: type)
        singletons[key] = nil
        factories[key] = factory
        return self
    }

    @discardableResult public func withSingleton<T: Sendable>(
        _ type: T.Type,
        factory: @escaping () async -> T
    ) async -> Self {
        let key = String(describing: type)
        singletons[key] = await factory()
        factories[key] = nil
        return self
    }

    // MARK: - Clear

    public func clear() {
        singletons.removeAll()
        factories.removeAll()
    }

    // MARK: - Recolving

    public func resolve<T: Sendable>(_ type: T.Type) async -> T {
        let key = String(describing: type)

        if let singleton = singletons[key] as? T {
            return singleton
        }

        if let factory = factories[key] {
            let instance = await factory()
            if let resolvedInstance = instance as? T {
                return resolvedInstance
            }
        }

        fatalError("Unregistered dependency: \(key) ‼️")
    }

    public func resolve<T: Sendable>() async -> T {
        await resolve(T.self)
    }
}
