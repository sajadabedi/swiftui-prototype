//
//  ContentView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!").font(.title).fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
