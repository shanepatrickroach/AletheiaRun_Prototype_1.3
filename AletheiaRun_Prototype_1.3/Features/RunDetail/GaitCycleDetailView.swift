// Features/RunDetail/GaitCycleDetailView.swift

import SwiftUI

/// Detailed view showing gait cycle analysis for a run
struct GaitCycleDetailView: View {
    let gaitMetrics: GaitCycleMetrics
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Dual Gait Cycle Dials
            gaitCycleDialSection
            
            // Phase Comparison Legend
            phaseBreakdownSection
            
            // Timing Metrics
            GaitCycleTimingCard(metrics: gaitMetrics)
            
            // Symmetry Insights
            SymmetryInsightCard(metrics: gaitMetrics)
            
            // Phase Details (expandable)
            phaseDetailsSection
            
            // Gait Cycle Over Time (if multiple snapshots)
            if snapshots.count > 1 {
                gaitProgressionSection
            }
        }
    }
    
    // MARK: - Gait Cycle Dial Section
    private var gaitCycleDialSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Gait Cycle Analysis")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            DualGaitCycleDial(metrics: gaitMetrics)
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.primaryOrange.opacity(0.3),
                                    Color.primaryOrange.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        }
    }
    
    // MARK: - Phase Breakdown Section
    private var phaseBreakdownSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Phase Breakdown")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            GaitCycleLegend(metrics: gaitMetrics)
        }
    }
    
    // MARK: - Phase Details Section
    private var phaseDetailsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Phase Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ForEach(GaitCyclePhase.allCases) { phase in
                GaitCyclePhaseCard(
                    phase: phase,
                    leftPercentage: percentageForPhase(phase, leg: .left),
                    rightPercentage: percentageForPhase(phase, leg: .right)
                )
            }
        }
    }
    
    // MARK: - Gait Progression Section
    private var gaitProgressionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Gait Cycle Progression")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text("See how your gait cycle changed throughout the run")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            // Placeholder for chart
            gaitProgressionPlaceholder
        }
    }
    
    private var gaitProgressionPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.cardBackground)
                .frame(height: 200)
            
            VStack(spacing: Spacing.s) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 40))
                    .foregroundColor(.textTertiary)
                
                Text("Chart Coming Soon")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                Text("Track gait cycle changes over time")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Helper Methods
    private enum Leg {
        case left, right
    }
    
    private func percentageForPhase(_ phase: GaitCyclePhase, leg: Leg) -> Double {
        let cycle = leg == .left ? gaitMetrics.leftLeg : gaitMetrics.rightLeg
        switch phase {
        case .landing: return cycle.landing
        case .stabilizing: return cycle.stabilizing
        case .launching: return cycle.launching
        case .flying: return cycle.flying
        }
    }
}

// MARK: - Symmetry Insight Card
struct SymmetryInsightCard: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "arrow.left.and.right.circle.fill")
                        .foregroundColor(.primaryOrange)
                    
                    Text("Symmetry Analysis")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                // Symmetry score badge
                HStack(spacing: 4) {
                    Text("\(metrics.symmetryScore)")
                        .font(.titleSmall)
                        .fontWeight(.bold)
                    
                    Text("/100")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                .foregroundColor(symmetryColor)
            }
            
            // Insight message
            HStack(spacing: Spacing.s) {
                Image(systemName: symmetryIcon)
                    .foregroundColor(symmetryColor)
                
                Text(symmetryMessage)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.s)
            .background(symmetryColor.opacity(0.1))
            .cornerRadius(CornerRadius.small)
            
            // Recommendations based on symmetry
            if metrics.symmetryScore < 85 {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Recommendations:")
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    ForEach(symmetryRecommendations, id: \.self) { recommendation in
                        HStack(alignment: .top, spacing: Spacing.xs) {
                            Text("•")
                                .foregroundColor(.primaryOrange)
                            
                            Text(recommendation)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.top, Spacing.xs)
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
    
    private var symmetryMessage: String {
        let score = metrics.symmetryScore
        if score >= 85 {
            return "Excellent symmetry between legs. Your gait is well-balanced."
        } else if score >= 70 {
            return "Moderate asymmetry detected. Consider reviewing your form."
        } else {
            return "Significant asymmetry between legs. This may increase injury risk."
        }
    }
    
    private var symmetryRecommendations: [String] {
        let score = metrics.symmetryScore
        if score >= 70 {
            return [
                "Focus on single-leg stability exercises",
                "Check for muscle imbalances",
                "Monitor progress over the next few runs"
            ]
        } else {
            return [
                "Consider a gait analysis with a specialist",
                "Work on single-leg strength and stability",
                "Check your running shoes for uneven wear",
                "Review your running surface and terrain"
            ]
        }
    }
}

// MARK: - Gait Cycle Phase Card
struct GaitCyclePhaseCard: View {
    let phase: GaitCyclePhase
    let leftPercentage: Double
    let rightPercentage: Double
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: { withAnimation { showDetails.toggle() } }) {
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
                        .frame(width: 6, height: 40)
                        .shadow(color: phase.color.opacity(0.5), radius: 3, x: 0, y: 0)
                    
                    // Phase info
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(phase.rawValue)
                            .font(.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: Spacing.s) {
                            Text("L: \(String(format: "%.1f%%", leftPercentage))")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text("R: \(String(format: "%.1f%%", rightPercentage))")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Icon and chevron
                    HStack(spacing: Spacing.s) {
                        Image(systemName: phase.icon)
                            .font(.system(size: 20))
                            .foregroundColor(phase.color)
                        
                        Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.m)
            }
            
            // Expanded Details
            if showDetails {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)
                    
                    // Phase description
                    Text(phase.description)
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Left vs Right comparison
                    HStack(spacing: Spacing.m) {
                        // Left leg
                        LegPhaseDetail(
                            label: "Left Leg",
                            percentage: leftPercentage,
                            optimalRange: optimalRangeForPhase(phase),
                            color: phase.color
                        )
                        
                        Divider()
                            .frame(height: 60)
                        
                        // Right leg
                        LegPhaseDetail(
                            label: "Right Leg",
                            percentage: rightPercentage,
                            optimalRange: optimalRangeForPhase(phase),
                            color: phase.color
                        )
                    }
                    
                    // Asymmetry warning if needed
                    asymmetryBanner
                }
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, Spacing.m)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Asymmetry Banner
    private var asymmetryBanner: some View {
        let difference = abs(leftPercentage - rightPercentage)
        
        if difference > 3.0 {
            return AnyView(
                InsightBanner(
                    icon: "exclamationmark.triangle.fill",
                    text: String(format: "%.1f%% difference between legs - consider form review", difference),
                    color: .warningYellow
                )
            )
        } else if difference > 1.5 {
            return AnyView(
                InsightBanner(
                    icon: "info.circle.fill",
                    text: String(format: "Slight %.1f%% asymmetry - monitor over time", difference),
                    color: .infoBlue
                )
            )
        } else {
            return AnyView(
                InsightBanner(
                    icon: "checkmark.circle.fill",
                    text: "Well-balanced between legs",
                    color: .successGreen
                )
            )
        }
    }
    
    private func optimalRangeForPhase(_ phase: GaitCyclePhase) -> ClosedRange<Double> {
        switch phase {
        case .landing: return 12.0...18.0
        case .stabilizing: return 18.0...25.0
        case .launching: return 12.0...18.0
        case .flying: return 40.0...55.0
        }
    }
}

