//
//  PlankRecord.swift
//  Model
//
//  Created by Adam Londa on 16.11.2024.
//

import Foundation
import Tagged
import TaggedTime

public struct PlankRecord: Sendable, Equatable, Identifiable {
    public typealias Duration = Tagged<Self, Seconds<TimeInterval>>
    public typealias Date = Tagged<Self, Foundation.Date>
    public typealias Feedback = Tagged<Self, Model.Feedback?>

    public let id: Tagged<Self, UUID>
    public let date: Date
    public let duration: Duration
    public let feedback: Feedback

    public init(id: ID, date: Date, duration: Duration, feedback: Feedback) {
        self.id = id
        self.date = date
        self.duration = duration
        self.feedback = feedback
    }
}
