//
//  GridRippleEffectView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 12.12.2024.
//

import SwiftUI

struct GridRippleEffectView: View {
    // State to track animation progress
    @State private var time: CGFloat = 0

    // Grid configuration
    let columns: Int = 4
    let rows: Int = 5

    // Animation configuration
    let animationSpeed: CGFloat = 2.5
    let waveLength: CGFloat = 2.0
    let amplitude: CGFloat = 1.0

    // Timer for continuous animation
    let timer = Timer.publish(every: 0.015, on: .main, in: .common).autoconnect() // ~60fps

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: columns), spacing: 15) {
                ForEach(0..<(columns * rows), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue)
                        .aspectRatio(1, contentMode: .fit)
                        .scaleEffect(scale(for: index))
                        .opacity(opacity(for: index))
                        .animation(
                            .spring(
                                response: 0.3,
                                dampingFraction: 0.6,
                                blendDuration: 1
                            ),
                            value: time
                        )
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            time += 0.016 * animationSpeed
        }
    }

    private func getPosition(for index: Int) -> CGPoint {
        let x = CGFloat(index % columns)
        let y = CGFloat(index / columns)
        return CGPoint(x: x, y: y)
    }

    private func waveValue(for index: Int) -> CGFloat {
        let position = getPosition(for: index)
        let distance = sqrt(position.x * position.x + position.y * position.y)
        let wave = sin(distance / waveLength - time)
        return wave * amplitude
    }

    private func scale(for index: Int) -> CGFloat {
        let wave = waveValue(for: index)
        return 1.0 + (wave + 1.0) * 0.06 // Scale between 1.0 and 1.3
    }

    private func opacity(for index: Int) -> CGFloat {
        let wave = waveValue(for: index)
        return 1.0 - (wave + 1.0) * 0.3 // Opacity between 0.4 and 1.0
    }
}

#Preview {
    GridRippleEffectView()
}
