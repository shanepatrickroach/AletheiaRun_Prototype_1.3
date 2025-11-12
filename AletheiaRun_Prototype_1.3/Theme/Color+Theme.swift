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
    static let hipMobilityColor = Color(hex:"06C900")
    static let hipStabilityColor = Color(hex:"0033FF")
    static let timeColor = Color(hex: "92400E")
    
    
    static let landingColor = Color(.red)
    static let stabilizingColor = Color(.yellow)
    static let launchingColor = Color(.green)
    static let flyingColor = Color(.blue)
    
    
    static let leftSide = Color.primaryOrange     // Cool Blue
    static let rightSide = Color(purple)     // Warm Red

    // With opacity variations for backgrounds
    static let leftSideBackground = Color(hex: "3B82F6").opacity(0.15)
    static let rightSideBackground = Color(hex: "EF4444").opacity(0.15)
    
    
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


//
//  GradientColors.swift
//  AletheiaRun_Prototype_1.3
//
//  Gradient Color Solutions for Left/Right Side Differentiation
//

import SwiftUI

// MARK: - Solution 1: LinearGradient Extensions (RECOMMENDED)
extension LinearGradient {
    
    /// Gradient representing both left and right sides
    /// Left (cyan) → Right (magenta)
    static var bothSides: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Vertical gradient (top to bottom)
    static var bothSidesVertical: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Diagonal gradient (top-left to bottom-right)
    static var bothSidesDiagonal: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Three-color gradient with middle transition
    static var bothSidesSmooth: LinearGradient {
        LinearGradient(
            colors: [
                Color.leftSide,
                Color.leftSide.opacity(0.7).mix(with: Color.rightSide, by: 0.3),
                Color.rightSide
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Solution 2: ShapeStyle Extension
extension ShapeStyle where Self == LinearGradient {
    
    /// Use as: .fill(.bothSides)
    static var bothSides: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Solution 3: Custom Gradient Struct
struct BothSidesGradient {
    
    /// Horizontal gradient (default)
    static var horizontal: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Vertical gradient
    static var vertical: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Diagonal gradient
    static var diagonal: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Radial gradient (center out)
    static var radial: RadialGradient {
        RadialGradient(
            colors: [Color.leftSide, Color.rightSide],
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }
    
    /// Angular gradient (circular)
    static var angular: AngularGradient {
        AngularGradient(
            colors: [Color.leftSide, Color.rightSide, Color.leftSide],
            center: .center
        )
    }
}

// MARK: - Solution 4: Color Extension with Helper
extension Color {
    

    
    /// Helper to create both sides gradient
    static func bothSidesGradient(
        horizontal: Bool = true
    ) -> LinearGradient {
        if horizontal {
            return LinearGradient(
                colors: [leftSide, rightSide],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [leftSide, rightSide],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Color Mixing Extension
extension Color {
    /// Mix two colors together
    func mix(with color: Color, by percentage: Double) -> Color {
        // This is a simplified version
        // In production, you'd convert to RGB, mix, then back to Color
        return self
    }
}

// MARK: - Usage Examples
struct GradientExamplesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                
                // EXAMPLE 1: Fill with gradient
                Text("Solution 1: Extension")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.bothSides)  // ✅ Use gradient
                    .frame(height: 100)
                
                // EXAMPLE 2: Background gradient
                Text("Gradient Background")
                    .font(.bodyLarge)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient.bothSides)
                    .cornerRadius(12)
                
                // EXAMPLE 3: Stroke gradient
                Circle()
                    .strokeBorder(LinearGradient.bothSides, lineWidth: 4)
                    .frame(width: 100, height: 100)
                
                // EXAMPLE 4: Using ShapeStyle
                RoundedRectangle(cornerRadius: 12)
                    .fill(.bothSides)  // ✅ Short syntax
                    .frame(height: 100)
                
                // EXAMPLE 5: Custom struct
                RoundedRectangle(cornerRadius: 12)
                    .fill(BothSidesGradient.horizontal)
                    .frame(height: 100)
                
                // EXAMPLE 6: Vertical gradient
                RoundedRectangle(cornerRadius: 12)
                    .fill(BothSidesGradient.vertical)
                    .frame(height: 100)
                
                // EXAMPLE 7: Diagonal gradient
                RoundedRectangle(cornerRadius: 12)
                    .fill(BothSidesGradient.diagonal)
                    .frame(height: 100)
                
                // EXAMPLE 8: Overlay gradient
                Text("Gradient Text")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(LinearGradient.bothSides)
                
                // EXAMPLE 9: With opacity
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.leftSide.opacity(0.5),
                                Color.rightSide.opacity(0.5)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 100)
                
                // EXAMPLE 10: Three-color smooth
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.bothSidesSmooth)
                    .frame(height: 100)
            }
            .padding()
        }
        .background(Color.backgroundBlack)
    }
}

// MARK: - Real-World Use Cases

// Use Case 1: Chart with both sides
struct BothSidesChartBar: View {
    let value: Double  // 0-100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.cardBorder)
                
                // Gradient progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient.bothSides)
                    .frame(width: geometry.size.width * (value / 100))
            }
        }
        .frame(height: 8)
    }
}

