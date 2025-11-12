//
//  PersonalBestsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//


//
//  PersonalBestsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

/// Displays user's personal best scores for each metric
struct PersonalBestsView: View {
    @State private var personalBests: PersonalBests = PersonalBests.loadFromRuns(SampleData.runs)
    @State private var selectedCategory: BestCategory = .performance
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.xl) {
                    // Header with trophy
                    headerSection
                    
                    // Overall best run card
                    if let bestRun = personalBests.bestOverallRun {
                        BestOverallRunCard(run: bestRun)
                    }
                    
                    // Category selector
                    categorySelector
                    
                    // Metric cards based on selected category
                    metricCardsSection
                    
                    // Distance PRs
                    //distancePRsSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.l)
            }
        }
        
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.backgroundBlack)
            }
            
            VStack(spacing: Spacing.xs) {
                Text("Your Personal Records")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Keep pushing your limits!")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
    }
    
    // MARK: - Category Selector
    private var categorySelector: some View {
        HStack(spacing: Spacing.m) {
            ForEach(BestCategory.allCases) { category in
                CategoryTab(
                    category: category,
                    isSelected: selectedCategory == category,
                    action: { selectedCategory = category }
                )
            }
        }
    }
    
    // MARK: - Metric Cards Section
    private var metricCardsSection: some View {
        VStack(spacing: Spacing.m) {
            let metrics = selectedCategory.metrics
            
            ForEach(metrics, id: \.self) { metricType in
                if let best = personalBests.getBest(for: metricType) {
                    PersonalBestCard(
                        metricType: metricType,
                        best: best
                    )
                }
            }
        }
    }
    
    // MARK: - Distance PRs Section
    private var distancePRsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Distance Records")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                if let fastest5k = personalBests.fastest5k {
                    DistancePRCard(
                        distance: "5K",
                        run: fastest5k,
                        icon: "5.circle.fill"
                    )
                }
                
                if let fastest10k = personalBests.fastest10k {
                    DistancePRCard(
                        distance: "10K",
                        run: fastest10k,
                        icon: "10.circle.fill"
                    )
                }
                
                if let longestRun = personalBests.longestRun {
                    LongestRunCard(run: longestRun)
                }
            }
        }
    }
}

// MARK: - Best Category
enum BestCategory: String, CaseIterable, Identifiable {
    case performance = "Performance"
    
    case injury = "Injury Prevention"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .performance: return Icon.performanceIcon
        
        case .injury: return Icon.injuryDiagnosisticsIcon
        }
    }
    
    var metrics: [MetricType] {
        switch self {
        case .performance:
            return [.efficiency, .braking, .impact, .variation, .sway,  .warmup, .endurance]
        
        case .injury:
            return [.hipMobilityLeft, .hipStabilityLeft]
        }
    }
}

