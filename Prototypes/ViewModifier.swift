//
//  ButtonViewModifier.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 05.01.2025.
//

import SwiftUI

struct SectionHeading: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .bold()
    }
}

struct ButtonViewModifier: View {
    var body: some View {
        Text("Hello, World!")
            .modifier(SectionHeading())
            
    }
}

#Preview {
    ButtonViewModifier()
}
