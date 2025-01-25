//
//  PlanXTrackApp.swift
//  PlanXTrack
//
//  Created by Adam Londa on 09.11.2024.
//

import Assemble
import Core
import Reducers
import SwiftUI
import UI

@MainActor class AppDependencies: ObservableObject {
    @Published var loaded: Dependencies?
    init() {
        Task { loaded = await .runtime }
    }
}

@main struct PlanXTrackApp: App {
    @StateObject private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            if let dependencies = dependencies.loaded {
                AppView(
                    store: .init(initialState: .idle, dependencies: dependencies)
                )
            } else {
                ProgressView("Please wait...") // TODO: Localize
            }
        }
    }
}
