//
//  Calendar.swift
//  Core
//
//  Created by Adam Londa on 19.01.2025.
//

import Foundation

public protocol CalendarProviding: Sendable {
    var current: Calendar { get }
    var now: Date { get }
}

public final class LiveCalendarProviding: CalendarProviding {
    public var current: Calendar { .current }
    public var now: Date { .now }
}

// periphery:ignore
public final class CalendarProvidingMock: CalendarProviding {
    public let current: Calendar
    public let now: Date

    public init(calendar: Calendar, now: Date) {
        self.current = calendar
        self.now = now
    }
}

public extension CalendarProviding where Self == LiveCalendarProviding {
    static var live: Self {
        .init()
    }
}

public extension CalendarProviding where Self == CalendarProvidingMock {
    static func mock(calendar: Calendar = .current, now: Date = .now) -> Self {
        .init(calendar: calendar, now: now)
    }
}
