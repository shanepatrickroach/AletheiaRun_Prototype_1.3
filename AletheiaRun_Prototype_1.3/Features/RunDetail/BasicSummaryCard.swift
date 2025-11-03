//
//  BasicSummaryCard.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/29/25.
//

// Features/RunDetail/RunDetailSummaryCards.swift

import SwiftUI

// MARK: - Basic Summary Card
/// Simple, non-collapsible summary for tabs that don't need detail
struct BasicSummaryCard: View {
    let run: Run

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header with date and mode
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(run.date.formatted(date: .long, time: .shortened))
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    HStack(spacing: Spacing.m) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: run.mode.icon)
                            Text(run.mode.rawValue)
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                        HStack(spacing: Spacing.xs) {
                            Image(systemName: run.terrain.icon)
                            Text(run.terrain.rawValue)
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                // Overall score badge
                VStack(spacing: Spacing.xxs) {
                    Text("\(run.metrics.overallScore)")
                        .font(.titleLarge)
                        .foregroundColor(scoreColor(run.metrics.overallScore))

                    Text("Overall")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            // Progress Bar
            RunSummaryProgressBar(value: run.metrics.overallScore)

            Divider()
                .background(Color.cardBorder)

            // Key Stats
            HStack(spacing: Spacing.xl) {
                RunSummaryStatItem(
                    icon: "figure.run",
                    value: String(format: "%.2f", run.distance),
                    label: "Distance",
                    unit: "mi"
                )

                RunSummaryStatItem(
                    icon: "timer",
                    value: formatDuration(run.duration),
                    label: "Duration",
                    unit: ""
                )

                RunSummaryStatItem(
                    icon: "speedometer",
                    value: formatPace(run.distance, run.duration),
                    label: "Pace",
                    unit: "/mi"
                )
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

    // Helper functions
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formatPace(_ distance: Double, _ duration: TimeInterval)
        -> String
    {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Overview Summary Card
/// Collapsible summary showing average performance metrics
struct OverviewSummaryCard: View {
    let run: Run
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header - Always visible, tappable to expand/collapse
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Session Overview")
                            .font(.headline)
                            .foregroundColor(.textPrimary)

                        Text(run.date.formatted(date: .long, time: .shortened))
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    // Overall Score
                    HStack(spacing: Spacing.s) {
                        VStack(spacing: 2) {
                            Text("\(run.metrics.overallScore)")
                                .font(.titleLarge)
                                .foregroundColor(
                                    scoreColor(run.metrics.overallScore))

                            Text("Overall")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }

                        Image(
                            systemName: isExpanded
                                ? "chevron.up" : "chevron.down"
                        )
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.m)
            }

            // Expanded Content
            if isExpanded {
                VStack(spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)

                    // Run Stats
                    HStack(spacing: Spacing.xl) {
                        RunSummaryStatItem(
                            icon: "figure.run",
                            value: String(format: "%.2f", run.distance),
                            label: "Distance",
                            unit: "mi"
                        )

                        RunSummaryStatItem(
                            icon: "timer",
                            value: formatDuration(run.duration),
                            label: "Duration",
                            unit: ""
                        )

                        RunSummaryStatItem(
                            icon: "speedometer",
                            value: formatPace(run.distance, run.duration),
                            label: "Pace",
                            unit: "/mi"
                        )
                    }
                    .padding(.horizontal, Spacing.m)

                    Divider()
                        .background(Color.cardBorder)

                    // Performance Metrics Section
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.primaryOrange)

                            Text("Average Performance Metrics")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, Spacing.m)

                        // All metrics with progress bars
                        VStack(spacing: Spacing.s) {
                            MetricProgressRow(
                                name: "Efficiency",
                                value: run.metrics.efficiency,
                                color: .efficiencyColor)
                            MetricProgressRow(
                                name: "Braking", value: run.metrics.braking,
                                color: .brakingColor)
                            MetricProgressRow(
                                name: "Impact", value: run.metrics.impact,
                                color: .impactColor)
                            MetricProgressRow(
                                name: "Sway", value: run.metrics.sway,
                                color: .swayColor)
                            MetricProgressRow(
                                name: "Variation", value: run.metrics.variation,
                                color: .variationColor)
                            MetricProgressRow(
                                name: "Warmup", value: run.metrics.warmup,
                                color: .warmupColor)
                            MetricProgressRow(
                                name: "Endurance", value: run.metrics.endurance,
                                color: .enduranceColor)
                        }
                        .padding(.horizontal, Spacing.m)
                    }

                    Divider()
                        .background(Color.cardBorder)

                    // NEW: Injury Diagnostics Section
                    injuryMetricsSection
                }
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

    // Helper functions (same as BasicSummaryCard)
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formatPace(_ distance: Double, _ duration: TimeInterval)
        -> String
    {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - NEW: Injury Metrics Section
private var injuryMetricsSection: some View {
    VStack(alignment: .leading, spacing: Spacing.m) {
        // Section header
        HStack {
            Image(systemName: "cross.case.fill")
                .foregroundColor(.primaryOrange)

            Text("Injury Diagnostics")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)

            Spacer()

            // Risk level badge (computed from average injury metrics)
            RiskLevelBadge(riskLevel: computedRiskLevel)
        }
        .padding(.horizontal, Spacing.m)

        // Hip Mobility - Left vs Right
        LateralMetricComparison(
            metricName: "Hip Mobility",
            leftValue: averageLeftHipMobility,
            rightValue: averageRightHipMobility,
            color: .hipMobilityColor
        )
        .padding(.horizontal, Spacing.m)

        // Hip Stability - Left vs Right
        LateralMetricComparison(
            metricName: "Hip Stability",
            leftValue: averageLeftHipStability,
            rightValue: averageRightHipStability,
            color: .hipStabilityColor
        )
        .padding(.horizontal, Spacing.m)

        // Asymmetry warning if needed
        if hasSignificantAsymmetry {
            AsymmetryWarningBanner()
                .padding(.horizontal, Spacing.m)
        }
    }
}

// MARK: - Computed Properties for Injury Metrics

// You'll need to compute averages from snapshots
// For now, using placeholder values from the run's gaitCycleMetrics
// In a real implementation, you'd average across all snapshots

private var averageLeftHipMobility: Int {
    // TODO: Average across all snapshots
    // For now, return a placeholder
    50
}

private var averageRightHipMobility: Int {
    // TODO: Average across all snapshots
    72
}

private var averageLeftHipStability: Int {
    // TODO: Average across all snapshots
    82
}

private var averageRightHipStability: Int {
    // TODO: Average across all snapshots
    78
}

private var computedRiskLevel: RiskLevel {
    let avgMobility = (averageLeftHipMobility + averageRightHipMobility) / 2
    let avgStability = (averageLeftHipStability + averageRightHipStability) / 2
    let overall = (avgMobility + avgStability) / 2

    if overall >= 75 {
        return .low
    } else if overall >= 50 {
        return .moderate
    } else {
        return .high
    }
}

private var hasSignificantAsymmetry: Bool {
    let mobilityDiff = abs(averageLeftHipMobility - averageRightHipMobility)
    let stabilityDiff = abs(averageLeftHipStability - averageRightHipStability)
    return mobilityDiff > 10 || stabilityDiff > 10
}

// Helper functions (unchanged)
private func scoreColor(_ score: Int) -> Color {
    if score >= 80 {
        return .successGreen
    } else if score >= 60 {
        return .warningYellow
    } else {
        return .errorRed
    }
}

private func formatDuration(_ duration: TimeInterval) -> String {
    let hours = Int(duration) / 3600
    let minutes = (Int(duration) % 3600) / 60
    let seconds = Int(duration) % 60

    if hours > 0 {
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
    return String(format: "%d:%02d", minutes, seconds)
}

private func formatPace(_ distance: Double, _ duration: TimeInterval) -> String
{
    guard distance > 0 else { return "0:00" }
    let pace = (duration / 60) / distance
    let minutes = Int(pace)
    let seconds = Int((pace - Double(minutes)) * 60)
    return String(format: "%d:%02d", minutes, seconds)
}

// MARK: - Lateral Metric Comparison
/// Shows left vs right comparison for a single injury metric
struct LateralMetricComparison: View {
    let metricName: String
    let leftValue: Int
    let rightValue: Int
    let color: Color

    private var asymmetryPercent: Int {
        abs(leftValue - rightValue)
    }

    var body: some View {
        VStack(spacing: Spacing.s) {
            // Metric name and asymmetry indicator
            HStack {
                Text(metricName)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)

                Spacer()

                // Asymmetry indicator
                if asymmetryPercent > 5 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                        Text("\(asymmetryPercent)% diff")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(
                        asymmetryPercent > 10 ? .errorRed : .warningYellow
                    )
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        (asymmetryPercent > 10
                            ? Color.errorRed : Color.warningYellow)
                            .opacity(0.15)
                    )
                    .cornerRadius(4)
                }
            }

            // Left vs Right comparison bars
            HStack(spacing: Spacing.xs) {
                // Left side
                HStack(spacing: Spacing.xs) {
                    Text("L")
                        .font(.caption)
                        .foregroundColor(.leftSide)
                        .fontWeight(.semibold)
                        .frame(width: 20)

                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Spacer()
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.leftSide.opacity(0.3),
                                            Color.leftSide,
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width
                                        * CGFloat(leftValue) / 100)
                        }
                    }
                    .frame(height: 8)

                    Text("\(leftValue)")
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                        .frame(width: 30)
                }

                // Center divider
                Rectangle()
                    .fill(Color.cardBorder)
                    .frame(width: 2, height: 24)

                // Right side
                HStack(spacing: Spacing.xs) {
                    Text("\(rightValue)")
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                        .frame(width: 30)

                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.rightSide,
                                            Color.rightSide.opacity(0.3),
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width
                                        * CGFloat(rightValue) / 100)
                            Spacer()
                        }
                    }
                    .frame(height: 8)

                    Text("R")
                        .font(.caption)
                        .foregroundColor(.rightSide)
                        .fontWeight(.semibold)
                        .frame(width: 20)
                }
            }
        }
    }
}

