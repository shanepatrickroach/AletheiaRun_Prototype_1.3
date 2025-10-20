// Features/Exercises/ExerciseDetailSheet.swift

import SwiftUI

/// Detailed view of an exercise with video placeholder and form cues
struct ExerciseDetailSheet: View {
    let exercise: Exercise
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Video Placeholder
                    videoPlaceholder
                    
                    // Exercise Info
                    exerciseInfoSection
                    
                    // Form Cues
                    formCuesSection
                    
                    // Benefits
                    benefitsSection
                }
                .padding(.bottom, 100)
            }
            .background(Color.backgroundBlack)
            .navigationTitle(exercise.name)
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
    }
    
    // MARK: - Video Placeholder
    private var videoPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(Color.cardBackground)
                .frame(height: 220)
            
            VStack(spacing: Spacing.m) {
                Image(systemName: exercise.thumbnailImage)
                    .font(.system(size: 60))
                    .foregroundColor(.primaryOrange.opacity(0.5))
                
                Text("Video Coming Soon")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                
                // Play Button Placeholder
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, Spacing.m)
    }
    
    // MARK: - Exercise Info Section
    private var exerciseInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Category and Difficulty Badges
            HStack(spacing: Spacing.s) {
                // Category
                HStack(spacing: Spacing.xs) {
                    Image(systemName: exercise.category.icon)
                    Text(exercise.category.rawValue)
                }
                .font(.bodySmall)
                .foregroundColor(categoryColor)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.s)
                .background(categoryColor.opacity(0.2))
                .cornerRadius(CornerRadius.small)
                
                // Difficulty
                Text(exercise.difficulty.rawValue)
                    .font(.bodySmall)
                    .foregroundColor(difficultyColor)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.s)
                    .background(difficultyColor.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
                
                Spacer()
            }
            .padding(.horizontal, Spacing.m)
            
            // Target Metric
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Targets")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.primaryOrange)
                    
                    Text(exercise.targetMetric)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
            }
            .padding(.horizontal, Spacing.m)
            
            // Duration
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Duration")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.primaryOrange)
                    
                    Text(exercise.duration)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
            }
            .padding(.horizontal, Spacing.m)
            
            // Description
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("About")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Text(exercise.description)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Spacing.m)
        }
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, Spacing.m)
    }
    
    // MARK: - Form Cues Section
    private var formCuesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Form Cues")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.m)
            
            VStack(alignment: .leading, spacing: Spacing.m) {
                ForEach(Array(exercise.formCues.enumerated()), id: \.offset) { index, cue in
                    HStack(alignment: .top, spacing: Spacing.m) {
                        // Step Number
                        ZStack {
                            Circle()
                                .fill(Color.primaryOrange.opacity(0.2))
                                .frame(width: 28, height: 28)
                            
                            Text("\(index + 1)")
                                .font(.bodySmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryOrange)
                        }
                        
                        // Cue Text
                        Text(cue)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    
                    if index < exercise.formCues.count - 1 {
                        Divider()
                            .background(Color.cardBorder)
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
            .padding(.horizontal, Spacing.m)
        }
    }
    
    // MARK: - Benefits Section
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Benefits")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.m)
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(exercise.benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: Spacing.m) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.successGreen)
                        
                        Text(benefit)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
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
            .padding(.horizontal, Spacing.m)
        }
    }
    
    // MARK: - Helper Properties
    private var categoryColor: Color {
        switch exercise.category.color {
        case "errorRed": return .errorRed
        case "infoBlue": return .infoBlue
        case "successGreen": return .successGreen
        case "warningYellow": return .warningYellow
        case "primaryOrange": return .primaryOrange
        default: return .primaryOrange
        }
    }
    
    private var difficultyColor: Color {
        switch exercise.difficulty.color {
        case "successGreen": return .successGreen
        case "warningYellow": return .warningYellow
        case "errorRed": return .errorRed
        default: return .successGreen
        }
    }
}

#Preview {
    ExerciseDetailSheet(exercise: SampleData.exercises[0])
}