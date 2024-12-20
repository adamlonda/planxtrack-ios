//
//  Store+Observation.swift
//  Core
//
//  Created by Adam Londa on 23.11.2024.
//

import Core
import Observation

extension Store {
    public func change<T>(of keyPath: KeyPath<Store, T>) async {
        return await withCheckedContinuation { continuation in
            withObservationTracking {
                _ = self[keyPath: keyPath]
            } onChange: {
                continuation.resume()
            }
        }
    }
}