// MARK: - Risk Level Badge
struct RiskLevelBadge: View {
    let riskLevel: RiskLevel

    private var badgeColor: Color {
        switch riskLevel {
        case .low: return .successGreen
        case .moderate: return .warningYellow
        case .high: return .errorRed
        }
    }

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Image(systemName: riskLevel.icon)
                .font(.caption)
            Text(riskLevel.rawValue)
                .font(.caption)
        }
        .foregroundColor(badgeColor)
        .padding(.horizontal, Spacing.s)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Asymmetry Warning Banner
struct AsymmetryWarningBanner: View {
    var body: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.warningYellow)

            VStack(alignment: .leading, spacing: 2) {
                Text("Asymmetry Detected")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                Text("Significant difference between left and right sides")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(Spacing.s)
        .background(Color.warningYellow.opacity(0.1))
        .cornerRadius(CornerRadius.small)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - TEch Summary Card
struct TechViewSummaryCard: View {
    let run: Run
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Tech View")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                HStack(spacing: Spacing.m) {
                    HStack(spacing: Spacing.xs) {

                        Text(
                            "View your Force Portraits with different filters."
                        )
                        .font(.bodySmall)
                    }
                    .foregroundColor(.textSecondary)

                }
            }

            Spacer()

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

struct TrainingPlanSummaryCard: View {
    let run: Run
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Training Plan")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                HStack(spacing: Spacing.m) {
                    HStack(spacing: Spacing.xs) {

                        Text(
                            "View your Training Plan generated from your unique movement."
                        )
                        .font(.bodySmall)
                    }
                    .foregroundColor(.textSecondary)

                }
            }

            Spacer()
        }.padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )

    }
}

