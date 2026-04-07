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
            SpinnerView(config: {
                var c = SpinnerConfig()
                c.colorMode  = .rainbow
                c.strokeWidth = 6
                return c
            }())
            .frame(width: 100, height: 100)
        }
    }
}
