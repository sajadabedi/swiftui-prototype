// SpinnerShaders.metal
// GPU gradient-path spinner
// Requires iOS 17+ / Metal 3

#include <metal_stdlib>
using namespace metal;

constant float PI2 = 6.28318530717958647692;

// MARK: - Spirograph curve

float2 spirographPoint(float progress, float loops, float tinyLoopAmount) {
    float margin      = 0.2;
    float detailScale = 0.7;
    float loopRadius = (margin / tinyLoopAmount) * detailScale;

    float t = PI2 * progress;
    return float2(
        cos(t) * margin - loopRadius * cos(t * loops),
        sin(t) * margin - loopRadius * sin(t * loops)
    );
}

float spirographMaxRadius(float loops, float tinyLoopAmount, float strokeWidth) {
    float margin      = 0.2;
    float detailScale = 0.7;
    float loopRadius = (margin / tinyLoopAmount) * detailScale;
    float ribbonHalf = 0.006 * strokeWidth;
    return margin + loopRadius + ribbonHalf;
}

// MARK: - Color helpers

float3 hsv2rgb(float h, float s, float v) {
    float3 c = float3(h, s, v);
    float4 K = float4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Saffron gradient: orange → yellow → orange → red, cycling along the curve
float3 saffronColor(float progress, float time) {
    float3 orange     = float3(1.00, 0.50, 0.05);
    float3 yellow     = float3(1.00, 0.82, 0.12);
    float3 deepOrange = float3(0.95, 0.35, 0.04);
    float3 red        = float3(0.85, 0.12, 0.02);

    float t = fmod(progress - time * 0.08 + 100.0, 1.0);
    t *= 4.0; // 4 color stops

    if (t < 1.0) {
        return mix(orange, yellow, t);
    } else if (t < 2.0) {
        return mix(yellow, deepOrange, t - 1.0);
    } else if (t < 3.0) {
        return mix(deepOrange, red, t - 2.0);
    } else {
        return mix(red, orange, t - 3.0);
    }
}

// MARK: - GPU config (must match Swift-side GPUConfig layout)

struct Config {
    float  time;
    float  strokeWidth;
    uint   segmentCount;
    float  loops;
    float  tinyLoopAmount;
    float  trailLength;
    uint   colorMode;       // 0 = rainbow, 1 = white, 2 = custom, 3 = saffron
    float4 customColor;
    float  aspectRatio;
};

// MARK: - Vertex / Fragment

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float  edgeDist;
};

vertex VertexOut spinner_vertex(
    uint vid [[vertex_id]],
    constant Config& cfg [[buffer(0)]])
{
    VertexOut out;

    uint segIdx = vid / 2;
    uint side   = vid % 2;

    float progress = float(segIdx)     / float(cfg.segmentCount);
    float nextP    = float(segIdx + 1) / float(cfg.segmentCount);

    float2 p0 = spirographPoint(progress, cfg.loops, cfg.tinyLoopAmount);
    float2 p1 = spirographPoint(nextP,    cfg.loops, cfg.tinyLoopAmount);

    // Ribbon geometry
    float2 tangent = normalize(p1 - p0);
    float2 normal  = float2(-tangent.y, tangent.x);
    float  halfW   = 0.006 * cfg.strokeWidth;

    // Auto-fit curve within 90% of NDC bounds
    float maxR  = spirographMaxRadius(cfg.loops, cfg.tinyLoopAmount, cfg.strokeWidth);
    float scale = 0.9 / maxR;

    // Trail animation — reversed so trail "draws" the flower
    float trailHead = fmod(cfg.time / 4.0, 1.0);
    float dist      = fmod(trailHead - progress + 1.0, 1.0);
    bool  inTrail   = dist <= cfg.trailLength;
    float glow      = inTrail ? (1.0 - dist / cfg.trailLength) : 0.0;

    // Smooth caps: rounded head + soft tail fade
    float capLen   = 0.012;
    float tailLen  = 0.08;
    float capTaper = 1.0;
    if (inTrail) {
        float headTaper = smoothstep(0.0, capLen, dist);
        float tailTaper = smoothstep(cfg.trailLength, cfg.trailLength - tailLen, dist);
        capTaper = headTaper * tailTaper;
    }

    // Final position
    float sideSign = (side == 0) ? -1.0 : 1.0;
    float2 pos = p0 + normal * sideSign * halfW;
    pos *= scale;
    pos.x /= cfg.aspectRatio;

    // Depth: trail head nearest (z≈0), tail farthest; background at z=1
    float depth = inTrail ? (dist / cfg.trailLength) : 1.0;

    out.position = float4(pos, depth, 1.0);
    out.edgeDist = sideSign;

    // Color
    if (inTrail) {
        float3 rgb;
        if (cfg.colorMode == 0) {
            float hue = fmod(progress + cfg.time * 0.08, 1.0);
            rgb = hsv2rgb(hue, 0.9, 1.0);
        } else if (cfg.colorMode == 1) {
            rgb = float3(1.0);
        } else if (cfg.colorMode == 3) {
            rgb = saffronColor(progress, cfg.time);
        } else {
            rgb = cfg.customColor.rgb;
        }
        out.color = float4(rgb, glow * capTaper);
    } else {
        // Static gray background curve (full shape always visible)
        out.color = float4(float3(0.78), 1.0);
    }

    return out;
}

fragment float4 spinner_fragment(VertexOut in [[stage_in]])
{
    // Anti-alias ribbon edges
    float edge = abs(in.edgeDist);
    float aa   = 1.0 - smoothstep(0.7, 1.0, edge);

    return float4(in.color.rgb, in.color.a * aa);
}
