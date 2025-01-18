//
//  PlankRecord.swift
//  Model
//
//  Created by Adam Londa on 16.11.2024.
//

import Foundation
import Tagged
import TaggedTime

// TODO: Feedback
public struct PlankRecord: Sendable, Equatable, Identifiable {
    public typealias Duration = Tagged<Self, Seconds<TimeInterval>>
    public typealias Date = Tagged<Self, Foundation.Date>

    public let id: Tagged<Self, UUID>
    public let date: Date
    public let duration: Duration

    public init(id: ID, date: Date, duration: Duration) {
        self.id = id
        self.date = date
        self.duration = duration
    }
}
