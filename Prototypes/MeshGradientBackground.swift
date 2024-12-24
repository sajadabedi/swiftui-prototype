    //
//  MeshGradientBackground.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 23.12.2024.
//

import SwiftUI

struct MeshGradientBackground: View {
    @State var t: Float = 0.0
    @State var timer: Timer?

    var body: some View {
        ZStack{
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [sinInRange(-0.8...(-0.2), 0.439, 1.342, t), sinInRange(0.3...0.7, 3.42, 1.984, t)],
                    [sinInRange(0.1...0.8, 0.239, 1.084, t), sinInRange(0.2...0.8, 5.21, 1.242, t)],
                    [sinInRange(1...1.5, 0.939, 1.084, t), sinInRange(0.4...0.8, 0.25, 1.642, t)],

                    [
                        sinInRange(-0.8...0.0, 1.439, 1.442, t),
                        sinInRange(1.4...1.9, 3.42, 1.984, t)
                    ],
                    [
                        sinInRange(0.3...0.6, 0.339, 1.784, t),
                        sinInRange(1.0...1.2, 1.22, 1.772, t)
                    ],
                    [
                        sinInRange(1.0...1.5, 0.939, 1.056, t),
                        sinInRange(1.3...1.7, 0.47, 1.342, t)
                    ],
                ],
                colors: [
                    .black,
                    .black,
                    .black,
                    .orange,
                    .red,
                    .orange,
                    .indigo,
                    .black,
                    .green
                ],
                background: .black
            )
            .ignoresSafeArea()
        }
        .onAppear {
            // Invalidate any existing timer first
            timer?.invalidate()
            
            // Create a new timer with faster updates
            timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                t += 0.05
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

func sinInRange(_ range: ClosedRange<Float>, _ offset: Float, _ timeScale: Float, _ t: Float) -> Float {
    let amplitude = (range.upperBound - range.lowerBound) / 2
    let midPoint = (range.upperBound + range.lowerBound) / 2
    return midPoint + amplitude * sin(timeScale * t + offset)
}

#Preview {
    MeshGradientBackground()
}
