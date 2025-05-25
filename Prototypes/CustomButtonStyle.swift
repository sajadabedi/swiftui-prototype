//
//  CustomButtonStyle.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 21.12.2024.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let gradientColors = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink])
    @State var isAnimating: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .padding()
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        AngularGradient(
                            gradient: gradientColors,
                            center: .center,
                            angle: .degrees(isAnimating ? 360 : 0)), lineWidth: 16
                    )
                    .blur(radius: 10)
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.6), lineWidth: 2)
            )
            .cornerRadius(16)
            .foregroundColor(.primary)
            .onAppear{
                withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                    isAnimating.toggle()
                }
            }
            
            
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var intelligent: PrimaryButtonStyle { PrimaryButtonStyle() }
}

struct CustomButtonStyle: View {
    var body: some View {
        VStack {
            Button {
                // Action
            } label: {
                Label("Build with AI", systemImage: "apple.intelligence")
            }
            .buttonStyle(.intelligent)
                
        }
    }
}

#Preview {
    CustomButtonStyle()
}
