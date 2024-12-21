//
//  CustomButtonStyle.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 21.12.2024.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .bold()
            .background(.black)
            .cornerRadius(16)
            .foregroundColor(.white)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

struct CustomButtonStyle: View {
    var body: some View {
        VStack {
            Button {
                // Action
            } label: {
                Label("Preview", systemImage: "play.fill")
            }
            .buttonStyle(.primary)
        }
    }
}

#Preview {
    CustomButtonStyle()
}
