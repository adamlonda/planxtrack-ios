//
//  LiveCacheTests.swift
//  Storage
//
//  Created by Adam Londa on 23.02.2025.
//

import Foundation
import Model
import Storage
@testable import StorageImplementation
import Testing

struct LiveCacheTests {
    @Test(arguments: Feedback.allCases + [nil])
    func saveAndLoad(expectedFeedback: Feedback?) throws {
        let now = Date.now
        let calendar = Calendar.current

        let today = PlankRecord.today(now: now, feedback: expectedFeedback)
        let yesterday = PlankRecord.yesterday(now: now, calendar: calendar, feedback: expectedFeedback)

        let sut = LiveCache(nonPersistent: true)

        try sut.save(yesterday)
        try sut.save(today)

        #expect(try sut.load() == [today, yesterday])
    }

    @Test func containerCreationFailed() {
        let sut = LiveCache(container: nil)
        #expect(throws: CacheError.loadError) {
            _ = try sut.load()
        }
        #expect(throws: CacheError.saveError) {
            try sut.save(PlankRecord.today(now: .now, feedback: .none))
        }
    }
}
