    //
    //  AnimatedGradientTextView.swift
    //  Prototypes
    //
    //  Created by Sajjad Abedi on 22.06.2025.
    //

import SwiftUI

struct AnimatedGradientTextView: View {
    @State var animate: Bool = false
    let gradientColors: [Color] = [
        .yellow.opacity(0.6),
        .mint.opacity(0.6),
        .yellow.opacity(0.6),
        .purple,.orange,.pink,.purple,.cyan,.purple,.pink,.orange,.yellow
            .opacity(0.6),.mint.opacity(0.9),.yellow.opacity(0.7)
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: UIScreen.main.bounds.width * 8.9, height: 400)
            .offset(
                x: animate ? UIScreen.main.bounds.width * -3.4 : UIScreen.main.bounds.width * 4
            )
            .animation(
                .linear(duration: 5).repeatForever(autoreverses: false),
                value: animate
            )
            .rotationEffect(.degrees(20)).rotationEffect(.degrees(180))
            .blur(radius: 50)
            .onAppear{
                self.animate = true
            }
            .mask {
                Text("Hello World").font(.largeTitle).bold()
            }
        }
    }
}

#Preview {
    AnimatedGradientTextView()
}
