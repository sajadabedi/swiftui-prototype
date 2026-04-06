// SpinnerView.swift
// GPU-accelerated gradient path spinner
// Requires iOS 17+, Metal

import SwiftUI
import MetalKit
import simd

// MARK: - Configuration

public struct SpinnerConfig {
    public var strokeWidth:    Float  = 5.0
    public var segmentCount:   UInt32 = 80_000
    public var loops:          Float  = 6.0
    public var tinyLoopAmount: Float  = 1.5
    public var trailLength:    Float  = 0.7

    public var colorMode: ColorMode = .rainbow
    public var customColor: SIMD4<Float> = SIMD4(1, 0.6, 0.2, 1)

    public enum ColorMode: UInt32 {
        case rainbow = 0
        case white   = 1
        case custom  = 2
        case saffron = 3
    }

    public init() {}
}

// MARK: - SwiftUI View

public struct SpinnerView: UIViewRepresentable {
    public var config: SpinnerConfig

    public init(config: SpinnerConfig = SpinnerConfig()) {
        self.config = config
    }

    public func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        view.backgroundColor = .clear
        view.isOpaque = false
        view.colorPixelFormat = .rgba16Float
        view.depthStencilPixelFormat = .depth32Float
        view.framebufferOnly = true
        view.preferredFramesPerSecond = 120
        view.enableSetNeedsDisplay = false
        view.isPaused = false
        view.clipsToBounds = false

        let renderer = SpinnerRenderer(view: view, config: config)
        context.coordinator.renderer = renderer
        view.delegate = renderer
        return view
    }

    public func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.renderer?.config = config
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public class Coordinator: NSObject {
        var renderer: SpinnerRenderer?
    }
}

// MARK: - Metal Renderer

final class SpinnerRenderer: NSObject, MTKViewDelegate {

    var config: SpinnerConfig

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let depthState: MTLDepthStencilState
    private let startTime: CFTimeInterval = CACurrentMediaTime()

    // Must match Config in the .metal file
    private struct GPUConfig {
        var time:           Float
        var strokeWidth:    Float
        var segmentCount:   UInt32
        var loops:          Float
        var tinyLoopAmount: Float
        var trailLength:    Float
        var colorMode:      UInt32
        var _pad:           UInt32 = 0
        var customColor:    SIMD4<Float>
        var aspectRatio:    Float
        var _pad2:          SIMD3<Float> = .zero
    }

    init(view: MTKView, config: SpinnerConfig) {
        self.config = config
        self.device = view.device!
        self.commandQueue = device.makeCommandQueue()!

        guard let library = device.makeDefaultLibrary() else {
            fatalError("SpinnerView: Metal library not found. Add SpinnerShaders.metal to the target.")
        }

        // Render pipeline
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction   = library.makeFunction(name: "spinner_vertex")
        desc.fragmentFunction = library.makeFunction(name: "spinner_fragment")
        desc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        desc.depthAttachmentPixelFormat = view.depthStencilPixelFormat

        // Standard alpha blending (source-over) — no additive accumulation
        let blend = desc.colorAttachments[0]!
        blend.isBlendingEnabled             = true
        blend.rgbBlendOperation             = .add
        blend.alphaBlendOperation           = .add
        blend.sourceRGBBlendFactor          = .sourceAlpha
        blend.sourceAlphaBlendFactor        = .one
        blend.destinationRGBBlendFactor     = .oneMinusSourceAlpha
        blend.destinationAlphaBlendFactor   = .oneMinusSourceAlpha

        self.pipelineState = try! device.makeRenderPipelineState(descriptor: desc)

        // Depth stencil — trail head (z≈0) draws on top of tail (z≈1)
        let depthDesc = MTLDepthStencilDescriptor()
        depthDesc.depthCompareFunction = .less
        depthDesc.isDepthWriteEnabled = true
        self.depthState = device.makeDepthStencilState(descriptor: depthDesc)!

        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard
            let drawable   = view.currentDrawable,
            let renderPass = view.currentRenderPassDescriptor,
            let cmdBuffer  = commandQueue.makeCommandBuffer(),
            let encoder    = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPass)
        else { return }

        let size   = view.drawableSize
        let aspect = size.width > 0 ? Float(size.width / size.height) : 1.0

        var gpu = GPUConfig(
            time:           Float(CACurrentMediaTime() - startTime),
            strokeWidth:    config.strokeWidth,
            segmentCount:   config.segmentCount,
            loops:          config.loops,
            tinyLoopAmount: config.tinyLoopAmount,
            trailLength:    config.trailLength,
            colorMode:      config.colorMode.rawValue,
            customColor:    config.customColor,
            aspectRatio:    aspect
        )

        let vertexCount = Int(config.segmentCount) * 2
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthState)
        encoder.setVertexBytes(&gpu, length: MemoryLayout<GPUConfig>.stride, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCount)

        encoder.endEncoding()
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
    }
}

// MARK: - Previews

#Preview("Gradient Path") {
    ZStack {
        SpinnerView(config: {
            var c = SpinnerConfig()
            c.colorMode  = .rainbow
            c.strokeWidth = 6
            return c
        }())
        .frame(width: 100, height: 100)
    }
}

#Preview("Saffron") {
    ZStack {
        SpinnerView(config: {
            var c = SpinnerConfig()
            c.colorMode = .saffron
            c.strokeWidth = 7
            return c
        }())
        .frame(width: 100, height: 100)
    }
}
