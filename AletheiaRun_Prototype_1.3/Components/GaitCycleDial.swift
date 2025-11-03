// Core/Components/GaitCycleDial.swift

import SwiftUI

/// Enhanced dual-dial view showing left and right leg gait cycles
struct DualGaitCycleDial: View {
    let metrics: GaitCycleMetrics
    let size: CGFloat
    
    init(metrics: GaitCycleMetrics, size: CGFloat = 300) {
        self.metrics = metrics
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Symmetry Score Header
            HStack {
                Spacer()
                
                VStack(spacing: Spacing.xxs) {
                    Text("Symmetry")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Text("\(metrics.symmetryScore)")
                            .font(.titleMedium)
                            .foregroundColor(symmetryColor)
                        
                        Image(systemName: symmetryIcon)
                            .font(.bodyMedium)
                            .foregroundColor(symmetryColor)
                    }
                }
                
                Spacer()
            }
            
            // Dual Dials
            HStack(spacing: Spacing.xxl) {
                // Left Leg
                VStack(spacing: Spacing.m) {
                    EnhancedGaitCycleDial(
                        legCycle: metrics.leftLeg,
                        size: size / 2.2,
                        isLeftLeg: true
                    )
                    
                    Text("Left Leg")
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                // Right Leg
                VStack(spacing: Spacing.m) {
                    EnhancedGaitCycleDial(
                        legCycle: metrics.rightLeg,
                        size: size / 2.2,
                        isLeftLeg: false
                    )
                    
                    Text("Right Leg")
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
            }
            
            // Cadence Display
            HStack(spacing: Spacing.xl) {
                Spacer()
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "metronome.fill")
                        .foregroundColor(.primaryOrange)
                    
                    Text("\(metrics.cadence)")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text("SPM")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
        }
    }
    
    private var symmetryColor: Color {
        let score = metrics.symmetryScore
        if score >= 85 { return .successGreen }
        if score >= 70 { return .warningYellow }
        return .errorRed
    }
    
    private var symmetryIcon: String {
        let score = metrics.symmetryScore
        if score >= 85 { return "checkmark.circle.fill" }
        if score >= 70 { return "exclamationmark.circle.fill" }
        return "xmark.circle.fill"
    }
}

// MARK: - Enhanced Gait Cycle Dial (Single Leg)
struct EnhancedGaitCycleDial: View {
    let legCycle: LegGaitCycle
    let size: CGFloat
    let isLeftLeg: Bool
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.primaryOrange.opacity(0.3),
                            Color.primaryOrange.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: size + 10, height: size + 10)
                .blur(radius: 3)
            
            // Background circle with gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.cardBackground.opacity(0.8),
                            Color.backgroundBlack
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
            
            // Inner shadow circle
            Circle()
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
                .frame(width: size - 40, height: size - 40)
            
            // Gait cycle segments with enhanced styling
            EnhancedGaitCycleSegments(legCycle: legCycle, size: size)
            
            // Center content
            VStack(spacing: 2) {
                // Leg indicator icon
                Image(systemName: isLeftLeg ? "l.circle.fill" : "r.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primaryOrange.opacity(0.7))
                
                // Contact percentage
                Text(String(format: "%.0f%%", legCycle.contactPercentage))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Contact")
                    .font(.system(size: 10))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Enhanced Gait Cycle Segments
struct EnhancedGaitCycleSegments: View {
    let legCycle: LegGaitCycle
    let size: CGFloat
    
    private let lineWidth: CGFloat = 14
    private let spacing: CGFloat = 2  // Gap between segments
    
    var body: some View {
        ZStack {
            // Landing segment
            EnhancedSegmentShape(
                startAngle: .degrees(-180),
                endAngle: .degrees(-180 + (legCycle.landing / 100 * 360) - spacing),
                phase: .landing
            )
            .stroke(
                AngularGradient(
                    colors: [
                        GaitCyclePhase.landing.color.opacity(0.7),
                        GaitCyclePhase.landing.color,
                        GaitCyclePhase.landing.color.opacity(0.7)
                    ],
                    center: .center,
                    startAngle: .degrees(-180),
                    endAngle: .degrees(-180 + (legCycle.landing / 100 * 360))
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            
            // Stabilizing segment
            EnhancedSegmentShape(
                startAngle: .degrees(-180 + (legCycle.landing / 100 * 360)),
                endAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360) - spacing),
                phase: .stabilizing
            )
            .stroke(
                AngularGradient(
                    colors: [
                        GaitCyclePhase.stabilizing.color.opacity(0.7),
                        GaitCyclePhase.stabilizing.color,
                        GaitCyclePhase.stabilizing.color.opacity(0.7)
                    ],
                    center: .center,
                    startAngle: .degrees(-180 + (legCycle.landing / 100 * 360)),
                    endAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360))
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            
            // Launching segment
            EnhancedSegmentShape(
                startAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360)),
                endAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360) - spacing),
                phase: .launching
            )
            .stroke(
                AngularGradient(
                    colors: [
                        GaitCyclePhase.launching.color.opacity(0.7),
                        GaitCyclePhase.launching.color,
                        GaitCyclePhase.launching.color.opacity(0.7)
                    ],
                    center: .center,
                    startAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360)),
                    endAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360))
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            
            // Flying segment
            EnhancedSegmentShape(
                startAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360)),
                endAngle: .degrees(-180 + 360 - spacing),
                phase: .flying
            )
            .stroke(
                AngularGradient(
                    colors: [
                        GaitCyclePhase.flying.color.opacity(0.7),
                        GaitCyclePhase.flying.color,
                        GaitCyclePhase.flying.color.opacity(0.7)
                    ],
                    center: .center,
                    startAngle: .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360)),
                    endAngle: .degrees(-180 + 360)
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            
            // Add subtle inner glow for each phase
            ForEach(GaitCyclePhase.allCases) { phase in
                let (start, end) = angleRangeForPhase(phase)
                EnhancedSegmentShape(
                    startAngle: start,
                    endAngle: end,
                    phase: phase
                )
                .stroke(
                    phase.color.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth - 4, lineCap: .round)
                )
            }
        }
        .frame(width: size, height: size)
    }
    
    private func angleRangeForPhase(_ phase: GaitCyclePhase) -> (Angle, Angle) {
        let spacing = 2.0
        switch phase {
        case .landing:
            return (
                .degrees(-180),
                .degrees(-180 + (legCycle.landing / 100 * 360) - spacing)
            )
        case .stabilizing:
            return (
                .degrees(-180 + (legCycle.landing / 100 * 360)),
                .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360) - spacing)
            )
        case .launching:
            return (
                .degrees(-180 + ((legCycle.landing + legCycle.stabilizing) / 100 * 360)),
                .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360) - spacing)
            )
        case .flying:
            return (
                .degrees(-180 + ((legCycle.landing + legCycle.stabilizing + legCycle.launching) / 100 * 360)),
                .degrees(-180 + 360 - spacing)
            )
        }
    }
}

