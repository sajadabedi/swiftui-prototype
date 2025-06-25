    //
    //  GlobeParticleView.swift
    //  Prototypes
    //
    //  Created by Sajjad Abedi on 25.06.2025.
    //

import SwiftUI

import simd

struct ParticleSphereView: View {
    @State private var time: Double = 0
    let particleCount = 1000
    
    var body: some View {
        
        TimelineView(.animation) { timeline in
            let currentTime = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas {
                context,
                size in
                
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                for i in 0..<particleCount {
                    // Playing around with sqrt(x) to diffrent shape.
                    let theta = Double(i) * .pi * (3.0 - sqrt(7.0)) // golden angle
                    let z = 1.0 - (Double(i) / Double(particleCount - 1)) * 2.0
                    let radius = sqrt(1.0 - z * z)
                    var x = radius * cos(theta)
                    let y = radius * sin(theta)
                        // Rotate around Y-axis
                    let angle = currentTime * 0.5
                    let rotatedX = x * cos(angle) - z * sin(angle)
                    _ = x * sin(angle) + z * cos(angle)
                    x = rotatedX
                    let projectedX = x * 180 + center.x
                    let projectedY = y * 180 + center.y
                    let point = CGPoint(x: projectedX, y: projectedY)
                    
                    context
                        .fill(
                            Path(
                                ellipseIn: CGRect(
                                    origin: point,
                                    size: CGSize(width: 2, height: 2)
                                )
                            ),
                            with: .color(Color(hex: "#F54900"))
                        )
                }
            }
            .background(Color.black)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ParticleSphereView()
}
