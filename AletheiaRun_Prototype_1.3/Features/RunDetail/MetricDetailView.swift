// Features/RunDetail/MetricDetailView.swift

import SwiftUI

/// Detailed view for a specific metric showing progression over the run
struct MetricDetailView: View {
    let metricType: MetricType
    let snapshots: [RunSnapshot]
    let averageValue: Int
    @Environment(\.dismiss) private var dismiss
    
    private var metricInfo: MetricInfo {
        metricType.info
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Metric Overview Card
                    metricOverviewCard
                    
                    // Metric Over Time Chart
                    metricProgressionChart
                    
                    // Video Placeholder
                    videoPlaceholder
                    
                    // What is this metric?
                    whatIsItSection
                    
                    // Why it matters
                    whyItMattersSection
                    
                    // How to optimize
                    howToOptimizeSection
                    
                    // Related metrics
                    relatedMetricsSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(metricInfo.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Metric Overview Card
    private var metricOverviewCard: some View {
        VStack(spacing: Spacing.m) {
            // Icon and average score
            HStack(spacing: Spacing.l) {
                ZStack {
                    Circle()
                        .fill(metricInfo.color.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: metricInfo.icon)
                        .font(.system(size: 36))
                        .foregroundColor(metricInfo.color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Average")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(averageValue)")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(metricInfo.colorForValue(averageValue))
                        
                        Text("/100")
                            .font(.titleSmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text(metricInfo.statusForValue(averageValue))
                        .font(.bodySmall)
                        .foregroundColor(metricInfo.colorForValue(averageValue))
                        .padding(.horizontal, Spacing.s)
                        .padding(.vertical, 4)
                        .background(metricInfo.colorForValue(averageValue).opacity(0.15))
                        .cornerRadius(CornerRadius.small)
                }
                
                Spacer()
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Stats grid
            HStack(spacing: Spacing.m) {
                MetricStatItem(
                    label: "Highest",
                    value: "\(highestValue)",
                    icon: "arrow.up.circle.fill",
                    color: .successGreen
                )
                
                MetricStatItem(
                    label: "Lowest",
                    value: "\(lowestValue)",
                    icon: "arrow.down.circle.fill",
                    color: .errorRed
                )
                
                MetricStatItem(
                    label: "Range",
                    value: "\(range)",
                    icon: "arrow.left.and.right.circle.fill",
                    color: .infoBlue
                )
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(metricInfo.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Metric Progression Chart
    private var metricProgressionChart: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Progression Over Run")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(snapshots.count) snapshots")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            // Chart placeholder
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.cardBackground)
                    .frame(height: 220)
                
                VStack(spacing: Spacing.m) {
                    // Simple line chart visualization
                    MetricLineChart(
                        snapshots: snapshots,
                        metricType: metricType,
                        color: metricInfo.color
                    )
                    .frame(height: 160)
                    .padding(.horizontal, Spacing.s)
                    
                    // X-axis label
                    HStack {
                        Text("Start")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        
                        Spacer()
                        
                        Text("End")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.horizontal, Spacing.m)
                }
                .padding(.vertical, Spacing.m)
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
            
            // Chart insights
            if let insight = chartInsight {
                HStack(spacing: Spacing.s) {
                    Image(systemName: insight.icon)
                        .foregroundColor(insight.color)
                    
                    Text(insight.message)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.s)
                .background(insight.color.opacity(0.1))
                .cornerRadius(CornerRadius.small)
            }
        }
    }
    
    // MARK: - Video Placeholder
    private var videoPlaceholder: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Learn More")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ZStack {
                // Background with gradient
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                metricInfo.color.opacity(0.3),
                                metricInfo.color.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                VStack(spacing: Spacing.m) {
                    // Play button
                    ZStack {
                        Circle()
                            .fill(Color.backgroundBlack.opacity(0.7))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .stroke(metricInfo.color, lineWidth: 2)
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "play.fill")
                            .font(.system(size: 28))
                            .foregroundColor(metricInfo.color)
                    }
                    
                    Text(metricInfo.videoPlaceholderTitle)
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Video Coming Soon")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.m)
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(metricInfo.color.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    // MARK: - What Is It Section
    private var whatIsItSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(metricInfo.color)
                
                Text("What is \(metricInfo.name)?")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            Text(metricInfo.description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Why It Matters Section
    private var whyItMattersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(metricInfo.color)
                
                Text("Why It Matters")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(Array(metricInfo.whyItMatters.enumerated()), id: \.offset) { index, reason in
                    HStack(alignment: .top, spacing: Spacing.s) {
                        ZStack {
                            Circle()
                                .fill(metricInfo.color.opacity(0.2))
                                .frame(width: 24, height: 24)
                            
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(metricInfo.color)
                        }
                        
                        Text(reason)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
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
    
    // MARK: - How to Optimize Section
    private var howToOptimizeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .foregroundColor(metricInfo.color)
                
                Text("How to Optimize")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(Array(metricInfo.howToOptimize.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top, spacing: Spacing.s) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(metricInfo.color)
                            .font(.system(size: 18))
                        
                        Text(tip)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(Spacing.s)
                    .background(Color.cardBackground.opacity(0.5))
                    .cornerRadius(CornerRadius.small)
                }
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
    
    // MARK: - Related Metrics Section
    private var relatedMetricsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(metricInfo.color)
                
                Text("Related Metrics")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.xs) {
                ForEach(metricInfo.relatedMetrics, id: \.self) { relatedMetric in
                    HStack {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(metricInfo.color)
                        
                        Text(relatedMetric)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.s)
                    .background(Color.cardBackground.opacity(0.5))
                    .cornerRadius(CornerRadius.small)
                }
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
    
    // MARK: - Helper Computed Properties
    private var highestValue: Int {
        snapshots.map { valueForMetric($0) }.max() ?? 0
    }
    
    private var lowestValue: Int {
        snapshots.map { valueForMetric($0) }.min() ?? 0
    }
    
    private var range: Int {
        highestValue - lowestValue
    }
    
    private var chartInsight: (message: String, icon: String, color: Color)? {
        let values = snapshots.map { valueForMetric($0) }
        guard values.count > 2 else { return nil }
        
        let firstHalf = values.prefix(values.count / 2)
        let secondHalf = values.suffix(values.count / 2)
        
        let firstAvg = firstHalf.reduce(0, +) / firstHalf.count
        let secondAvg = secondHalf.reduce(0, +) / secondHalf.count
        
        let difference = secondAvg - firstAvg
        
        if difference > 5 {
            return (
                "Great job! Your \(metricInfo.name.lowercased()) improved throughout the run.",
                "arrow.up.circle.fill",
                .successGreen
            )
        } else if difference < -5 {
            return (
                "Your \(metricInfo.name.lowercased()) decreased as the run progressed. Focus on maintaining form.",
                "arrow.down.circle.fill",
                .warningYellow
            )
        } else {
            return (
                "Consistent \(metricInfo.name.lowercased()) maintained throughout the run.",
                "checkmark.circle.fill",
                .infoBlue
            )
        }
    }
    
    private func valueForMetric(_ snapshot: RunSnapshot) -> Int {
        switch metricType {
        case .efficiency: return snapshot.performanceMetrics.efficiency
        case .sway: return snapshot.performanceMetrics.sway
        case .endurance: return snapshot.performanceMetrics.endurance
        case .warmup: return snapshot.performanceMetrics.warmup
        case .impact: return snapshot.performanceMetrics.impact
        case .braking: return snapshot.performanceMetrics.braking
        case .variation: return snapshot.performanceMetrics.variation
        }
    }
}

// MARK: - Metric Stat Item
struct MetricStatItem: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.titleSmall)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Metric Line Chart
struct MetricLineChart: View {
    let snapshots: [RunSnapshot]
    let metricType: MetricType
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<5) { i in
                        HStack {
                            Text("\(100 - i * 20)")
                                .font(.system(size: 10))
                                .foregroundColor(.textTertiary)
                                .frame(width: 30, alignment: .trailing)
                            
                            Rectangle()
                                .fill(Color.cardBorder.opacity(0.3))
                                .frame(height: 1)
                        }
                        
                        if i < 4 {
                            Spacer()
                        }
                    }
                }
                
                // Line chart
                Path { path in
                    let values = snapshots.map { Double(valueForMetric($0)) }
                    guard !values.isEmpty else { return }
                    
                    let width = geometry.size.width - 40
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(values.count - 1, 1))
                    
                    // Start path
                    let firstY = height - (CGFloat(values[0]) / 100.0 * height)
                    path.move(to: CGPoint(x: 40, y: firstY))
                    
                    // Draw line
                    for (index, value) in values.enumerated() {
                        let x = 40 + CGFloat(index) * stepX
                        let y = height - (CGFloat(value) / 100.0 * height)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(color, lineWidth: 3)
                
                // Data points
                ForEach(Array(snapshots.enumerated()), id: \.offset) { index, snapshot in
                    let values = snapshots.map { Double(valueForMetric($0)) }
                    let width = geometry.size.width - 40
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(values.count - 1, 1))
                    let value = Double(valueForMetric(snapshot))
                    
                    let x = 40 + CGFloat(index) * stepX
                    let y = height - (CGFloat(value) / 100.0 * height)
                    
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                }
            }
        }
    }
    
    private func valueForMetric(_ snapshot: RunSnapshot) -> Int {
        switch metricType {
        case .efficiency: return snapshot.performanceMetrics.efficiency
        case .sway: return snapshot.performanceMetrics.sway
        case .endurance: return snapshot.performanceMetrics.endurance
        case .warmup: return snapshot.performanceMetrics.warmup
        case .impact: return snapshot.performanceMetrics.impact
        case .braking: return snapshot.performanceMetrics.braking
        case .variation: return snapshot.performanceMetrics.variation
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MetricDetailView(
            metricType: .efficiency,