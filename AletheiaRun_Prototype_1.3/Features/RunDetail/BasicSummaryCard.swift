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
            ProgressBar(value: run.metrics.overallScore)

            Divider()
                .background(Color.cardBorder)

            // Key Stats
            HStack(spacing: Spacing.xl) {
                StatItem(
                    icon: "figure.run",
                    value: String(format: "%.2f", run.distance),
                    label: "Distance",
                    unit: "mi"
                )

                StatItem(
                    icon: "timer",
                    value: formatDuration(run.duration),
                    label: "Duration",
                    unit: ""
                )

                StatItem(
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
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
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
    
    private func formatPace(_ distance: Double, _ duration: TimeInterval) -> String {
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
                                .foregroundColor(scoreColor(run.metrics.overallScore))
                            
                            Text("Overall")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
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
                        StatItem(
                            icon: "figure.run",
                            value: String(format: "%.2f", run.distance),
                            label: "Distance",
                            unit: "mi"
                        )
                        
                        StatItem(
                            icon: "timer",
                            value: formatDuration(run.duration),
                            label: "Duration",
                            unit: ""
                        )
                        
                        StatItem(
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
                            MetricProgressRow(name: "Efficiency", value: run.metrics.efficiency, color: .efficiencyColor)
                            MetricProgressRow(name: "Braking", value: run.metrics.braking, color: .brakingColor)
                            MetricProgressRow(name: "Impact", value: run.metrics.impact, color: .impactColor)
                            MetricProgressRow(name: "Sway", value: run.metrics.sway, color: .swayColor)
                            MetricProgressRow(name: "Variation", value: run.metrics.variation, color: .variationColor)
                            MetricProgressRow(name: "Warmup", value: run.metrics.warmup, color: .warmupColor)
                            MetricProgressRow(name: "Endurance", value: run.metrics.endurance, color: .enduranceColor)
                        }
                        .padding(.horizontal, Spacing.m)
                    }
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
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
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
    
    private func formatPace(_ distance: Double, _ duration: TimeInterval) -> String {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
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
                        Text("Session Gait Analysis")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: Spacing.m) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "timer")
                                    .font(.caption)
                                Text("\(run.gaitCycleMetrics.cadence) SPM")
                                    .font(.bodySmall)
                            }
                            .foregroundColor(.textSecondary)
                            
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "arrow.left.and.right")
                                    .font(.caption)
                                Text("\(run.gaitCycleMetrics.symmetryScore)% symmetry")
                                    .font(.bodySmall)
                            }
                            .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
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
struct ProgressBar: View {
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
        if value >= 80 { return .successGreen }
        else if value >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

/// Stat item for displaying key metrics
struct StatItem: View {
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
        if value >= 80 { return .successGreen }
        else if value >= 60 { return .warningYellow }
        else { return .errorRed }
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