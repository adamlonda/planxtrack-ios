//
//  PlankRecord.swift
//  Model
//
//  Created by Adam Londa on 16.11.2024.
//

import Foundation

public struct PlankRecord: Sendable, Equatable {
    public let date: Date
    public let duration: TimeInterval

    public init(date: Date, duration: TimeInterval) {
        self.date = date
        self.duration = duration
    }
}