// MARK: - Category Tab
struct CategoryTab: View {
    let category: BestCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: category.icon)
                    .font(.title3)
                
                Text(category.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .backgroundBlack : .textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(
                isSelected
                    ? LinearGradient(
                        colors: [Color.primaryOrange, Color.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    : LinearGradient(
                        colors: [Color.cardBackground, Color.cardBackground],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.clear : Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Best Overall Run Card
struct BestOverallRunCard: View {
    let run: Run
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Best Overall Run")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(run.date.formatted(date: .long, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Overall score
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 0) {
                        Text("\(run.metrics.overallScore)")
                            .font(.titleSmall)
                            .fontWeight(.bold)
                            .foregroundColor(.backgroundBlack)
                        
                        Text("score")
                            .font(.system(size: 8))
                            .foregroundColor(.backgroundBlack.opacity(0.7))
                    }
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Quick stats
            HStack(spacing: Spacing.l) {
                QuickStat(
                    icon: "road.lanes",
                    value: String(format: "%.1f", run.distance),
                    label: "miles"
                )
                
                QuickStat(
                    icon: run.terrain.icon,
                    value: run.terrain.rawValue,
                    label: "terrain"
                )
                
                QuickStat(
                    icon: run.mode.icon,
                    value: run.mode.rawValue,
                    label: "mode"
                )
            }
        }
        .padding(Spacing.m)
        .background(
            LinearGradient(
                colors: [
                    Color.primaryOrange.opacity(0.15),
                    Color.primaryLight.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(
                    LinearGradient(
                        colors: [Color.primaryOrange, Color.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

// MARK: - Personal Best Card
struct PersonalBestCard: View {
    let metricType: MetricType
    let best: MetricBest
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Metric icon and color
            ZStack {
                Circle()
                    .fill(metricType.info.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: metricType.info.icon)
                    .font(.title3)
                    .foregroundColor(metricType.info.color)
            }
            
            // Metric info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(metricType.info.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(best.run.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                Text("\(best.score)")
                    .font(.titleMedium)
                    .foregroundColor(metricType.info.color)
                    .fontWeight(.bold)
                
                Text("personal best")
                    .font(.system(size: 10))
                    .foregroundColor(.textSecondary)
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
}

// MARK: - Distance PR Card
struct DistancePRCard: View {
    let distance: String
    let run: Run
    let icon: String
    
    var pace: String {
        let totalMinutes = run.duration / 60
        let paceMinutesPerMile = totalMinutes / run.distance
        let minutes = Int(paceMinutesPerMile)
        let seconds = Int((paceMinutesPerMile - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Distance icon
            ZStack {
                Circle()
                    .fill(Color.infoBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.infoBlue)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Fastest \(distance)")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(run.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                Text(pace)
                    .font(.titleSmall)
                    .foregroundColor(.infoBlue)
                    .fontWeight(.bold)
                
                Text("per mile")
                    .font(.system(size: 10))
                    .foregroundColor(.textSecondary)
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
}

// MARK: - Longest Run Card
struct LongestRunCard: View {
    let run: Run
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.successGreen.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(.successGreen)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Longest Run")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(run.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                Text(String(format: "%.1f", run.distance))
                    .font(.titleSmall)
                    .foregroundColor(.successGreen)
                    .fontWeight(.bold)
                
                Text("miles")
                    .font(.system(size: 10))
                    .foregroundColor(.textSecondary)
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
}

// MARK: - Quick Stat Component
struct PersonalBestQuickStat: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Personal Bests Model
struct PersonalBests {
    var efficiency: MetricBest?
    var braking: MetricBest?
    var impact: MetricBest?
    var sway: MetricBest?
    var variation: MetricBest?
    var warmup: MetricBest?
    var endurance: MetricBest?
    var hipMobilityLeft: MetricBest?
    var hipMobilityRight: MetricBest?
    var hipStabilityLeft: MetricBest?
    var hipStabilityRight: MetricBest?
    
    var bestOverallRun: Run?
    var fastest5k: Run?
    var fastest10k: Run?
    var longestRun: Run?
    
    func getBest(for metricType: MetricType) -> MetricBest? {
        switch metricType {
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
        default: return nil
        }
    }
    
    // MARK: - Load from Runs
    static func loadFromRuns(_ runs: [Run]) -> PersonalBests {
        var bests = PersonalBests()
        
        guard !runs.isEmpty else { return bests }
        
        // Find best for each metric
        bests.efficiency = findBestMetric(in: runs, keyPath: \.metrics.efficiency)
        bests.braking = findBestMetric(in: runs, keyPath: \.metrics.braking)
        bests.impact = findBestMetric(in: runs, keyPath: \.metrics.impact)
        bests.sway = findBestMetric(in: runs, keyPath: \.metrics.sway)
        bests.variation = findBestMetric(in: runs, keyPath: \.metrics.variation)
        bests.warmup = findBestMetric(in: runs, keyPath: \.metrics.warmup)
        bests.endurance = findBestMetric(in: runs, keyPath: \.metrics.endurance)
        
        // For now, use dummy data for hip metrics since they're not in RunMetrics
        // In real app, these would be actual metrics from runs
        if let sampleRun = runs.first {
            bests.hipMobilityLeft = MetricBest(score: 85, run: sampleRun)
            bests.hipMobilityRight = MetricBest(score: 83, run: sampleRun)
            bests.hipStabilityLeft = MetricBest(score: 88, run: sampleRun)
            bests.hipStabilityRight = MetricBest(score: 86, run: sampleRun)
        }
        
        // Find best overall run
        bests.bestOverallRun = runs.max(by: { $0.metrics.overallScore < $1.metrics.overallScore })
        
        // Find distance PRs
        bests.fastest5k = runs
            .filter { $0.distance >= 3.0 && $0.distance <= 3.3 }
            .min(by: { ($0.duration / $0.distance) < ($1.duration / $1.distance) })
        
        bests.fastest10k = runs
            .filter { $0.distance >= 6.0 && $0.distance <= 6.5 }
            .min(by: { ($0.duration / $0.distance) < ($1.duration / $1.distance) })
        
        bests.longestRun = runs.max(by: { $0.distance < $1.distance })
        
        return bests
    }
    
    private static func findBestMetric(in runs: [Run], keyPath: KeyPath<Run, Int>) -> MetricBest? {
        guard let bestRun = runs.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }) else {
            return nil
        }
        return MetricBest(score: bestRun[keyPath: keyPath], run: bestRun)
    }
}

struct MetricBest {
    let score: Int
    let run: Run
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PersonalBestsView()
    }
}
