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
            performanceBreakdownCard
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
                    label: "Total Distance",
                    value: runner.formattedTotalDistance,
                    icon: "map.fill",
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