import SwiftUI

struct ChromaticDistortionParameters {
    var origin: CGPoint
    var intensity: Float
}

struct ChromaticDistortionEffect: ViewModifier {
    var parameters: ChromaticDistortionParameters
    
    func body(content: Content) -> some View {
        content.visualEffect { content, geometryProxy in
            content.layerEffect(
                ShaderLibrary.chromaticDistortion(
                    .float2(parameters.origin),
                    .float(parameters.intensity)
                ), maxSampleOffset: .zero
            )
        }
    }
}

struct ChromaticDistortionView: View {
    @State private var parameters = ChromaticDistortionParameters(origin: .zero, intensity: 2.0)

    var body: some View {
        Image("macy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .modifier(ChromaticDistortionEffect(parameters: parameters))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        parameters.origin = value.location
                    }
            )
    }
}

#Preview {
    ChromaticDistortionView()
}
