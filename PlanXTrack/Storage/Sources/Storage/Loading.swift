//
//  Loading.swift
//  Storage
//
//  Created by Adam Londa on 27.12.2024.
//

import Model

public protocol Loading: Sendable {
    func load() async throws -> [PlankRecord]
}
