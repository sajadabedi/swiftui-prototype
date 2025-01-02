import SwiftUI

struct RippleShaderEffectView: View {
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Image("macy")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .modifier(RippleEffect(at: origin, trigger: counter))
                .onTapGesture { location in
                    origin = location
                    counter += 1
                }
        }
    }
}

// MARK: View Modifier
struct RippleModifier: ViewModifier {
    var origin: CGPoint
    var elapsedTime: TimeInterval
    var duration: TimeInterval
    var amplitude: Double
    var frequency: Double
    var decay: Double
    var speed: Double
    
    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Ripple(
            .float2(origin),
            .float(elapsedTime),
            // Parameters
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )
        let maxSampleOffset = maxSampleOffset
        let elapsedTime = elapsedTime
        let duration = duration
        content.visualEffect { view, _ in
            view.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: 0 < elapsedTime && elapsedTime < duration)
        }
    }
    var maxSampleOffset: CGSize {
        CGSize(width: amplitude, height: amplitude)
    }
}

struct RippleEffect<T: Equatable>: ViewModifier {
    var origin: CGPoint
    var trigger: T
    var amplitude: Double
    var frequency: Double
    var decay: Double
    var speed: Double
    init(at origin: CGPoint, trigger: T, amplitude: Double = 10, frequency: Double = 15, decay: Double = 8, speed: Double = 1500) {
        self.origin = origin
        self.trigger = trigger
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
    }
    
    func body(content: Content) -> some View {
        let origin = origin
        let duration = duration
        let amplitude = amplitude
        let frequency = frequency
        let decay = decay
        let speed = speed
        
        content
            .keyframeAnimator(
                initialValue: 0,
                trigger: trigger) {
                    view,
                    elapsedTime in
                    view
                        .modifier(
                            RippleModifier(
                                origin: origin,
                                elapsedTime: elapsedTime,
                                duration: duration,
                                amplitude: amplitude,
                                frequency: frequency,
                                decay: decay,
                                speed: speed
                            )
                        )
                } keyframes: { _ in
                    MoveKeyframe(0)
                    LinearKeyframe(duration, duration: duration)
                }
        
    }
    var duration: TimeInterval { 3 }
}

#Preview {
    RippleShaderEffectView()
}