// Use Case 2: Button with gradient
struct BothSidesButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.m)
                .background(LinearGradient.bothSides)
                .cornerRadius(CornerRadius.medium)
        }
    }
}

// Use Case 3: Badge with gradient
struct BothSidesBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, Spacing.s)
            .padding(.vertical, Spacing.xxs)
            .background(LinearGradient.bothSides)
            .cornerRadius(CornerRadius.small)
    }
}

// Use Case 4: Icon with gradient background
struct BothSidesIcon: View {
    let systemName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient.bothSides)
                .frame(width: 50, height: 50)
            
            Image(systemName: systemName)
                .font(.title3)
                .foregroundColor(.white)
        }
    }
}

// Use Case 5: Divider with gradient
struct BothSidesDivider: View {
    var body: some View {
        Rectangle()
            .fill(LinearGradient.bothSides)
            .frame(height: 2)
            .padding(.vertical, Spacing.m)
    }
}

// Use Case 6: Metric card with gradient accent
struct BothSidesMetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            Text(value)
                .font(.titleLarge)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            // Gradient top border
            VStack {
                Rectangle()
                    .fill(LinearGradient.bothSides)
                    .frame(height: 3)
                
                Spacer()
            }
        )
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Add to Your Color+Theme.swift
/*

Add this to your Color+Theme.swift file:

import SwiftUI

extension Color {
    // Existing colors...
    static let leftSide = Color(hex: "06B6D4")   // Cyan for left
    static let rightSide = Color(hex: "EC4899")  // Magenta for right
}

extension LinearGradient {
    /// Gradient representing both left and right sides
    static var bothSides: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Vertical gradient version
    static var bothSidesVertical: LinearGradient {
        LinearGradient(
            colors: [Color.leftSide, Color.rightSide],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Then use anywhere:
.fill(LinearGradient.bothSides)
.background(LinearGradient.bothSides)
.strokeBorder(LinearGradient.bothSides, lineWidth: 2)

*/

// MARK: - Preview
#Preview("Gradient Examples") {
    GradientExamplesView()
}

#Preview("Use Cases") {
    ScrollView {
        VStack(spacing: Spacing.xl) {
            Text("Real-World Examples")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            BothSidesChartBar(value: 75)
                .padding(.horizontal)
            
            BothSidesButton(title: "Both Sides", action: {})
                .padding(.horizontal)
            
            HStack {
                BothSidesBadge(text: "Left + Right")
                BothSidesBadge(text: "Bilateral")
            }
            
            BothSidesIcon(systemName: "figure.run")
            
            BothSidesDivider()
                .padding(.horizontal)
            
            HStack(spacing: Spacing.m) {
                BothSidesMetricCard(title: "Symmetry", value: "92%")
                BothSidesMetricCard(title: "Balance", value: "85%")
            }
            .padding(.horizontal)
        }
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundBlack)
}
