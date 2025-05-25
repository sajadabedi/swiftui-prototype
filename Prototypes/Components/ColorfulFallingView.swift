//
//  ColorfulFallingView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 01.01.2025.
//

import SwiftUI

struct ColorfulFallingView: View {
    @State private var showDebugControls = false
    @State private var debugSettings = DebugSettings()

    var body: some View {
        ZStack {
            VStack {
                Text("Subscribe to Pro account")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                ColorfulBallsView(settings: debugSettings)
            )
            .cornerRadius(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1, green: 0.6, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.2, green: 0.7, blue: 1, alpha: 1))]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )

            VStack {
                Spacer()

                Button(action: {
                    withAnimation {
                        showDebugControls.toggle()
                    }
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding()

                if showDebugControls {
                    DebugControlsView(settings: $debugSettings)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

struct DebugSettings {
    var birthRate: Float = 2
    var lifetime: Float = 2
    var velocity: Float = 20
    var velocityRange: Float = 10
    var yAcceleration: Float = 30
    var scale: Float = 0.1
    var scaleRange: Float = 0.02
    var scaleSpeed: Float = -0.05
    var alphaRange: Float = 0.5
}

struct DebugControlsView: View {
    @Binding var settings: DebugSettings

    var body: some View {
        VStack(spacing: 10) {
            Text("Debug Controls")
                .font(.headline)
                .foregroundColor(.white)

            Group {
                SliderRow(value: $settings.birthRate, range: 1...20,
                         title: "Birth Rate: \(String(format: "%.1f", settings.birthRate))")
                SliderRow(value: $settings.lifetime, range: 5...30,
                         title: "Lifetime: \(String(format: "%.1f", settings.lifetime))")
                SliderRow(value: $settings.velocity, range: 10...100,
                         title: "Velocity: \(String(format: "%.1f", settings.velocity))")
                SliderRow(value: $settings.velocityRange, range: 0...50,
                         title: "Velocity Range: \(String(format: "%.1f", settings.velocityRange))")
                SliderRow(value: $settings.yAcceleration, range: 0...100,
                         title: "Y Acceleration: \(String(format: "%.1f", settings.yAcceleration))")
                SliderRow(value: $settings.scale, range: 0.01...0.2,
                         title: "Scale: \(String(format: "%.3f", settings.scale))")
                SliderRow(value: $settings.scaleRange, range: 0...0.5,
                         title: "Scale Range: \(String(format: "%.3f", settings.scaleRange))")
                SliderRow(value: $settings.scaleSpeed, range: -0.2...0,
                         title: "Scale Speed: \(String(format: "%.3f", settings.scaleSpeed))")
                SliderRow(value: $settings.alphaRange, range: 0...1,
                         title: "Alpha Range: \(String(format: "%.2f", settings.alphaRange))")

            }

            .padding(.horizontal, 24.0)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .padding()
    }
}

struct SliderRow: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            Slider(value: $value, in: range)
        }
    }
}

// MARK: Colorfulfalling View
struct ColorfulBallsView: UIViewRepresentable {
    var settings: DebugSettings

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let emmiterLayer = CAEmitterLayer()

        context.coordinator.emitterLayer = emmiterLayer

        emmiterLayer.emitterPosition = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: -10
        )
        emmiterLayer.emitterShape = .line
        emmiterLayer.emitterSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 1)

        emmiterLayer.emitterCells = createColorFulEmitterCells()

        view.layer.addSublayer(emmiterLayer)
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // Update the emitter when settings change
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.emitterLayer?.emitterCells = createColorFulEmitterCells()
    }

    class Coordinator {
        weak var emitterLayer: CAEmitterLayer?
    }

    private func createColorFulEmitterCells() -> [CAEmitterCell] {
        let colors: [UIColor] = Array(repeating: .white, count: 7)

        return colors.map { color -> CAEmitterCell in
            let cell = CAEmitterCell()

            cell.birthRate = settings.birthRate
            cell.lifetime = Float(settings.lifetime)
            cell.velocity = CGFloat(settings.velocity)
            cell.velocityRange = CGFloat(settings.velocityRange)
            cell.yAcceleration = CGFloat(settings.yAcceleration)
            cell.emissionRange = .pi
            cell.spinRange = 0.5
            cell.scale = CGFloat(settings.scale)
            cell.scaleRange = CGFloat(settings.scaleRange)
            cell.scaleSpeed = CGFloat(settings.scaleSpeed)
            cell.alphaRange = settings.alphaRange
            cell.alphaSpeed = -0.1

            cell.contents = createColoredCircle(color: color.withAlphaComponent(0.8), size: CGSize(width: 40, height: 40))?.cgImage

            return cell
        }
    }

    private func createColoredCircle(color: UIColor, size: CGSize) -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

struct ColorfulBallsBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ColorfulBallsView(settings: DebugSettings())
            )
    }
}

extension View {
    func colorfulBallsBackground() -> some View {
        modifier(ColorfulBallsBackground())
    }
}

#Preview {
    ColorfulFallingView()
}
