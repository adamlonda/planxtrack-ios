//
//  Cache.swift
//  Storage
//
//  Created by Adam Londa on 09.02.2025.
//

import Model

public protocol Cache: Sendable {
    func save(_ record: PlankRecord) async throws
    func load() async throws -> [PlankRecord]
}
