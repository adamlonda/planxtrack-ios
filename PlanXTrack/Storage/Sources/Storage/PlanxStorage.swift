//
//  PlanxStorage.swift
//  Storage
//
//  Created by Adam Londa on 16.11.2024.
//

import Foundation
import Model

// TODO: Replace this with reducers
public protocol PlanxStorage: Sendable {
    func load() async -> [PlankRecord]
    func record(duration: TimeInterval, date: Date, feedback: Feedback?) async throws
}
