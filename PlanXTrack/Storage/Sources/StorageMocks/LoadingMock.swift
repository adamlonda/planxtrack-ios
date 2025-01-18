//
//  LoadingMock.swift
//  Storage
//
//  Created by Adam Londa on 27.12.2024.
//

import Model
import Storage

final class LoadingMock: Loading {
    private let result: [PlankRecord]

    init(result: [PlankRecord]) {
        self.result = result
    }

    func loadHealthKit() async -> [PlankRecord] {
        result
    }
}

extension Loading where Self == LoadingMock {
    static var empty: Self {
        .init(result: [])
    }
}
