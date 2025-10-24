//
//  GeneratePlanView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//


//
//  GeneratePlanView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import SwiftUI

// MARK: - Generate Plan View
/// Modal view for generating/updating a training plan
struct GeneratePlanView: View {
    @ObservedObject var viewModel: TrainingPlanViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPainPoints: Set<PainPoint> = []
    
    // Sample metrics (in real app, would come from user's actual data)
    @State private var metrics: [ExerciseMetric: Int] = [
        .impact: 45,
        .braking: 62,
        .sway: 78,
        .cadence: 72,
        .flightTime: 55,
        .contactTime: 68,
        .hipMobility: 58,
        .hipStability: 71
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        headerSection
                        
                        // Current Metrics
                        metricsSection
                        
                        // Pain Points Selection
                        painPointsSection
                        
                        // Info Banner
                        infoBanner
                        
                        // Generate Button
                        generateButton
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.bottom, Spacing.xxl)
                }
            }
            .navigationTitle("Generate Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.primaryOrange)
            
            VStack(spacing: Spacing.s) {
                Text("Personalized Training Plan")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("We'll create a custom exercise program based on your current metrics and pain points")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, Spacing.xl)
    }
    
    // MARK: - Metrics Section
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.primaryOrange)
                
                Text("Your Current Metrics")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.s) {
                ForEach(Array(metrics.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { metric in
                    if let score = metrics[metric] {
                        MetricScoreRow(
                            metric: metric,
                            score: score
                        )
                    }
                }
            }
            
            Text("Exercises will be tailored to your current level for each metric")
                .font(.caption)
                .foregroundColor(.textTertiary)
                .padding(.top, Spacing.xs)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Pain Points Section
    private var painPointsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "bandage.fill")
                    .foregroundColor(.errorRed)
                
                Text("Pain Points (Optional)")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            Text("Select any areas where you're experiencing discomfort")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            FlowLayout(spacing: Spacing.s) {
                ForEach(PainPoint.allCases, id: \.self) { painPoint in
                    PainPointSelectionChip(
                        painPoint: painPoint,
                        isSelected: selectedPainPoints.contains(painPoint),
                        action: {
                            if selectedPainPoints.contains(painPoint) {
                                selectedPainPoints.remove(painPoint)
                            } else {
                                selectedPainPoints.insert(painPoint)
                            }
                        }
                    )
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
    
    // MARK: - Info Banner
    private var infoBanner: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 24))
                .foregroundColor(.infoBlue)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Dynamic Program")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text("Your plan will evolve as your metrics improve. We'll adjust exercises to match your progress.")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Spacing.m)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.infoBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Generate Button
    private var generateButton: some View {
        Button(action: {
            viewModel.generatePlan(
                metrics: metrics,
                painPoints: Array(selectedPainPoints)
            )
            dismiss()
        }) {
            HStack(spacing: Spacing.s) {
                Image(systemName: "sparkles")
                Text("Generate My Plan")
            }
            .font(.bodyLarge)
            .fontWeight(.semibold)
            .foregroundColor(.backgroundBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.primaryOrange)
            .cornerRadius(CornerRadius.large)
        }
    }
}

// MARK: - Metric Score Row
struct MetricScoreRow: View {
    let metric: ExerciseMetric
    let score: Int
    
    private var level: ExerciseLevel {
        ExerciseLevel.forScore(score)
    }
    
    var body: some View {
        HStack {
            // Metric info
            HStack(spacing: Spacing.s) {
                Image(systemName: metric.icon)
                    .foregroundColor(metric.color)
                    .font(.bodySmall)
                    .frame(width: 20)
                
                Text(metric.rawValue)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            // Score and level
            HStack(spacing: Spacing.s) {
                Text("\(score)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: level.icon)
                    Text(level.rawValue)
                }
                .font(.caption)
                .foregroundColor(level.color)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, 2)
                .background(level.color.opacity(0.15))
                .cornerRadius(4)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Pain Point Selection Chip
struct PainPointSelectionChip: View {
    let painPoint: PainPoint
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: painPoint.icon)
                    .font(.caption)
                
                Text(painPoint.rawValue)
                    .font(.bodySmall)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                }
            }
            .foregroundColor(isSelected ? .backgroundBlack : .textPrimary)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.s)
            .background(isSelected ? Color.errorRed : Color.backgroundBlack)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(isSelected ? Color.errorRed : Color.cardBorder, lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    GeneratePlanView(viewModel: TrainingPlanViewModel())
}