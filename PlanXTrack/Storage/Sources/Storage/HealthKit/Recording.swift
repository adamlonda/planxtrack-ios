//
//  Recording.swift
//  Storage
//
//  Created by Adam Londa on 04.01.2025.
//

import Foundation

public protocol Recording: Sendable {
    func healthKitRecord(from start: Date, to end: Date, id: UUID, feedback: String) async throws
}
