//
//  PlankRecordCacheModel.swift
//  Storage
//
//  Created by Adam Londa on 23.02.2025.
//

import Foundation
import Model
import SwiftData

@Model final class PlankRecordCacheModel {
    @Attribute(.unique) var id: UUID
    var date: Date
    var duration: TimeInterval
    var feedback: String

    init(from plankRecord: PlankRecord) {
        self.id = plankRecord.id.rawValue
        self.date = plankRecord.date.rawValue
        self.duration = plankRecord.duration.rawValue.rawValue
        self.feedback = plankRecord.feedback.rawValue?.rawValue ?? ""
    }
}

extension PlankRecord {
    init(from cacheModel: PlankRecordCacheModel) {
        self.init(
            id: .init(rawValue: cacheModel.id),
            date: .init(cacheModel.date),
            duration: .init(.init(rawValue: cacheModel.duration)),
            feedback: .init(.init(rawValue: cacheModel.feedback))
        )
    }
}
