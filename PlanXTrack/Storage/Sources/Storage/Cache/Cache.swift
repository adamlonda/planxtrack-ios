//
//  Cache.swift
//  Storage
//
//  Created by Adam Londa on 09.02.2025.
//

import Model

public protocol Cache {
    func save(_ record: PlankRecord) throws
    func load() throws -> [PlankRecord]
}
