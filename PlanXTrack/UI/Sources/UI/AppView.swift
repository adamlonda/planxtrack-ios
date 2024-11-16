//
//  AppView.swift
//  UI
//
//  Created by Adam Londa on 16.11.2024.
//

import SwiftUI

public struct AppView: View {
    public init() {}
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    AppView()
}
