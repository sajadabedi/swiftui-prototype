//
//  ShimmerEffectView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

struct ShimmerEffectView: View {
    @State var MoveFrom = false
    var body: some View {
        ZStack {
            Text("Get Started")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.3))
            Text("Get Started")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .textRenderer(ShimmerEffect(animationProgress: MoveFrom ? 3 : -1))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        
        .background(LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.99, green: 0.45, blue: 0.17), location: 0.00),
                Gradient.Stop(color: Color(red: 0.99, green: 0.17, blue: 0.66), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.45, y: 1),
            endPoint: UnitPoint(x: 0.47, y: -0.90)
        ), in:Capsule())
        .padding()
        .onAppear() {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                MoveFrom.toggle()
            }
        }
    }
}


struct ShimmerEffect: TextRenderer {
    var animationProgress: CGFloat
    var animatableData: Double {
        get { animationProgress } set { animationProgress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        for line in layout {
            for runs in line {
                for (index, glyph) in runs.enumerated() {
                    let relativePosition = CGFloat(index) / CGFloat(runs.count)
                    let adjustedOpacity = max(0, 1 - abs(relativePosition - animationProgress))
                    ctx.opacity = Double(adjustedOpacity)
                    ctx.draw(glyph)
                }
            }
        }
    }
}

#Preview {
    ShimmerEffectView()
}
