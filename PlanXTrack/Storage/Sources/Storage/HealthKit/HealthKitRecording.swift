//
//  HealthKitRecording.swift
//  Storage
//
//  Created by Adam Londa on 04.01.2025.
//

import Foundation

public protocol HealthKitRecording: Sendable {
    func record(from start: Date, to end: Date, id: UUID, feedback: String) async throws
}
