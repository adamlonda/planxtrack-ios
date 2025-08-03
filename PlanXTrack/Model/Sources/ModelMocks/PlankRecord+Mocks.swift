//
//  PlankRecord+Mocks.swift
//  Model
//
//  Created by Adam Londa on 15.02.2025.
//

import Foundation
import Model

public extension PlankRecord {
    static func today(now: Foundation.Date, feedback: Model.Feedback?) -> Self {
        .init(
            id: .init(UUID()),
            date: .init(now),
            duration: .init(rawValue: .init(140)),
            feedback: .init(feedback)
        )
    }

    static func yesterday(now: Foundation.Date, calendar: Calendar, feedback: Model.Feedback?) -> Self {
        .init(
            id: .init(UUID()),
            date: .init(calendar.date(byAdding: .day, value: -1, to: now)!),
            duration: .init(rawValue: .init(120)),
            feedback: .init(feedback)
        )
    }
}
