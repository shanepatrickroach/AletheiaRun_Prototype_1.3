//
//  MetricsVisualization.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/16/25.
//

import SwiftUI

// MARK: - Visualization Concepts Container
/// Shows 5 different ways to visualize interval metrics
struct MetricsVisualizationShowcase: View {
    let interval: RunSnapshot
    @State private var selectedConcept = 0
    
    let concepts = [
        "Radar Chart",
        "Progress Bars",
        "Gauge Cluster",
        "Score Cards",
        "Heat Map"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Concept Selector
                    Picker("Visualization", selection: $selectedConcept) {
                        ForEach(0..<concepts.count, id: \.self) { index in
                            Text(concepts[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(Spacing.m)
                    
                    // Show selected concept
                    TabView(selection: $selectedConcept) {
                        Concept1_RadarChart(interval: interval).tag(0)
                        Concept2_ProgressBars(interval: interval).tag(1)
                        Concept3_GaugeCluster(interval: interval).tag(2)
                        Concept4_ScoreCards(interval: interval).tag(3)
                        Concept5_HeatMap(interval: interval).tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationTitle("Metrics Visualization")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Concept 1: Radar Chart
/// Spider/radar chart showing all metrics in a circular layout
struct Concept1_RadarChart: View {
    let interval: RunSnapshot
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Title
                VStack(spacing: Spacing.xs) {
                    Text("Concept 1: Radar Chart")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("Spider chart shows balance across all metrics")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Performance Metrics Radar
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Performance Metrics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
//                    RadarChartView(
//                        metrics: [
//                            ("Efficiency", interval.performanceMetrics.efficiency),
//                            ("Sway", interval.performanceMetrics.sway),
//                            ("Braking", interval.performanceMetrics.braking),
//                            ("Endurance", interval.performanceMetrics.endurance),
//                            ("Warmup", interval.performanceMetrics.warmup),
//                            ("Impact", interval.performanceMetrics.impact),
//                            ("Variation", interval.performanceMetrics.variation)
//                        ],
//                        color: .primaryOrange
//                    )
                    .frame(height: 300)
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Injury Diagnostics Radar
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Injury Diagnostics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
//                    RadarChartView(
//                        metrics: [
//                            ("Hip Mobility", interval.injuryMetrics.hipMobility),
//                            ("Hip Stability", interval.injuryMetrics.hipStability),
//                            ("Symmetry", interval.injuryMetrics.portraitSymmetry)
//                        ],
//                        color: .infoBlue
//                    )
                    .frame(height: 250)
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                prosConsView(
                    pros: ["Quick visual comparison", "Easy to spot imbalances", "Compact display"],
                    cons: ["Hard to read exact values", "Can be cluttered with many metrics"]
                )
            }
            .padding(Spacing.m)
        }
    }
}

// MARK: - Concept 2: Horizontal Progress Bars
/// Clean, scannable list with color-coded bars
struct Concept2_ProgressBars: View {
    let interval: RunSnapshot
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Title
                VStack(spacing: Spacing.xs) {
                    Text("Concept 2: Progress Bars")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("Classic, easy-to-scan horizontal bars")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Performance Metrics
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Performance Metrics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: Spacing.s) {
                        ProgressMetricRow(name: "Efficiency", value: interval.performanceMetrics.efficiency, icon: "bolt.fill")
                        ProgressMetricRow(name: "Sway", value: interval.performanceMetrics.sway, icon: "arrow.left.and.right")
                        ProgressMetricRow(name: "Braking", value: interval.performanceMetrics.braking, icon: "hand.raised.fill")
                        ProgressMetricRow(name: "Endurance", value: interval.performanceMetrics.endurance, icon: "heart.fill")
                        ProgressMetricRow(name: "Warmup", value: interval.performanceMetrics.warmup, icon: "flame.fill")
                        ProgressMetricRow(name: "Impact", value: interval.performanceMetrics.impact, icon: "arrow.down.circle.fill")
                        ProgressMetricRow(name: "Variation", value: interval.performanceMetrics.variation, icon: "waveform")
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Injury Diagnostics
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Injury Diagnostics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: Spacing.s) {
                        ProgressMetricRow(name: "Hip Mobility", value: interval.injuryMetrics.hipMobility, icon: "figure.walk", color: .infoBlue)
                        ProgressMetricRow(name: "Hip Stability", value: interval.injuryMetrics.hipStability, icon: "figure.strengthtraining.traditional", color: .infoBlue)
                        ProgressMetricRow(name: "Symmetry", value: interval.injuryMetrics.portraitSymmetry, icon: "arrow.left.and.right.circle", color: .infoBlue)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                prosConsView(
                    pros: ["Very clear and intuitive", "Easy to compare values", "Works well on mobile"],
                    cons: ["Takes more vertical space", "Less visually interesting"]
                )
            }
            .padding(Spacing.m)
        }
    }
}

// MARK: - Concept 3: Gauge Cluster
/// Dashboard-style circular gauges
struct Concept3_GaugeCluster: View {
    let interval: RunSnapshot
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Title
                VStack(spacing: Spacing.xs) {
                    Text("Concept 3: Gauge Cluster")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("Car dashboard-inspired circular gauges")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Overall Score (Large)
                CircularGauge(
                    value: interval.performanceMetrics.overallScore,
                    title: "Overall",
                    size: 180,
                    color: .primaryOrange
                )
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Performance Metrics Grid
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Performance Metrics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.m) {
                        CircularGauge(value: interval.performanceMetrics.efficiency, title: "Efficiency", size: 120)
                        CircularGauge(value: interval.performanceMetrics.sway, title: "Sway", size: 120)
                        CircularGauge(value: interval.performanceMetrics.impact, title: "Impact", size: 120)
                        CircularGauge(value: interval.performanceMetrics.braking, title: "Braking", size: 120)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Injury Diagnostics Grid
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Injury Diagnostics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: Spacing.m) {
                        CircularGauge(value: interval.injuryMetrics.hipMobility, title: "Hip Mobility", size: 100, color: .infoBlue)
                        CircularGauge(value: interval.injuryMetrics.hipStability, title: "Hip Stability", size: 100, color: .infoBlue)
                        CircularGauge(value: interval.injuryMetrics.portraitSymmetry, title: "Symmetry", size: 100, color: .infoBlue)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                prosConsView(
                    pros: ["Visually appealing", "Familiar metaphor", "Good for at-a-glance"],
                    cons: ["Takes more space", "Harder to compare exact values"]
                )
            }
            .padding(Spacing.m)
        }
    }
}

// MARK: - Concept 4: Score Cards
/// Card-based layout with grades/scores
struct Concept4_ScoreCards: View {
    let interval: RunSnapshot
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Title
                VStack(spacing: Spacing.xs) {
                    Text("Concept 4: Score Cards")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("Grade-based cards with letter scores")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Overall Grade
                VStack(spacing: Spacing.m) {
                    Text("Overall Performance")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    
                    Text(getGrade(interval.performanceMetrics.overallScore))
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(getGradeColor(interval.performanceMetrics.overallScore))
                    
                    Text("\(interval.performanceMetrics.overallScore)/100")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.xl)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Performance Metrics
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Performance Metrics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.m) {
                        ScoreCard(name: "Efficiency", value: interval.performanceMetrics.efficiency)
                        ScoreCard(name: "Sway", value: interval.performanceMetrics.sway)
                        ScoreCard(name: "Impact", value: interval.performanceMetrics.impact)
                        ScoreCard(name: "Braking", value: interval.performanceMetrics.braking)
                        ScoreCard(name: "Endurance", value: interval.performanceMetrics.endurance)
                        ScoreCard(name: "Warmup", value: interval.performanceMetrics.warmup)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Injury Diagnostics
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Injury Risk Assessment")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: Spacing.m) {
                        RiskCard(name: "Hip Mobility", value: interval.injuryMetrics.hipMobility)
                        RiskCard(name: "Hip Stability", value: interval.injuryMetrics.hipStability)
                        RiskCard(name: "Portrait Symmetry", value: interval.injuryMetrics.portraitSymmetry)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                prosConsView(
                    pros: ["Intuitive grading system", "Clear good/bad indication", "Gamification potential"],
                    cons: ["Loses precision", "May feel like judgment"]
                )
            }
            .padding(Spacing.m)
        }
    }
}

