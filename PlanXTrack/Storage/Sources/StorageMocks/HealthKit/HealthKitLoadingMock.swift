//
//  HealthKitLoadingMock.swift
//  Storage
//
//  Created by Adam Londa on 27.12.2024.
//

import Model
import Storage

final class HealthKitLoadingMock: HealthKitLoading {
    private let result: [PlankRecord]

    init(result: [PlankRecord]) {
        self.result = result
    }

    func load() async -> [PlankRecord] {
        result
    }
}

extension HealthKitLoading where Self == HealthKitLoadingMock {
    static var empty: Self {
        .init(result: [])
    }
}