// MARK: - Gait Cycle Summary Card
/// Collapsible summary showing overall gait cycle analysis
struct GaitCycleSummaryCard: View {
    let run: Run
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header - Always visible
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Gait Analysis")
                            .font(.headline)
                            .foregroundColor(.textPrimary)

                        HStack(spacing: Spacing.m) {
                            HStack(spacing: Spacing.xs) {

                                Text(
                                    "A break down of your gait cycle by phase."
                                )
                                .font(.bodySmall)
                            }
                            .foregroundColor(.textSecondary)

                        }
                    }

                    Spacer()

                    Image(
                        systemName: isExpanded ? "chevron.up" : "chevron.down"
                    )
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                }
                .padding(Spacing.m)
            }

            // Expanded Content
            if isExpanded {
                VStack(spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)

                    // Dual Gait Cycle Dials
                    DualGaitCycleDial(metrics: run.gaitCycleMetrics)
                        .padding(Spacing.m)

                    Divider()
                        .background(Color.cardBorder)

                    // Gait Cycle Legend
                    GaitCycleLegend(metrics: run.gaitCycleMetrics)
                        .padding(.horizontal, Spacing.m)

                    Divider()
                        .background(Color.cardBorder)

                    // Timing Metrics
                    GaitCycleTimingCard(metrics: run.gaitCycleMetrics)
                        .padding(.horizontal, Spacing.m)
                }
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
}

