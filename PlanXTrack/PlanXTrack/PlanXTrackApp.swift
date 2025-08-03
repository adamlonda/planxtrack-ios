//
//  PlanXTrackApp.swift
//  PlanXTrack
//
//  Created by Adam Londa on 09.11.2024.
//

import Core
import Reducers
import SwiftUI
import UI

@main struct PlanXTrackApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: .init(initialState: .idle))
        }
    }
}
