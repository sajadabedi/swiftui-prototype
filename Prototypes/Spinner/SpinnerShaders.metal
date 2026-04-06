// SpinnerShaders.metal
// GPU gradient-path spinner
// Requires iOS 17+ / Metal 3

#include <metal_stdlib>
using namespace metal;

constant float PI  = 3.14159265358979323846;
constant float PI2 = 6.28318530717958647692;

// MARK: - Spirograph curve

// Compute a point on the spirograph at a given progress [0..1]
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

// Max possible radius of the spirograph (for auto-fitting inside NDC)
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

// MARK: - GPU config (must match Swift-side GPUConfig layout)

struct Config {
    float  time;
    float  strokeWidth;
    uint   segmentCount;
    float  loops;
    float  tinyLoopAmount;
    float  trailLength;
    uint   colorMode;       // 0 = rainbow, 1 = white, 2 = custom
    float4 customColor;
    float  aspectRatio;
};

// MARK: - Vertex / Fragment

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float  edgeDist; // -1..1 across ribbon width (for anti-aliasing)
};

vertex VertexOut spinner_vertex(
    uint vid [[vertex_id]],
    constant Config& cfg [[buffer(0)]])
{
    VertexOut out;

    // Two vertices per segment (left & right edge of the ribbon)
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

    // Trail animation
    float trailHead = fmod(cfg.time / 4.0, 1.0);
    float dist      = fmod(progress - trailHead + 1.0, 1.0);
    bool  inTrail   = dist <= cfg.trailLength;
    float glow      = inTrail ? (1.0 - dist / cfg.trailLength) : 0.0;

    // Rounded caps — taper ribbon width to zero at head & tail
    float capLen   = 0.012;
    float capTaper = 1.0;
    if (inTrail) {
        capTaper  = smoothstep(0.0, capLen, dist);
        capTaper  = min(capTaper, smoothstep(cfg.trailLength, cfg.trailLength - capLen, dist));
    }

    // Final position
    float sideSign = (side == 0) ? -1.0 : 1.0;
    float2 pos = p0 + normal * sideSign * halfW * capTaper;
    pos *= scale;
    pos.x /= cfg.aspectRatio;

    // Depth: trail head is nearest (z=0), tail is farthest (z→1)
    // Segments outside the trail are pushed to the back
    float depth = inTrail ? (dist / cfg.trailLength) : 1.0;

    out.position = float4(pos, depth, 1.0);
    out.edgeDist = sideSign * capTaper;

    // Color
    float3 rgb;
    if (cfg.colorMode == 0) {
        float hue = fmod(progress + cfg.time * 0.08, 1.0);
        rgb = hsv2rgb(hue, 0.9, 1.0);
    } else if (cfg.colorMode == 1) {
        rgb = float3(1.0);
    } else {
        rgb = cfg.customColor.rgb;
    }

    // Only trail segments are visible; smooth gradient from head (bright) to tail (fades out)
    float alpha = inTrail ? glow : 0.0;
    out.color = float4(rgb, alpha);

    return out;
}

fragment float4 spinner_fragment(VertexOut in [[stage_in]])
{
    // Anti-alias ribbon edges
    float edge = abs(in.edgeDist);
    float aa   = 1.0 - smoothstep(0.7, 1.0, edge);

    return float4(in.color.rgb, in.color.a * aa);
}