// MARK: - Reusable Components

/// Progress bar component
struct RunSummaryProgressBar: View {
    let value: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.cardBorder)
                    .frame(height: 4)

                // Progress
                RoundedRectangle(cornerRadius: 2)
                    .fill(progressColor)
                    .frame(
                        width: geometry.size.width * CGFloat(value) / 100,
                        height: 4
                    )
            }
        }
        .frame(height: 4)
    }

    private var progressColor: Color {
        if value >= 80 {
            return .successGreen
        } else if value >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

/// Stat item for displaying key metrics
struct RunSummaryStatItem: View {
    let icon: String
    let value: String
    let label: String
    let unit: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.bodyMedium)
                .foregroundColor(.primaryOrange)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)

                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Metric progress row with colored bar
struct MetricProgressRow: View {
    let name: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            HStack {
                Text(name)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(value)")
                    .font(.bodySmall)
                    .foregroundColor(scoreColor)
                    .fontWeight(.medium)
            }

            // Progress Bar with metric color
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cardBorder)
                        .frame(height: 4)

                    // Progress with metric-specific color
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color.opacity(0.8))
                        .frame(
                            width: geometry.size.width * CGFloat(value) / 100,
                            height: 4
                        )
                }
            }
            .frame(height: 4)
        }
    }

    private var scoreColor: Color {
        if value >= 80 {
            return .successGreen
        } else if value >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

// MARK: - Preview
#Preview("Basic Summary") {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.0,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 85,
            braking: 78,
            impact: 82,
            sway: 75,
            variation: 88,
            warmup: 80,
            endurance: 77
        ),
        gaitCycleMetrics: GaitCycleMetrics()
    )

    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            BasicSummaryCard(run: sampleRun)
                .padding(Spacing.m)
        }
    }
}

#Preview("Overview Summary - Expanded") {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.0,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 85,
            braking: 78,
            impact: 82,
            sway: 75,
            variation: 88,
            warmup: 80,
            endurance: 77
        ),
        gaitCycleMetrics: GaitCycleMetrics()
    )

    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            OverviewSummaryCard(run: sampleRun, isExpanded: .constant(true))
                .padding(Spacing.m)
        }
    }
}

#Preview("Gait Cycle Summary - Expanded") {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.0,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 85,
            braking: 78,
            impact: 82,
            sway: 75,
            variation: 88,
            warmup: 80,
            endurance: 77
        ),
        gaitCycleMetrics: GaitCycleMetrics()
    )

    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            GaitCycleSummaryCard(run: sampleRun, isExpanded: .constant(true))
                .padding(Spacing.m)
        }
    }
}
