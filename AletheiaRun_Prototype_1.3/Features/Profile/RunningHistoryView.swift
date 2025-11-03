//
//  RunningHistoryView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/20/25.
//

// Features/Profile/RunningHistoryView.swift

import SwiftUI

/// Comprehensive view showing runner's overall history with toggleable metrics
struct RunningHistoryView: View {
    @StateObject private var viewModel = RunningHistoryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Time Period Selector
                    timePeriodSelector

                    // Overall Stats Summary
                    //                    overallStatsSection

                    // Multi-Metric Chart
                    multiMetricChart

                    // Metric Toggles
                    metricToggles

                    // Detailed Stats Cards
                    detailedStatsSection

                    // Trends & Insights
                    //trendsSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Running History")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            viewModel.loadData()
        }
    }

    // MARK: - Time Period Selector
    private var timePeriodSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Time Period")
                .font(.headline)
                .foregroundColor(.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.s) {
                    ForEach(TimePeriod.allCases) { period in
                        TimePeriodButton(
                            period: period,
                            isSelected: viewModel.selectedPeriod == period,
                            action: {
                                withAnimation {
                                    viewModel.selectedPeriod = period
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Overall Stats Summary
    private var overallStatsSection: some View {
        VStack(spacing: Spacing.m) {
            HStack(spacing: Spacing.m) {
                OverallStatCard(
                    icon: "figure.run",
                    value: "\(viewModel.totalRuns)",
                    label: "Total Runs",
                    color: .primaryOrange
                )

                OverallStatCard(
                    icon: "road.lanes",
                    value: String(format: "%.1f", viewModel.totalDistance),
                    label: "Miles",
                    color: .successGreen
                )
            }

            HStack(spacing: Spacing.m) {
                OverallStatCard(
                    icon: "clock.fill",
                    value: viewModel.totalTimeFormatted,
                    label: "Total Time",
                    color: .infoBlue
                )

                OverallStatCard(
                    icon: "speedometer",
                    value: viewModel.averagePaceFormatted,
                    label: "Avg Pace",
                    color: .warningYellow
                )
            }
        }
    }

    // MARK: - Multi-Metric Chart
    private var multiMetricChart: some View {

        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Metrics Over Time")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(viewModel.dataPoints.count) data points")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.cardBackground)

                if viewModel.enabledMetrics.isEmpty {
                    // Empty state
                    VStack(spacing: Spacing.m) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 50))
                            .foregroundColor(.textTertiary)

                        Text("Select metrics below to view")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(height: 300)
                } else {
                    // Multi-line chart
                    MultiMetricLineChart(
                        dataPoints: viewModel.dataPoints,
                        enabledMetrics: viewModel.enabledMetrics,
                        period: viewModel.selectedPeriod
                    )
                    .frame(height: 300)
                    .padding(Spacing.m)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }

    // MARK: - Metric Toggles
    private var metricToggles: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Select Metrics")
                .font(.headline)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.s) {
                ForEach(MetricType.allCases, id: \.self) { metric in
                    MetricToggleRow(
                        metric: metric,
                        isEnabled: viewModel.enabledMetrics.contains(metric),
                        averageValue: viewModel.averageForMetric(metric),
                        action: {
                            withAnimation {
                                viewModel.toggleMetric(metric)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Detailed Stats Section
    private var detailedStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Detailed Breakdown")
                .font(.headline)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.s) {
                ForEach(MetricType.allCases, id: \.self) { metric in
                    DetailedMetricCard(
                        metric: metric,
                        stats: viewModel.statsForMetric(metric)
                    )
                }
            }
        }
    }

    // MARK: - Trends Section
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Trends & Insights")
                .font(.headline)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.s) {
                ForEach(viewModel.insights) { insight in
                    InsightCard(insight: insight)
                }
            }
        }
    }
}

// MARK: - Time Period Enum
enum TimePeriod: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
    case allTime = "All Time"

    var id: String { rawValue }

    var daysBack: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .sixMonths: return 180
        case .year: return 365
        case .allTime: return nil
        }
    }
}

