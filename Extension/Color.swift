//
//  Color.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 25.06.2025.
//

import SwiftUI

/// Extension to initialize a SwiftUI `Color` from a hex string (e.g., "F54900").
/// Supports 6-digit RGB hex codes. Non-hex characters are ignored.
/// Defaults to yellow if the input is invalid.
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
