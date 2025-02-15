//
//  PlankRecord+Mocks.swift
//  Model
//
//  Created by Adam Londa on 15.02.2025.
//

import Foundation
import Model

// TODO: Split ⤵️

public extension [PlankRecord] {
    static func todayAndYesterday(now: Date, calendar: Calendar, feedback: Feedback?) -> Self {
        [
            .init(
                id: .init(UUID()),
                date: .init(now),
                duration: .init(rawValue: .init(140)),
                feedback: .init(feedback)
            ),
            .init(
                id: .init(UUID()),
                date: .init(calendar.date(byAdding: .day, value: -1, to: now)!),
                duration: .init(rawValue: .init(120)),
                feedback: .init(feedback)
            )
        ]
    }
}