// MARK: - Time Period Button
struct TimePeriodButton: View {
    let period: TimePeriod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(period.rawValue)
                .font(.bodySmall)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .black : .textPrimary)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.s)
                .background(
                    isSelected ? Color.primaryOrange : Color.cardBackground
                )
                .cornerRadius(CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(
                            isSelected ? Color.primaryOrange : Color.cardBorder,
                            lineWidth: 1
                        )
                )
        }
    }
}

// MARK: - Overall Stat Card
struct OverallStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.s) {
            HStack(spacing: Spacing.s) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)

                Spacer()
            }

            Text(value)
                .font(.titleMedium)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(label)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Updated Metric Toggle Row with Dot Pattern
struct MetricToggleRow: View {
    let metric: MetricType
    let isEnabled: Bool
    let averageValue: Int
    let action: () -> Void

    private var metricInfo: MetricInfo {
        metric.info
    }

    private var isHipMetric: Bool {
        switch metric {
        case .hipMobilityLeft, .hipMobilityRight, .hipStabilityLeft,
            .hipStabilityRight:
            return true
        default:
            return false
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            isEnabled ? metricInfo.color : Color.cardBorder,
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)

                    if isEnabled {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(metricInfo.color)
                            .frame(width: 16, height: 16)
                    }
                }

                // Metric icon
                ZStack {
                    Circle()
                        .fill(metricInfo.color.opacity(0.2))
                        .frame(width: 36, height: 36)

                    Image(systemName: metricInfo.icon)
                        .foregroundColor(metricInfo.color)
                }

