//
//  PrototypesApp.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

@main
struct PrototypesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.font,
                     Font.system(.title, design: .rounded)
                )
        }
    }
}
