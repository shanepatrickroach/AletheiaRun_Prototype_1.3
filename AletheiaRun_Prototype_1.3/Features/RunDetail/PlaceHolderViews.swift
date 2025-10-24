//
//  PlaceHolderViews.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


import SwiftUI



// MARK: - Metrics Over Time View (Placeholder)
/// Shows trend analysis of metrics across multiple runs
struct MetricsOverTimeView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            PlaceholderCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "Metrics Over Time",
                description: "Track your progress and see how your metrics improve over weeks and months",
                features: [
                    "Line charts for each metric",
                    "Compare current vs previous week",
                    "Identify improvement trends",
                    "Set metric goals",
                    "Weekly/monthly/yearly views",
                    "Export data to CSV"
                ]
            )
            
            // Mock chart preview
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Sample Chart Preview")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                // Simple mock line chart
                GeometryReader { geometry in
                    Path { path in
                        let points: [(x: CGFloat, y: CGFloat)] = [
                            (0, 0.8), (0.2, 0.6), (0.4, 0.7),
                            (0.6, 0.5), (0.8, 0.65), (1.0, 0.45)
                        ]
                        
                        path.move(to: CGPoint(
                            x: points[0].x * geometry.size.width,
                            y: points[0].y * geometry.size.height
                        ))
                        
                        for point in points.dropFirst() {
                            path.addLine(to: CGPoint(
                                x: point.x * geometry.size.width,
                                y: point.y * geometry.size.height
                            ))
                        }
                    }
                    .stroke(Color.primaryOrange, lineWidth: 2)
                }
                .frame(height: 120)
                .background(Color.backgroundBlack)
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


// MARK: - Pocket Coach View (Placeholder)
/// Personalized exercise recommendations based on Force Portrait analysis
struct PocketCoachView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            PlaceholderCard(
                icon: "person.fill.checkmark",
                title: "Pocket Coach",
                description: "Get personalized exercise recommendations based on your Force Portrait analysis",
                features: [
                    "AI-generated exercise plans",
                    "Target specific weaknesses",
                    "Video demonstrations",
                    "Progress tracking",
                    "Difficulty levels",
                    "Integration with calendar"
                ]
            )
            
            // Sample exercise card
            ExerciseSampleCard()
        }
    }
}

// MARK: - Route Map View (Placeholder)
/// Shows the GPS route of the run on a map
struct RouteMapView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            PlaceholderCard(
                icon: "map.fill",
                title: "Route Map",
                description: "View your running route with elevation profile and split times",
                features: [
                    "Interactive map with route overlay",
                    "Interval markers",
                    "Share route with others"
                ]
            )
            
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
                            Text("Map view coming soon")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                                .padding(Spacing.xs)
                                .background(Color.backgroundBlack.opacity(0.8))
                                .cornerRadius(CornerRadius.small)
                                .padding(Spacing.s)
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
                    
                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundColor(.primaryOrange)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(Color.primaryOrange.opacity(0.15))
                        .cornerRadius(CornerRadius.small)
                }
                
                Spacer()
            }
            
            // Description
            Text(description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .background(Color.cardBorder)
            
            // Features list
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Planned Features:")
                    .font(.bodySmall)
                    .foregroundColor(.textTertiary)
                    .fontWeight(.semibold)
                
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.primaryOrange.opacity(0.6))
                        
                        Text(feature)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
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

// MARK: - Exercise Sample Card
/// Shows what a Pocket Coach exercise recommendation would look like
struct ExerciseSampleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Exercise title
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Hip Mobility Drill")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text("Based on your hip mobility score")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Difficulty badge
                Text("Beginner")
                    .font(.caption)
                    .foregroundColor(.infoBlue)
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, 4)
                    .background(Color.infoBlue.opacity(0.15))
                    .cornerRadius(CornerRadius.small)
            }
            
            // Exercise details
            HStack(spacing: Spacing.xl) {
                DetailItem(icon: "timer", text: "10 min")
                DetailItem(icon: "repeat", text: "3 sets")
                DetailItem(icon: "flame.fill", text: "Low intensity")
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Description
            Text("This exercise targets hip flexor mobility and helps reduce the braking forces detected in your recent runs.")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            // Action button
            Button(action: {}) {
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("View Exercise Demo")
                }
                .font(.bodyMedium)
                .foregroundColor(.backgroundBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.s)
                .background(Color.primaryOrange)
                .cornerRadius(CornerRadius.small)
            }
            .opacity(0.5) // Dimmed since it's a placeholder
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

// MARK: - Preview
#Preview("Tech Mode") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            TechModeView()
                .padding(Spacing.m)
        }
    }
}

#Preview("Metrics Over Time") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            MetricsOverTimeView()
                .padding(Spacing.m)
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
