//
//  PlaceHolderViews.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


import SwiftUI




// MARK: - Route Map View (Placeholder)
/// Shows the GPS route of the run on a map
struct RouteMapView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            
            
            // Mock map preview
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Map Preview")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                // Simple map placeholder
                ZStack {
                    // Background gradient to simulate map
                    LinearGradient(
                        colors: [
                            Color(hex: "1A1A1A"),
                            Color(hex: "2A2A2A")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Simulated route line
                    Path { path in
                        path.move(to: CGPoint(x: 40, y: 100))
                        path.addCurve(
                            to: CGPoint(x: 160, y: 80),
                            control1: CGPoint(x: 70, y: 60),
                            control2: CGPoint(x: 130, y: 120)
                        )
                        path.addCurve(
                            to: CGPoint(x: 280, y: 120),
                            control1: CGPoint(x: 200, y: 40),
                            control2: CGPoint(x: 240, y: 100)
                        )
                    }
                    .stroke(Color.primaryOrange, lineWidth: 3)
                    
                    // Start marker
                    Circle()
                        .fill(Color.successGreen)
                        .frame(width: 12, height: 12)
                        .position(x: 40, y: 100)
                    
                    // End marker
                    Circle()
                        .fill(Color.errorRed)
                        .frame(width: 12, height: 12)
                        .position(x: 280, y: 120)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(CornerRadius.small)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
}

// MARK: - Placeholder Card Component
/// Reusable card for showing placeholder content with features list
struct PlaceholderCard: View {
    let icon: String
    let title: String
    let description: String
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header with icon
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.titleMedium)
                    .foregroundColor(.primaryOrange)
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    
                }
                
                Spacer()
            }
            
            // Description
            Text(description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            
            
//            // Features list
//            VStack(alignment: .leading, spacing: Spacing.s) {
//                Text("Planned Features:")
//                    .font(.bodySmall)
//                    .foregroundColor(.textTertiary)
//                    .fontWeight(.semibold)
//                
//                ForEach(features, id: \.self) { feature in
//                    HStack(spacing: Spacing.xs) {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.caption)
//                            .foregroundColor(.primaryOrange.opacity(0.6))
//                        
//                        Text(feature)
//                            .font(.bodySmall)
//                            .foregroundColor(.textSecondary)
//                    }
//                }
//            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Detail Item Component
struct DetailItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.primaryOrange)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}




#Preview("Route Map") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            RouteMapView()
                .padding(Spacing.m)
        }
    }
}
