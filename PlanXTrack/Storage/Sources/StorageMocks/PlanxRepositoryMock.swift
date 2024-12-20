//
//  PlanxRepositoryMock.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Model
import Storage

public final class PlanxRepositoryMock: PlanxRepository {
    public init() {}

    public func load() async -> [PlankRecord] {
        return []
    }
}

extension PlanxRepository where Self == PlanxRepositoryMock {
    public static var mock: Self {
        .init()
    }
}