// MARK: - Enhanced Segment Shape
struct EnhancedSegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let phase: GaitCyclePhase
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(
            center: center,
            radius: radius - 12,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path
    }
}

// MARK: - Compact Gait Cycle Legend
/// Updated legend showing left vs right comparison
struct GaitCycleLegend: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            ForEach(GaitCyclePhase.allCases) { phase in
                GaitCycleLegendRow(
                    phase: phase,
                    leftPercentage: percentageForPhase(phase, leg: .left),
                    rightPercentage: percentageForPhase(phase, leg: .right)
                )
            }
        }
    }
    
    private enum Leg {
        case left, right
    }
    
    private func percentageForPhase(_ phase: GaitCyclePhase, leg: Leg) -> Double {
        let cycle = leg == .left ? metrics.leftLeg : metrics.rightLeg
        switch phase {
        case .landing: return cycle.landing
        case .stabilizing: return cycle.stabilizing
        case .launching: return cycle.launching
        case .flying: return cycle.flying
        }
    }
}

// MARK: - Updated Legend Row with Left/Right Comparison
struct GaitCycleLegendRow: View {
    let phase: GaitCyclePhase
    let leftPercentage: Double
    let rightPercentage: Double
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Color indicator with gradient
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [phase.color, phase.color.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 6, height: 28)
                .shadow(color: phase.color.opacity(0.5), radius: 3, x: 0, y: 0)
            
            // Phase name and icon
            HStack(spacing: Spacing.xs) {
                Image(phase.icon)
                    .resizable()
                    .frame(width: 34, height: 34)
                    .font(.system(size: 12))
                    .foregroundColor(phase.color)
                
                Text(phase.rawValue)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
            }
            .frame(width: 150, alignment: .leading)
            
            Spacer()
            
            // Left leg percentage
            VStack(spacing: 2) {
                Text("L")
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
                
                Text(String(format: "%.1f%%", leftPercentage))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(phase.color)
            }
            .frame(width: 45)
            
            // Right leg percentage
            VStack(spacing: 2) {
                Text("R")
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
                
                Text(String(format: "%.1f%%", rightPercentage))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(phase.color)
            }
            .frame(width: 45)
            
            // Difference indicator
            if abs(leftPercentage - rightPercentage) > 1.0 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.warningYellow)
            }
        }
        .padding(.vertical, Spacing.xs)
        .padding(.horizontal, Spacing.s)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Gait Cycle Timing Card (Updated)
struct GaitCycleTimingCard: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            Text("Timing Metrics")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.m) {
                // Contact Time
                TimingMetricItem(
                    icon: "arrow.down.circle.fill",
                    label: "Contact",
                    value: String(format: "%.0f", metrics.contactTime),
                    unit: "ms",
                    color: .errorRed
                )
                
                // Flight Time
                TimingMetricItem(
                    icon: "airplane.circle.fill",
                    label: "Flight",
                    value: String(format: "%.0f", metrics.flightTime),
                    unit: "ms",
                    color: .infoBlue
                )
                
                // Cadence
                TimingMetricItem(
                    icon: "metronome.fill",
                    label: "Cadence",
                    value: "\(metrics.cadence)",
                    unit: "SPM",
                    color: .primaryOrange
                )
                
                // Unit
                TimingMetricItem(
                    icon: "figure.run",
                    label: "Duty Factor",
                    value: "\(metrics.cadence/2)",
                    unit: "%",
                    color: .warningYellow
                )
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Timing Metric Item
struct TimingMetricItem: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: Spacing.xl) {
        DualGaitCycleDial(metrics: GaitCycleMetrics())
        
        GaitCycleLegend(metrics: GaitCycleMetrics())
            .padding(.horizontal)
        
        GaitCycleTimingCard(metrics: GaitCycleMetrics())
            .padding(.horizontal)
    }
    .padding()
    .background(Color.backgroundBlack)
}
