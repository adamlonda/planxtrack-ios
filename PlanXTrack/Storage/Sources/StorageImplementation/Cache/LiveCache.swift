//
//  LiveCache.swift
//  Storage
//
//  Created by Adam Londa on 15.02.2025.
//

import Foundation
import Model
import Storage
import SwiftData

final class LiveCache: Cache {

    private let container: ModelContainer?

    convenience init() {
        self.init(inMemoryOnly: false)
    }

    convenience init(inMemoryOnly: Bool) {
        let configuration = ModelConfiguration(for: PlankRecordCacheModel.self, isStoredInMemoryOnly: inMemoryOnly)
        self.init(container: try? ModelContainer(for: PlankRecordCacheModel.self, configurations: configuration))
    }

    init(container: ModelContainer?) {
        self.container = container
    }

    func save(_ record: PlankRecord) throws {
        guard let container else {
            throw CacheError.saveError
        }
        let context = ModelContext(container)
        context.insert(PlankRecordCacheModel(from: record))
        try context.save()
    }

    func load() throws -> [PlankRecord] {
        guard let container else {
            throw CacheError.loadError
        }
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<PlankRecordCacheModel>(
            sortBy: [
                SortDescriptor<PlankRecordCacheModel>(\.date, order: .reverse)
            ]
        )
        let cachedRecords: [PlankRecordCacheModel] = try context.fetch(fetchDescriptor)
        return cachedRecords.map { PlankRecord(from: $0) }
    }
}
