//
//  OverviewTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

//
//  OverviewTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Overview Tab
/// Shows summary statistics and recent activity for a runner
struct OverviewTab: View {
    let runner: Runner
    let runs: [Run]

    private var recentRuns: [Run] {
        Array(runs.prefix(5))
    }

    private var averagePace: String {
        guard !runs.isEmpty else { return "0:00" }
        let totalPace = runs.reduce(0.0) { result, run in
            result + (run.duration / 60 / run.distance)
        }
        let avgPace = totalPace / Double(runs.count)
        let minutes = Int(avgPace)
        let seconds = Int((avgPace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var totalDuration: String {
        let total = runs.reduce(0.0) { $0 + $1.duration }
        let hours = Int(total) / 3600
        let minutes = (Int(total) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    var body: some View {
        VStack(spacing: Spacing.m) {
            // Performance Summary
            performanceSummaryCard

            // Recent Activity
            recentActivitySection

            // Performance Breakdown
            //performanceBreakdownCard
        }
    }

    // MARK: - Performance Summary Card
    private var performanceSummaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Performance Summary")
                .font(.headline)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.m) {
                PerformanceMetricItem(
                    label: "Total Time",
                    value: totalDuration,
                    icon: "clock.fill",
                    color: .infoBlue
                )

                PerformanceMetricItem(
                    label: "Avg Pace",
                    value: averagePace,
                    icon: "speedometer",
                    color: .primaryOrange
                )
            }

            HStack(spacing: Spacing.m) {
                PerformanceMetricItem(
                    label: "Distance",
                    value: runner.formattedTotalDistance,
                    icon: "ruler",
                    color: .successGreen
                )

                PerformanceMetricItem(
                    label: "Efficiency",
                    value: "\(runner.averageEfficiency)",
                    icon: "chart.line.uptrend.xyaxis",
                    color: efficiencyColor(runner.averageEfficiency)
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

    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(recentRuns.count) runs")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            if recentRuns.isEmpty {
                EmptyRecentActivity()
            } else {
                ForEach(recentRuns) { run in
                    NavigationLink(destination: RunDetailView(run: run)) {
                        CompactRunCard(run: run)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // MARK: - Performance Breakdown Card
    private var performanceBreakdownCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Performance Breakdown")
                .font(.headline)
                .foregroundColor(.textPrimary)
            if !runs.isEmpty {
                let avgMetrics = calculateAverageMetrics()

                ForEach(avgMetrics, id: \.name) { metric in
                    PerformanceMetricBar(
                        name: metric.name,
                        value: metric.value,
                        color: metric.color
                    )
                }
            } else {
                EmptyPerformanceBreakdown()
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

    // MARK: - Helper Functions
    private func efficiencyColor(_ efficiency: Int) -> Color {
        if efficiency >= 80 {
            return .successGreen
        } else if efficiency >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }

    private func calculateAverageMetrics() -> [(
        name: String, value: Int, color: Color
    )] {
        guard !runs.isEmpty else { return [] }

        let avgEfficiency =
            runs.reduce(0) { $0 + $1.metrics.efficiency } / runs.count
        let avgSway = runs.reduce(0) { $0 + $1.metrics.sway } / runs.count
        let avgImpact = runs.reduce(0) { $0 + $1.metrics.impact } / runs.count
        let avgBraking = runs.reduce(0) { $0 + $1.metrics.braking } / runs.count
        let avgEndurance =
            runs.reduce(0) { $0 + $1.metrics.endurance } / runs.count

        return [
            (name: "Efficiency", value: avgEfficiency, color: .primaryOrange),
            (name: "Sway", value: avgSway, color: .infoBlue),
            (name: "Impact", value: avgImpact, color: .successGreen),
            (name: "Braking", value: avgBraking, color: .warningYellow),
            (name: "Endurance", value: avgEndurance, color: .errorRed),
        ]
    }
}

// MARK: - Performance Metric Item
struct PerformanceMetricItem: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.15))
                .cornerRadius(CornerRadius.small)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)

                Text(value)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
            }

            Spacer()
        }
        .padding(Spacing.s)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Compact Run Card
struct CompactRunCard: View {
    let run: Run

    private var formattedPace: String {
        guard run.distance > 0 else { return "0:00" }
        let pace = (run.duration / 60) / run.distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        HStack(spacing: Spacing.m) {
            // Date Badge
            VStack(spacing: 2) {
                Text(run.date.formatted(.dateTime.day()))
                    .font(.headline)
                    .foregroundColor(.primaryOrange)

                Text(run.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(width: 50)
            .padding(.vertical, Spacing.xs)
            .background(Color.primaryOrange.opacity(0.1))
            .cornerRadius(CornerRadius.small)

            // Run Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: run.mode.icon)
                        .font(.caption)
                    Text(run.mode.rawValue)
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.textPrimary)

                HStack(spacing: Spacing.m) {
                    Text("\(String(format: "%.2f", run.distance)) mi")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    Text("•")
                        .foregroundColor(.textTertiary)

                    Text("\(formattedPace) pace")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            // Efficiency Score
            VStack(spacing: 2) {
                Text("\(run.metrics.overallScore)")
                    .font(.headline)
                    .foregroundColor(scoreColor(run.metrics.overallScore))

                Text("Score")
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

// MARK: - Performance Metric Bar
struct PerformanceMetricBar: View {
    let name: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack {
                Text(name)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(value)")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 8)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(
                            width: geometry.size.width * CGFloat(value) / 100,
                            height: 8
                        )
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Empty States
struct EmptyRecentActivity: View {
    var body: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)

            Text("No recent runs")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.medium)
    }
}

struct EmptyPerformanceBreakdown: View {
    var body: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)

            Text("No performance data yet")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()

        ScrollView {
            OverviewTab(
                runner: Runner.sampleRunners[0],
                runs: SampleData.generateRuns(count: 20)
            )
            .padding()
        }
    }
}
