//
//  PrototypesApp.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

@main
struct PrototypesApp: App {
    let model = TodoList()
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environment(model)
        }
    }
}
