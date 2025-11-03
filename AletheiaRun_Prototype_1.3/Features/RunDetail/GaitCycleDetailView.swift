// Features/RunDetail/GaitCycleDetailView.swift

import SwiftUI

/// Detailed view showing gait cycle analysis for a run with snapshot navigation
struct GaitCycleDetailView: View {
    let snapshots: [RunSnapshot]
    
    // State for snapshot navigation
    @State private var currentSnapshotIndex: Int = 0
    
    // Current snapshot's gait metrics
    private var currentGaitMetrics: GaitCycleMetrics {
        guard !snapshots.isEmpty,
              currentSnapshotIndex < snapshots.count else {
            return GaitCycleMetrics() // Default/sample metrics
        }
        return snapshots[currentSnapshotIndex].gaitCycleMetrics
    }
    
    // Current snapshot info
    private var currentSnapshot: RunSnapshot? {
        guard !snapshots.isEmpty,
              currentSnapshotIndex < snapshots.count else {
            return nil
        }
        return snapshots[currentSnapshotIndex]
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Snapshot Navigation Header
            if snapshots.count > 1 {
                snapshotNavigationHeader
            }
            
            // Dual Gait Cycle Dials
            gaitCycleDialSection
            
            // Phase Comparison Legend
            phaseBreakdownSection
            
            // Timing Metrics
            GaitCycleTimingCard(metrics: currentGaitMetrics)
            
//            // Symmetry Insights
//            SymmetryInsightCard(metrics: currentGaitMetrics)
//            
//            // Phase Details (expandable)
//            phaseDetailsSection
            
//            // Gait Cycle Over Time (if multiple snapshots)
//            if snapshots.count > 1 {
//                gaitProgressionSection
//            }
        }
    }
    
    // MARK: - Snapshot Navigation Header
    private var snapshotNavigationHeader: some View {
        VStack(spacing: Spacing.m) {
            // Header text
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Snapshot Navigation")
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    if let snapshot = currentSnapshot {
                        HStack(spacing: Spacing.xs) {
                            Text("Snapshot \(snapshot.snapshotNumber)")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text(formatTimestamp(snapshot.duration))
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text(snapshot.formattedDistance)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                // Snapshot counter
                Text("\(currentSnapshotIndex + 1) of \(snapshots.count)")
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(Color.primaryOrange.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
            }
            
            // Navigation controls
            HStack(spacing: Spacing.m) {
                // Previous button
                Button(action: previousSnapshot) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                            .font(.bodySmall)
                    }
                    .foregroundColor(
                        currentSnapshotIndex > 0
                            ? .primaryOrange : .textTertiary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.backgroundBlack)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                .disabled(currentSnapshotIndex == 0)

                // Timeline dots
                snapshotTimeline

                // Next button
                Button(action: nextSnapshot) {
                    HStack(spacing: Spacing.xs) {
                        Text("Next")
                            .font(.bodySmall)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(
                        currentSnapshotIndex < snapshots.count - 1
                            ? .primaryOrange : .textTertiary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.backgroundBlack)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                .disabled(currentSnapshotIndex >= snapshots.count - 1)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Snapshot Timeline
    private var snapshotTimeline: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xxs) {
                    ForEach(0..<snapshots.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                currentSnapshotIndex = index
                            }
                        }) {
                            Circle()
                                .fill(index == currentSnapshotIndex ? Color.primaryOrange : Color.cardBorder)
                                .frame(width: 8, height: 8)
                                .id(index)
                        }
                    }
                }
                .padding(.horizontal, Spacing.xs)
            }
            .frame(maxWidth: 150)
            .onChange(of: currentSnapshotIndex) { newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }
    
    // MARK: - Gait Cycle Dial Section
    private var gaitCycleDialSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Section header with snapshot info
            HStack {
                Text("Gait Cycle View")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Snapshot badge
                if let snapshot = currentSnapshot {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                        Text("#\(snapshot.snapshotNumber)")
                            .font(.caption)
                    }
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(Color.primaryOrange.opacity(0.15))
                    .cornerRadius(CornerRadius.small)
                }
            }
            
            DualGaitCycleDial(metrics: currentGaitMetrics)
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
            
            GaitCycleLegend(metrics: currentGaitMetrics)
        }
    }
    
    // MARK: - Phase Details Section
    private var phaseDetailsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Phase Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
