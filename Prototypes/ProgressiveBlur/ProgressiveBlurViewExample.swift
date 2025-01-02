//
//  ProgressiveBlurView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 02.01.2025.
//

import SwiftUI

struct ProgressiveBlurViewExample: View {
    var body: some View {
//        ZStack(alignment: .top) {
//            Color.white
//            Color.blue.opacity(0.3)
//            Image("macy")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(.horizontal, 50)
//            Text("VariableBlur")
//                .font(.largeTitle.monospaced().weight(.bold))
//                .padding(.top, 230)
//                .foregroundStyle(.white.opacity(0.9))
//        }
//        .overlay(alignment: .top) {
//            VariableBlurView(
//                maxBlurRadius: 20,
//                direction: .blurredBottomClearTop
//            )
//                .frame(height: 200)
//        }
//        .ignoresSafeArea()
        Image("macy")
            .resizable()
            .scaledToFit()
            .frame(width: 350, height: .infinity)
           
            .overlay(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    VariableBlurView(maxBlurRadius: 15, direction: .blurredBottomClearTop)
                        .frame(height: 70)
                    Text("Progressive Blursdfsdfsdf")
                        .foregroundStyle(.white)
                        .font(.body.bold())
                        .padding()
                }
            }
            .cornerRadius(20)

    }
}

#Preview {
    ProgressiveBlurViewExample()
}
