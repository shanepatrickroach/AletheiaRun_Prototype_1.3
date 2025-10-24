//
//  ExerciseDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//


//
//  ExerciseDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import SwiftUI

// MARK: - Exercise Detail View
/// Detailed view of a single exercise with instructions and benefits
struct ExerciseDetailView: View {
    let exercise: Exercise
    @ObservedObject var viewModel: TrainingPlanViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Video/Image Placeholder
                    videoPlaceholder
                    
                    // Exercise Header
                    exerciseHeader
                    
                    // Quick Stats
                    quickStats
                    
                    // Instructions
                    instructionsSection
                    
                    // Benefits
                    benefitsSection
                    
                    // Equipment
                    if !exercise.equipmentNeeded.isEmpty {
                        equipmentSection
                    }
                    
                    // Complete Button
                    completeButton
                }
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, Spacing.xxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Video Placeholder
    private var videoPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(
                    LinearGradient(
                        colors: [
                            exercise.targetMetric.color.opacity(0.3),
                            exercise.targetMetric.color.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: Spacing.m) {
                Image(systemName: exercise.videoThumbnail)
                    .font(.system(size: 60))
                    .foregroundColor(exercise.targetMetric.color)
                
                Text("Video Tutorial")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "play.circle.fill")
                    Text("Play")
                }
                .font(.bodySmall)
                .foregroundColor(.primaryOrange)
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.s)
                .background(Color.primaryOrange.opacity(0.15))
                .cornerRadius(CornerRadius.large)
            }
        }
        .frame(height: 250)
        .cornerRadius(CornerRadius.large)
    }
    
    // MARK: - Exercise Header
    private var exerciseHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Level badge
            HStack(spacing: Spacing.xs) {
                Image(systemName: exercise.level.icon)
                Text(exercise.level.rawValue)
            }
            .font(.bodySmall)
            .foregroundColor(exercise.level.color)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.xs)
            .background(exercise.level.color.opacity(0.15))
            .cornerRadius(CornerRadius.large)
            
            // Exercise name
            Text(exercise.name)
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            // Description
            Text(exercise.description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Quick Stats
    private var quickStats: some View {
        HStack(spacing: Spacing.m) {
            // Target Metric
            QuickStatBadge(
                icon: exercise.targetMetric.icon,
                label: "Targets",
                value: exercise.targetMetric.rawValue,
                color: exercise.targetMetric.color
            )
            
            // Duration
            QuickStatBadge(
                icon: "clock.fill",
                label: "Duration",
                value: exercise.duration,
                color: .infoBlue
            )
            
            // Difficulty
            QuickStatBadge(
                icon: "star.fill",
                label: "Difficulty",
                value: String(repeating: "★", count: exercise.difficultyRating),
                color: .warningYellow
            )
        }
    }
    
    // MARK: - Instructions Section
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "list.number")
                    .foregroundColor(.primaryOrange)
                
                Text("How to Perform")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: Spacing.m) {
                        // Step number
                        Text("\(index + 1)")
                            .font(.bodySmall)
                            .fontWeight(.bold)
                            .foregroundColor(.backgroundBlack)
                            .frame(width: 24, height: 24)
                            .background(Color.primaryOrange)
                            .cornerRadius(12)
                        
                        Text(instruction)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
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
    
    // MARK: - Benefits Section
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.successGreen)
                
                Text("Benefits")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(exercise.benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: Spacing.s) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.successGreen)
                            .font(.bodySmall)
                        
                        Text(benefit)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
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
    
    // MARK: - Equipment Section
    private var equipmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundColor(.infoBlue)
                
                Text("Equipment Needed")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            FlowLayout(spacing: Spacing.xs) {
                ForEach(exercise.equipmentNeeded, id: \.self) { equipment in
                    Text(equipment)
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, Spacing.m)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.infoBlue.opacity(0.15))
                        .cornerRadius(CornerRadius.large)
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
    
    // MARK: - Complete Button
    private var completeButton: some View {
        Button(action: {
            if exercise.isCompleted {
                viewModel.resetExercise(exercise)
            } else {
                viewModel.completeExercise(exercise)
            }
        }) {
            HStack(spacing: Spacing.s) {
                Image(systemName: exercise.isCompleted ? "checkmark.circle.fill" : "circle")
                Text(exercise.isCompleted ? "Completed" : "Mark as Complete")
            }
            .font(.bodyLarge)
            .fontWeight(.semibold)
            .foregroundColor(exercise.isCompleted ? .successGreen : .backgroundBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(exercise.isCompleted ? Color.successGreen.opacity(0.2) : Color.primaryOrange)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(exercise.isCompleted ? Color.successGreen : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Quick Stat Badge
struct QuickStatBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: Exercise.sampleLibrary[0],
            viewModel: TrainingPlanViewModel()
        )
    }
}