// MARK: - Concept 5: Heat Map
/// Color-coded grid/matrix view
struct Concept5_HeatMap: View {
    let interval: RunSnapshot
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Title
                VStack(spacing: Spacing.xs) {
                    Text("Concept 5: Heat Map")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("Color intensity shows metric values")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Performance Heat Map
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Performance Metrics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: Spacing.xs) {
                        HeatMapRow(name: "Efficiency", value: interval.performanceMetrics.efficiency)
                        HeatMapRow(name: "Sway", value: interval.performanceMetrics.sway)
                        HeatMapRow(name: "Braking", value: interval.performanceMetrics.braking)
                        HeatMapRow(name: "Endurance", value: interval.performanceMetrics.endurance)
                        HeatMapRow(name: "Warmup", value: interval.performanceMetrics.warmup)
                        HeatMapRow(name: "Impact", value: interval.performanceMetrics.impact)
                        HeatMapRow(name: "Variation", value: interval.performanceMetrics.variation)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Injury Heat Map
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Injury Diagnostics")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: Spacing.xs) {
                        HeatMapRow(name: "Hip Mobility", value: interval.injuryMetrics.hipMobility, baseColor: .infoBlue)
                        HeatMapRow(name: "Hip Stability", value: interval.injuryMetrics.hipStability, baseColor: .infoBlue)
                        HeatMapRow(name: "Portrait Symmetry", value: interval.injuryMetrics.portraitSymmetry, baseColor: .infoBlue)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                // Legend
                HStack(spacing: Spacing.m) {
                    HStack(spacing: Spacing.xs) {
                        Circle().fill(Color.errorRed).frame(width: 12, height: 12)
                        Text("Poor (<60)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: Spacing.xs) {
                        Circle().fill(Color.warningYellow).frame(width: 12, height: 12)
                        Text("Fair (60-79)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: Spacing.xs) {
                        Circle().fill(Color.successGreen).frame(width: 12, height: 12)
                        Text("Good (80+)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                
                prosConsView(
                    pros: ["Very compact", "Instant color recognition", "Easy patterns"],
                    cons: ["Requires legend", "Color-blind concerns"]
                )
            }
            .padding(Spacing.m)
        }
    }
}

// MARK: - Supporting Components

// Radar Chart View
//struct RadarChartView: View {
//    let metrics: [(String, Int)]
//    var color: Color = .primaryOrange
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
//            let radius = min(geometry.size.width, geometry.size.height) / 2 - 40
//            
//            ZStack {
//                // Background circles
//                ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { scale in
//                    RadarPolygon(points: metrics.count, scale: scale)
//                        .stroke(Color.cardBorder, lineWidth: 1)
//                        .frame(width: radius * 2, height: radius * 2)
//                }
//                
//                // Data polygon
//                RadarDataShape(values: metrics.map { Double($0.1) / 100.0 }, points: metrics.count)
//                    .fill(color.opacity(0.3))
//                    .frame(width: radius * 2, height: radius * 2)
//                
//                RadarDataShape(values: metrics.map { Double($0.1) / 100.0 }, points: metrics.count)
//                    .stroke(color, lineWidth: 2)
//                    .frame(width: radius * 2, height: radius * 2)
//                
//                // Labels
//                ForEach(0..<metrics.count, id: \.self) { index in
//                    let angle = (2 * .pi / Double(metrics.count)) * Double(index) - .pi / 2
//                    let labelRadius = radius + 25
//                    let x = center.x + labelRadius * CGFloat(cos(angle))
//                    let y = center.y + labelRadius * CGFloat(sin(angle))
//                    
//                    Text(metrics[index].0)
//                        .font(.caption)
//                        .foregroundColor(.textSecondary)
//                        .position(x: x, y: y)
//                }
//            }
//        }
//    }
//}

struct RadarPolygon: Shape {
    let points: Int
    let scale: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * scale
        
        for i in 0..<points {
            let angle = (2 * .pi / Double(points)) * Double(i) - .pi / 2
            let point = CGPoint(
                x: center.x + radius * CGFloat(cos(angle)),
                y: center.y + radius * CGFloat(sin(angle))
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct RadarDataShape: Shape {
    let values: [Double]
    let points: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<points {
            let angle = (2 * .pi / Double(points)) * Double(i) - .pi / 2
            let value = i < values.count ? values[i] : 0
            let point = CGPoint(
                x: center.x + radius * value * CGFloat(cos(angle)),
                y: center.y + radius * value * CGFloat(sin(angle))
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// Progress Metric Row
struct ProgressMetricRow: View {
    let name: String
    let value: Int
    let icon: String
    var color: Color = .primaryOrange
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)
                
                Text(name)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(value)")
                    .font(.bodySmall)
                    .foregroundColor(scoreColor(value))
                    .fontWeight(.semibold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(scoreColor(value))
                        .frame(width: geometry.size.width * CGFloat(value) / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// Circular Gauge
struct CircularGauge: View {
    let value: Int
    let title: String
    var size: CGFloat = 120
    var color: Color = .primaryOrange
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.cardBorder, lineWidth: 8)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: CGFloat(value) / 100)
                .stroke(scoreColor(value), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Value text
            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.system(size: size * 0.3, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// Score Card
struct ScoreCard: View {
    let name: String
    let value: Int
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            Text(getGrade(value))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(getGradeColor(value))
            
            Text(name)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text("\(value)")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.m)
        .background(getGradeColor(value).opacity(0.1))
        .cornerRadius(CornerRadius.medium)
    }
}

// Risk Card
struct RiskCard: View {
    let name: String
    let value: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(getRiskLevel(value))
                    .font(.caption)
                    .foregroundColor(getRiskColor(value))
            }
            
            Spacer()
            
            VStack(spacing: Spacing.xxs) {
                Text("\(value)")
                    .font(.titleLarge)
                    .foregroundColor(getRiskColor(value))
                    .fontWeight(.bold)
                
                Text(getGrade(value))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.m)
        .background(getRiskColor(value).opacity(0.1))
        .cornerRadius(CornerRadius.medium)
    }
    
    private func getRiskLevel(_ value: Int) -> String {
        if value >= 80 { return "Low Risk" }
        else if value >= 60 { return "Moderate Risk" }
        else { return "High Risk" }
    }
    
    private func getRiskColor(_ value: Int) -> Color {
        if value >= 80 { return .successGreen }
        else if value >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// Heat Map Row
struct HeatMapRow: View {
    let name: String
    let value: Int
    var baseColor: Color = .primaryOrange
    
    var body: some View {
        HStack(spacing: Spacing.s) {
            Text(name)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .frame(width: 120, alignment: .leading)
            
            // Heat cells
            HStack(spacing: 2) {
                ForEach(0..<10) { index in
                    Rectangle()
                        .fill(getCellColor(index: index))
                        .frame(height: 24)
                }
            }
            
            Text("\(value)")
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)
        }
    }
    
    private func getCellColor(index: Int) -> Color {
        let threshold = value / 10
        if index < threshold {
            return scoreColor(value)
        }
        return Color.cardBorder
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// Pros/Cons View
func prosConsView(pros: [String], cons: [String]) -> some View {
    HStack(alignment: .top, spacing: Spacing.m) {
        // Pros
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.successGreen)
                Text("Pros")
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
            }
            
            ForEach(pros, id: \.self) { pro in
                Text("• \(pro)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.s)
        .background(Color.successGreen.opacity(0.1))
        .cornerRadius(CornerRadius.small)
        
        // Cons
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.errorRed)
                Text("Cons")
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
            }
            
            ForEach(cons, id: \.self) { con in
                Text("• \(con)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.s)
        .background(Color.errorRed.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Helper Functions

/// Converts numeric score (0-100) to letter grade
func getGrade(_ score: Int) -> String {
    switch score {
    case 97...100: return "A+"
    case 93..<97: return "A"
    case 90..<93: return "A-"
    case 87..<90: return "B+"
    case 83..<87: return "B"
    case 80..<83: return "B-"
    case 77..<80: return "C+"
    case 73..<77: return "C"
    case 70..<73: return "C-"
    case 67..<70: return "D+"
    case 63..<67: return "D"
    case 60..<63: return "D-"
    default: return "F"
    }
}

/// Returns color based on grade/score
func getGradeColor(_ score: Int) -> Color {
    switch score {
    case 90...100: return .successGreen
    case 80..<90: return Color(hex: "#8FD14F") // Light green
    case 70..<80: return .warningYellow
    case 60..<70: return Color(hex: "#FFA500") // Orange
    default: return .errorRed
    }
}

// MARK: - Preview

#Preview {
    MetricsVisualizationShowcase(interval: RunSnapshot.sample)
}
