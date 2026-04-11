# SwiftUI Prototype Workspace Guidelines

## Purpose
- This repository is for rapid prototyping animation, visual effects, and interaction ideas.
- Prototypes may use the latest Apple ecosystem technologies, including SwiftUI, UIKit, Metal, Core Animation, and related frameworks.
- This code is not intended for App Store release; prioritize learning speed and experimentation over production hardening.

## Core Principles
- Prefer latest APIs and platform capabilities available in current Xcode and Apple SDKs.
- Build small, isolated experiments with a clear visual or technical goal.
- Keep each prototype self-contained so it can be explored, modified, or removed independently.
- Favor readable and lightweight code with concise comments where helpful.

## Folder Structure
- Every prototype must live in its own folder.
- A prototype folder should contain all files needed to run and understand that prototype.
- Avoid sharing prototype-specific implementation files across multiple prototype folders unless they are clearly generic utilities.

### Suggested Layout
```text
<PrototypeName>/
  README.md
  <PrototypeName>View.swift
  <PrototypeName>Model.swift
  Resources/
  Shaders/          (if needed for Metal)
  Notes.md          (optional)
```

## Per-Prototype Requirements
- Include a short `README.md` inside each prototype folder describing:
  - What the prototype explores.
  - Which technologies/frameworks it uses.
  - How to run or preview it.
  - Known limitations or follow-up ideas.
- If a prototype has multiple tunable options, provide controls through a floating configuration entry point:
  - Use a floating button to open/close a prototyping controls panel.
  - Do not embed tuning controls directly in the main experience view by default.
  - Prefer modern Apple UI APIs and visual treatments (including Liquid Glass style where available) for sliders, toggles, pickers, and related controls.
  - The panel should support quick live tuning while running in Simulator.
- Keep comments lightweight and practical:
  - Explain intent for non-obvious animation/math/rendering logic.
  - Avoid noisy comments that repeat obvious code.
- Keep file names clear and local to the prototype context.

## Technology Guidance
- SwiftUI first when possible; bridge to UIKit/AppKit only when it materially improves the prototype.
- Use Metal, Core Image, Core Animation, or other graphics APIs when needed for effect quality or performance experiments.
- It is acceptable to use beta/new APIs when useful for exploration.

## Quality Bar for Prototypes
- Must build and run locally before considering a prototype complete.
- Keep scope tight: one core idea per prototype.
- Document assumptions quickly rather than over-engineering.
- Remove dead code and stale files when iterating.

## Lightweight Checklist for New Prototypes
- Create a dedicated folder.
- Add minimal runnable implementation files.
- Add a prototype-level `README.md`.
- Add a floating button + toggleable tuning panel when there are multiple candidate values.
- Add concise comments for complex sections.
- Verify the prototype runs in preview/simulator/device.
