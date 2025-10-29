//
//  InjuryDiagnosticsDetailSection.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//


//
//  InjuryDiagnosticsDetailSection.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import SwiftUI

// MARK: - Injury Diagnostics Detail Section
/// Detailed view of injury metrics with left/right leg comparison
struct InjuryDiagnosticsDetailSection: View {
    let metrics: InjuryMetrics
    @State private var selectedLeg: LegSide? = nil // nil = both legs view
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header with leg selector
            sectionHeader
            
            // Risk Level Badge
            //riskLevelBanner
            
            // Leg Comparison or Individual View
            
            comparisonView
            
            
            // Symmetry Analysis
            symmetryAnalysis
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.primaryOrange)
                
                Text("Injury Diagnostics")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Risk Level Banner
    private var riskLevelBanner: some View {
        HStack(spacing: Spacing.m) {
            // Icon
            ZStack {
                Circle()
                    .fill(riskColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: metrics.riskLevel.icon)
                    .font(.system(size: 24))
                    .foregroundColor(riskColor)
            }
            
            // Risk Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(metrics.riskLevel.rawValue)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(riskMessage)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Overall Score
            VStack(spacing: 2) {
                Text("\((metrics.hipMobility + metrics.hipStability) / 2)")
                    .font(.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(riskColor)
                
                Text("Avg")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(Spacing.m)
        .background(riskColor.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(riskColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Comparison View (Both Legs)
    private var comparisonView: some View {
        VStack(spacing: Spacing.l) {
            // Hip Mobility Comparison
            LegComparisonRow(
                metricName: "Hip Mobility",
                leftValue: metrics.leftLeg.hipMobility,
                rightValue: metrics.rightLeg.hipMobility,
                icon: "figure.walk.motion"
            )
            
            // Hip Stability Comparison
            LegComparisonRow(
                metricName: "Hip Stability",
                leftValue: metrics.leftLeg.hipStability,
                rightValue: metrics.rightLeg.hipStability,
                icon: "figure.stand"
            )
            
        
            
            Divider()
                .background(Color.cardBorder)
            
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    

    
    // MARK: - Symmetry Analysis
    private var symmetryAnalysis: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "arrow.left.and.right.circle.fill")
                    .foregroundColor(.primaryOrange)
                
                Text("Symmetry Analysis")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(metrics.portraitSymmetry)")
                    .font(.titleSmall)
                    .fontWeight(.bold)
                    .foregroundColor(scoreColor(metrics.portraitSymmetry))
            }
            
            // Differences
            VStack(spacing: Spacing.l) {
                SymmetryDifferenceRow(
                    metric: "Hip Mobility",
                    leftValue: metrics.leftLeg.hipMobility,
                    rightValue: metrics.rightLeg.hipMobility
                )
                
                SymmetryDifferenceRow(
                    metric: "Hip Stability",
                    leftValue: metrics.leftLeg.hipStability,
                    rightValue: metrics.rightLeg.hipStability
                )
            }
            
            // Insight
            HStack(spacing: Spacing.s) {
                Image(systemName: symmetryIcon)
                    .foregroundColor(scoreColor(metrics.portraitSymmetry))
                
                Text(symmetryMessage)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.s)
            .background(scoreColor(metrics.portraitSymmetry).opacity(0.1))
            .cornerRadius(CornerRadius.small)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Helper Properties
    private var riskColor: Color {
        switch metrics.riskLevel {
        case .low: return .successGreen
        case .moderate: return .warningYellow
        case .high: return .errorRed
        }
    }
    
    private var riskMessage: String {
        switch metrics.riskLevel {
        case .low:
            return "Good biomechanics - maintain current form"
        case .moderate:
            return "Some areas need attention - review details"
        case .high:
            return "High injury risk - consider professional assessment"
        }
    }
    
    private var symmetryIcon: String {
        let score = metrics.portraitSymmetry
        if score >= 85 { return "checkmark.circle.fill" }
        if score >= 70 { return "exclamationmark.circle.fill" }
        return "xmark.circle.fill"
    }
    
    private var symmetryMessage: String {
        let score = metrics.portraitSymmetry
        if score >= 85 {
            return "Excellent symmetry between legs"
        } else if score >= 70 {
            return "Moderate asymmetry - monitor over time"
        } else {
            return "Significant asymmetry detected - address imbalances"
        }
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


// MARK: - Leg Comparison Row
struct LegComparisonRow: View {
    let metricName: String
    let leftValue: Int
    let rightValue: Int
    let icon: String
    
    private var difference: Int {
        abs(leftValue - rightValue)
    }
    
    private var strongerSide: LegSide? {
        if leftValue > rightValue { return .left }
        if rightValue > leftValue { return .right }
        return nil
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
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            // Header
            HStack {
               
                
                Text(metricName)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if difference > 5 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                        Text("\(difference)% diff")
                            .font(.caption)
                    }
                    .foregroundColor(.warningYellow)
                }
            }
            
            // Comparison Bars
            VStack(spacing: Spacing.m) {
                // Left Leg
                VStack(alignment: .leading, spacing: Spacing.s) {
                    HStack {
                        Image(systemName: LegSide.left.icon)
                            .font(.caption)
                            .foregroundColor(Color.infoBlue)
                        Text("Left")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("\(leftValue)")
                            .font(.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                    }
                    

                    
                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.cardBorder)
                                .frame(height: 8)

                            // Progress
                            RoundedRectangle(cornerRadius: 2)
                                .fill(scoreColor(leftValue))
                                .frame(
                                    width: geometry.size.width * CGFloat(leftValue) / 100,
                                    height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Right Leg
                VStack(alignment: .leading, spacing: Spacing.s) {
                    HStack {
                        Image(systemName: LegSide.right.icon)
                            .font(.caption)
                            .foregroundColor(Color.infoBlue)
                        Text("Right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("\(rightValue)")
                            .font(.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                    }
                    
//                    GeometryReader { geometry in
//                        ZStack(alignment: .leading) {
//                            RoundedRectangle(cornerRadius: 4)
//                                .fill(Color.cardBorder)
//                                .frame(height: 8)
//                            
//                            RoundedRectangle(cornerRadius: 4)
//                                .fill(LegSide.right.color)
//                                .frame(
//                                    width: geometry.size.width * CGFloat(rightValue) / 100,
//                                    height: 8
//                                )
//                        }
//                    }
//                    .frame(height: 8)
                    
                    
                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.cardBorder)
                                .frame(height: 8)

                            // Progress
                            RoundedRectangle(cornerRadius: 2)
                                .fill(scoreColor(rightValue))
                                .frame(
                                    width: geometry.size.width * CGFloat(rightValue) / 100,
                                    height: 8)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
    }
}

// MARK: - Individual Metric Row
struct IndividualMetricRow: View {
    let name: String
    let value: Int
    let icon: String
    let description: String
    @State private var showDescription = false
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
                    .font(.bodySmall)
                
                Text(name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(value)")
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(scoreColor(value))
                
                Button(action: { showDescription.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(scoreColor(value))
                        .frame(
                            width: geometry.size.width * CGFloat(value) / 100,
                            height: 6
                        )
                }
            }
            .frame(height: 6)
            
            if showDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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

// MARK: - Overall Metric Badge
struct OverallMetricBadge: View {
    let label: String
    let value: Int
    let icon: String
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)
            
            Text("\(value)")
                .font(.titleMedium)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Symmetry Difference Row
struct SymmetryDifferenceRow: View {
    let metric: String
    let leftValue: Int
    let rightValue: Int
    
    private var difference: Int {
        abs(leftValue - rightValue)
    }
    
    private var dominantSide: String {
        if leftValue > rightValue {
            return "Left stronger by \(difference)%"
        } else if rightValue > leftValue {
            return "Right stronger by \(difference)%"
        } else {
            return "Balanced"
        }
    }
    
    private var differenceColor: Color {
        if difference <= 5 {
            return .successGreen
        } else if difference <= 10 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
    
    var body: some View {
        HStack {
            Text(metric)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(dominantSide)
                .font(.bodySmall)
                .foregroundColor(differenceColor)
                .fontWeight(.medium)
        }
        .padding(.vertical, Spacing.xxs)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            InjuryDiagnosticsDetailSection(
                metrics: InjuryMetrics(
                    leftLeg: LegInjuryMetrics(
                        hipMobility: 78,
                        hipStability: 85
                    ),
                    rightLeg: LegInjuryMetrics(
                        hipMobility: 82,
                        hipStability: 76
                    )
                )
            )
            .padding()
        }
    }
}
