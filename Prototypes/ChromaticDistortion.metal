#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[stitchable]]
half4 chromaticDistortion(float2 position,
                          SwiftUI::Layer layer,
                          float2 origin,
                          float intensity) {
    float2 uv = position;
    float2 direction = normalize(uv - origin);
    float distance = length(uv - origin);
    float strength = intensity * exp(-distance * 0.005);
    
        // Apply chromatic aberration
    half4 color;
    color.r = layer.sample(uv + direction * strength * 10.0).r;
    color.g = layer.sample(uv + direction * strength * 5.0).g;
    color.b = layer.sample(uv + direction * strength * 2.0).b;
    color.a = 1.0;
    
    return color;
}