//            ForEach(GaitCyclePhase.allCases) { phase in
//                GaitCyclePhaseCard(
//                    phase: phase,
//                    leftPercentage: percentageForPhase(phase, leg: .left),
//                    rightPercentage: percentageForPhase(phase, leg: .right)
//                )
//            }
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
            
            // Progression chart with mini previews
            gaitProgressionChart
        }
    }
    
    private var gaitProgressionChart: some View {
        VStack(spacing: Spacing.m) {
            // Scrollable snapshot preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.s) {
                    ForEach(Array(snapshots.enumerated()), id: \.offset) { index, snapshot in
                        SnapshotPreviewCard(
                            snapshot: snapshot,
                            index: index,
                            isSelected: index == currentSnapshotIndex,
                            action: {
                                withAnimation {
                                    currentSnapshotIndex = index
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, Spacing.m)
            }
            
            // Key metrics comparison chart
            gaitMetricsComparisonChart
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Snapshot Preview Card
    private func SnapshotPreviewCard(
        snapshot: RunSnapshot,
        index: Int,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                // Mini dual dials
//                HStack(spacing: 4) {
//                    MiniGaitCycleDial(
//                        legCycle: snapshot.gaitCycleMetrics.leftLeg,
//                        size: 35,
//                        label: "L"
//                    )
//                    MiniGaitCycleDial(
//                        legCycle: snapshot.gaitCycleMetrics.rightLeg,
//                        size: 35,
//                        label: "R"
//                    )
//                }
                
                // Snapshot number
                Text("#\(index + 1)")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                
                // Timestamp or distance
                Text(snapshot.formattedDistance)
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.xs)
            .background(isSelected ? Color.primaryOrange.opacity(0.15) : Color.backgroundBlack)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
    
    // MARK: - Gait Metrics Comparison Chart
    private var gaitMetricsComparisonChart: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Key Metrics Across Snapshots")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            // Contact Time Trend
            MetricTrendRow(
                label: "Contact Time",
                values: snapshots.map { $0.gaitCycleMetrics.contactTime },
                currentIndex: currentSnapshotIndex,
                unit: "ms",
                color: .errorRed
            )
            
            // Flight Time Trend
            MetricTrendRow(
                label: "Flight Time",
                values: snapshots.map { $0.gaitCycleMetrics.flightTime },
                currentIndex: currentSnapshotIndex,
                unit: "ms",
                color: .infoBlue
            )
            
            // Cadence Trend
            MetricTrendRow(
                label: "Cadence",
                values: snapshots.map { Double($0.gaitCycleMetrics.cadence) },
                currentIndex: currentSnapshotIndex,
                unit: "SPM",
                color: .primaryOrange
            )
            
            // Symmetry Score Trend
            MetricTrendRow(
                label: "Symmetry",
                values: snapshots.map { Double($0.gaitCycleMetrics.symmetryScore) },
                currentIndex: currentSnapshotIndex,
                unit: "",
                color: .successGreen
            )
        }
    }
    
    // MARK: - Helper Methods
    private enum Leg {
        case left, right
    }
    
    private func percentageForPhase(_ phase: GaitCyclePhase, leg: Leg) -> Double {
        let cycle = leg == .left ? currentGaitMetrics.leftLeg : currentGaitMetrics.rightLeg
        switch phase {
        case .landing: return cycle.landing
        case .stabilizing: return cycle.stabilizing
        case .launching: return cycle.launching
        case .flying: return cycle.flying
        }
    }
    
    private func previousSnapshot() {
        guard currentSnapshotIndex > 0 else { return }
        withAnimation {
            currentSnapshotIndex -= 1
        }
    }
    
    private func nextSnapshot() {
        guard currentSnapshotIndex < snapshots.count - 1 else { return }
        withAnimation {
            currentSnapshotIndex += 1
        }
    }
    
    private func formatTimestamp(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Metric Trend Row
/// Shows a mini sparkline chart for a metric across snapshots
struct MetricTrendRow: View {
    let label: String
    let values: [Double]
    let currentIndex: Int
    let unit: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Label and current value
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(formatValue(values[safe: currentIndex] ?? 0))
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 10))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .frame(width: 100, alignment: .leading)
            
            // Mini sparkline
            GeometryReader { geometry in
                SparklineChart(
                    values: values,
                    currentIndex: currentIndex,
                    color: color,
                    size: geometry.size
                )
            }
            .frame(height: 40)
            
            // Change indicator
            if values.count > 1, let current = values[safe: currentIndex],
               let previous = values[safe: currentIndex - 1] {
                ChangeIndicator(current: current, previous: previous)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
    
    private func formatValue(_ value: Double) -> String {
        if value >= 100 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

// MARK: - Sparkline Chart
struct SparklineChart: View {
    let values: [Double]
    let currentIndex: Int
    let color: Color
    let size: CGSize
    
    var body: some View {
        Canvas { context, size in
            guard values.count > 1,
                  let minValue = values.min(),
                  let maxValue = values.max(),
                  maxValue > minValue else { return }
            
            let valueRange = maxValue - minValue
            let xStep = size.width / CGFloat(values.count - 1)
            
            // Draw line path
            var path = Path()
            for (index, value) in values.enumerated() {
                let x = CGFloat(index) * xStep
                let normalizedValue = (value - minValue) / valueRange
                let y = size.height - (CGFloat(normalizedValue) * size.height)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            // Draw the line
            context.stroke(
                path,
                with: .color(color.opacity(0.6)),
                lineWidth: 2
            )
            
            // Draw dots
            for (index, value) in values.enumerated() {
                let x = CGFloat(index) * xStep
                let normalizedValue = (value - minValue) / valueRange
                let y = size.height - (CGFloat(normalizedValue) * size.height)
                
                let dotColor = index == currentIndex ? color : color.opacity(0.4)
                let dotSize: CGFloat = index == currentIndex ? 6 : 4
                
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: x - dotSize / 2,
                        y: y - dotSize / 2,
                        width: dotSize,
                        height: dotSize
                    )),
                    with: .color(dotColor)
                )
            }
        }
    }
}

// MARK: - Change Indicator
struct ChangeIndicator: View {
    let current: Double
    let previous: Double
    
    private var change: Double {
        current - previous
    }
    
    private var changePercent: Double {
        guard previous != 0 else { return 0 }
        return (change / previous) * 100
    }
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
                .font(.system(size: 10))
            
            Text(String(format: "%.1f%%", abs(changePercent)))
                .font(.system(size: 10))
        }
        .foregroundColor(changeColor)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(changeColor.opacity(0.15))
        .cornerRadius(4)
    }
    
    private var changeColor: Color {
        if abs(change) < 0.01 {
            return .textTertiary
        }
        return change >= 0 ? .successGreen : .errorRed
    }
}

// MARK: - Array Safe Subscript Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Existing Components (no changes)
// Keep all the existing components below:
// - SymmetryInsightCard
// - GaitCyclePhaseCard
// - LegPhaseDetail
// - InsightBanner
// - GaitCycleSnapshotSection

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

// (Keep all other existing components: GaitCyclePhaseCard, LegPhaseDetail, InsightBanner, GaitCycleSnapshotSection)

// MARK: - Preview
#Preview {
    ScrollView {
        GaitCycleDetailView(
            snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
        )
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.xl)
    }
    .background(Color.backgroundBlack)
}
