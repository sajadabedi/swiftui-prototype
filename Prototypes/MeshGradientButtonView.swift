//
//  MeshGradientButtonView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

struct MeshGradientButtonView: View {
    @State var isAnimating: Bool = false
        let colors = (0..<9).map { _ in [Color.green, Color.blue, Color.pink].randomElement()!}
        let colors2 = (0..<9).map { _ in [Color.pink, Color.indigo, Color.blue].randomElement()!}
        var body: some View {
            Button {
                // No action
            } label: {
                Text("Tap me")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(MeshGradient(
                                width: 3,
                                height: 3,
                                points:
                                    [
                                        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
                                        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5),
                                        .init(x: 1, y: 0.5), .init(x: 0, y: 1),
                                        .init(x: 0.5, y: 1), .init(x: 1, y: 1)
                                    ],
                                colors: isAnimating ? colors : colors2),
                                    lineWidth: 6)
                    }
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 16))
                    .onAppear{
                        withAnimation(.easeInOut(duration: 1).repeatForever()) {
                            isAnimating.toggle()
                        }
                    }
                
                
                
            }
            .padding()
        }
}

#Preview {
    MeshGradientButtonView()
}