// MARK: - Leg Phase Detail Component
struct LegPhaseDetail: View {
    let label: String
    let percentage: Double
    let optimalRange: ClosedRange<Double>
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text(String(format: "%.1f%%", percentage))
                .font(.titleSmall)
                .fontWeight(.bold)
                .foregroundColor(statusColor)
            
            // Status indicator
            HStack(spacing: 4) {
                Image(systemName: statusIcon)
                    .font(.system(size: 10))
                    .foregroundColor(statusColor)
                
                Text(statusText)
                    .font(.system(size: 10))
                    .foregroundColor(statusColor)
            }
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, 2)
            .background(statusColor.opacity(0.15))
            .cornerRadius(4)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var statusColor: Color {
        if percentage < optimalRange.lowerBound {
            return .warningYellow
        } else if percentage > optimalRange.upperBound {
            return .errorRed
        } else {
            return .successGreen
        }
    }
    
    private var statusIcon: String {
        if percentage < optimalRange.lowerBound {
            return "arrow.down.circle.fill"
        } else if percentage > optimalRange.upperBound {
            return "arrow.up.circle.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    private var statusText: String {
        if percentage < optimalRange.lowerBound {
            return "Below"
        } else if percentage > optimalRange.upperBound {
            return "Above"
        } else {
            return "Optimal"
        }
    }
}

// MARK: - Insight Banner
struct InsightBanner: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(Spacing.s)
        .background(color.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Gait Cycle Snapshot Section
/// Compact gait cycle view for snapshot cards
struct GaitCycleSnapshotSection: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Text("Gait Cycle")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Symmetry indicator
                HStack(spacing: 4) {
                    Image(systemName: "arrow.left.and.right")
                        .font(.system(size: 10))
                    Text("\(metrics.symmetryScore)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(symmetryColor)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, 2)
                .background(symmetryColor.opacity(0.15))
                .cornerRadius(4)
            }
            
            HStack(spacing: Spacing.m) {
                // Mini dual dials
                HStack(spacing: Spacing.s) {
                    // Left leg mini
                    MiniGaitCycleDial(legCycle: metrics.leftLeg, size: 50, label: "L")
                    
                    // Right leg mini
                    MiniGaitCycleDial(legCycle: metrics.rightLeg, size: 50, label: "R")
                }
                
                // Compact stats
                VStack(spacing: Spacing.xs) {
                    HStack {
                        Text("Contact:")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(String(format: "%.0f ms", metrics.contactTime))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                    }
                    
                    HStack {
                        Text("Flight:")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(String(format: "%.0f ms", metrics.flightTime))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                    }
                    
                    HStack {
                        Text("Cadence:")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text("\(metrics.cadence) SPM")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
    
    private var symmetryColor: Color {
        let score = metrics.symmetryScore
        if score >= 85 { return .successGreen }
        if score >= 70 { return .warningYellow }
        return .errorRed
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        GaitCycleDetailView(
            gaitMetrics: GaitCycleMetrics(),
            snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
        )
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundBlack)
}