                // Metric info
                VStack(alignment: .leading, spacing: 2) {
                    Text(metricInfo.name)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text("Avg: \(averageValue)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                // Legend indicator
                if isEnabled {
                    if isHipMetric {
                        // Alternating dots pattern for hip metrics
                        HipMetricDotLegend(metric: metric)
                    } else {
                        // Regular color bar for other metrics
                        RoundedRectangle(cornerRadius: 2)
                            .fill(metricInfo.color)
                            .frame(width: 4, height: 40)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        isEnabled
                            ? metricInfo.color.opacity(0.5) : Color.cardBorder,
                        lineWidth: isEnabled ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Hip Metric Dot Legend
struct HipMetricDotLegend: View {
    let metric: MetricType

    private var sideColor: Color {
        switch metric {
        case .hipMobilityLeft, .hipStabilityLeft:
            return .leftSide
        case .hipMobilityRight, .hipStabilityRight:
            return .rightSide
        default:
            return metric.info.color
        }
    
    }

    private var metricTypeColor: Color {
        switch metric {
        case .hipMobilityLeft, .hipMobilityRight:
            return .hipMobilityColor
        case .hipStabilityLeft, .hipStabilityRight:
            return .hipStabilityColor
        default:
            return sideColor
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            // Alternating dots pattern
            Circle()
                .fill(sideColor)
                .frame(width: 8, height: 8)

            Circle()
                .fill(metricTypeColor)
                .frame(width: 8, height: 8)

            Circle()
                .fill(sideColor)
                .frame(width: 8, height: 8)

            Circle()
                .fill(metricTypeColor)
                .frame(width: 8, height: 8)
        }
    }
}



// MARK: - Detailed Metric Card
struct DetailedMetricCard: View {
    let metric: MetricType
    let stats: MetricStats
    @State private var isExpanded = false

    private var metricInfo: MetricInfo {
        metric.info
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(spacing: Spacing.m) {
                    ZStack {
                        Circle()
                            .fill(metricInfo.color.opacity(0.2))
                            .frame(width: 40, height: 40)

                        Image(systemName: metricInfo.icon)
                            .foregroundColor(metricInfo.color)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(metricInfo.name)
                            .font(.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)

//                        Text("Average: \(stats.average)")
//                            .font(.bodySmall)
//                            .foregroundColor(.textSecondary)
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

            // Expanded content
            if isExpanded {
                VStack(spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)

                    HStack(spacing: Spacing.m) {
                        
                        RunningHistoryStatItem(
                            label: "Worst", value: "\(stats.worst)",
                            color: .errorRed)
                        
                        RunningHistoryStatItem(
                            label: "Best", value: "\(stats.best)",
                            color: .successGreen)
                        RunningHistoryStatItem(
                            label: "Range", value: "\(stats.range)",
                            color: .infoBlue)
                    }

                    // Consistency indicator
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        HStack {
                            Text("Average Score")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)

                            Spacer()

//                            Text(stats.consistencyLabel)
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .foregroundColor(stats.consistencyColor)
                        }

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.cardBorder)
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(stats.consistencyColor)
                                    .frame(
                                        width: geometry.size.width
                                        * CGFloat(stats.average) / 100,
                                        height: 8
                                    )
                            }
                        }
                        .frame(height: 8)
                    }
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
}

// MARK: - Stat Item
struct RunningHistoryStatItem: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text(value)
                .font(.headline)
                .foregroundColor(color)

            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s)
        .background(color.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Insight Card
struct InsightCard: View {
    let insight: Insight

    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: insight.icon)
                .font(.system(size: 24))
                .foregroundColor(insight.color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(insight.title)
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                Text(insight.message)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(Spacing.m)
        .background(insight.color.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(insight.color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Supporting Models
struct MetricStats {
    let average: Int
    let best: Int
    let worst: Int
    let range: Int
    let consistency: Int  // 0-100
    let trend: Trend

    //    var trendPercentage: String {
    //        let prefix = trend == .improving ? "+" : ""
    //        return "\(prefix)\(abs(trend.value))%"
    //    }

    var consistencyLabel: String {
        if consistency >= 80 { return "Very Consistent" }
        if consistency >= 60 { return "Consistent" }
        if consistency >= 40 { return "Moderate" }
        return "Variable"
    }

    var consistencyColor: Color {
        if consistency >= 80 { return .successGreen }
        if consistency >= 60 { return .infoBlue }
        if consistency >= 40 { return .warningYellow }
        return .errorRed
    }
}

// MARK: - Trend Enum (SIMPLIFIED)
enum Trend: Equatable {
    case improving(Int)
    case declining(Int)
    case stable

    var icon: String {
        switch self {
        case .improving: return "arrow.up.right"
        case .declining: return "arrow.down.right"
        case .stable: return "arrow.right"
        }
    }

    var color: Color {
        switch self {
        case .improving: return .successGreen
        case .declining: return .errorRed
        case .stable: return .infoBlue
        }
    }

    var value: Int {
        switch self {
        case .improving(let val): return val
        case .declining(let val): return val
        case .stable: return 0
        }
    }

    var isImproving: Bool {
        if case .improving = self { return true }
        return false
    }

    var isDeclining: Bool {
        if case .declining = self { return true }
        return false
    }
}

struct Insight: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
    let color: Color
}

// MARK: - Updated DataPoint
struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let efficiency: Int
    let braking: Int
    let impact: Int
    let sway: Int
    let variation: Int
    let warmup: Int
    let endurance: Int
    let hipMobilityLeft: Int  // NEW
    let hipMobilityRight: Int  // NEW
    let hipStabilityLeft: Int  // NEW
    let hipStabilityRight: Int  // NEW
    let portraitSymmetry: Int
    let overallScore: Int

    func valueFor(metric: MetricType) -> Int {
        switch metric {
        case .efficiency: return efficiency
        case .braking: return braking
        case .impact: return impact
        case .sway: return sway
        case .variation: return variation
        case .warmup: return warmup
        case .endurance: return endurance
        case .hipMobilityLeft: return hipMobilityLeft
        case .hipMobilityRight: return hipMobilityRight
        case .hipStabilityLeft: return hipStabilityLeft
        case .hipStabilityRight: return hipStabilityRight
        case .portraitSymmetry: return portraitSymmetry
        case .overallScore: return overallScore
        }
    }
}




#Preview("Running History") {
    NavigationStack {
        RunningHistoryView()
    }
}
