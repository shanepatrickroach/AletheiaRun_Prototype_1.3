//
//  Color+Theme.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/3/25.
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let primaryOrange = Color(hex: "EDA145")
    static let primaryLight = Color(hex: "FF8C00")
    static let primaryDark = Color(hex: "CC8A39")
    
    // MARK: - Neutral Colors
    static let backgroundBlack = Color(hex: "000000")
    static let cardBackground = Color(hex: "0F0F0F")
    static let cardBorder = Color(hex: "1A1A1A")
    static let textPrimary = Color(hex: "FFFFFF")
    static let textSecondary = Color(hex: "B3B3B3")
    static let textTertiary = Color(hex: "808080")
    
    // MARK: - Semantic Colors
    static let successGreen = Color(hex: "4ADE80")
    static let warningYellow = Color(hex: "FCD34D")
    static let errorRed = Color(hex: "F87171")
    static let infoBlue = Color(hex: "60A5FA")
    
    //Metric Assosiated Colors
    static let efficiencyColor = Color(hex: "D53D36")
    static let brakingColor = Color(hex: "9BC355")
    static let impactColor = Color(hex: "FBDC4F")
    static let swayColor = Color(hex: "51A8DD")
    static let variationColor = Color(hex: "EA973F")
    static let warmupColor = Color(hex: "982688")
    static let enduranceColor = Color(hex: "794FAD")
    
    // MARK: - Helper to create Color from hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
