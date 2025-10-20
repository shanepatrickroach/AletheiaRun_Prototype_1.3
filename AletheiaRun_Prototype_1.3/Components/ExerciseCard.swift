// Core/Components/ExerciseCard.swift

import SwiftUI

/// A card displaying an exercise in a list or grid
struct ExerciseCard: View {
    let exercise: Exercise
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                // Thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.cardBackground)
                    
                    Image(systemName: exercise.thumbnailImage)
                        .font(.system(size: 40))
                        .foregroundColor(.primaryOrange)
                }
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                )
                
                // Exercise Details
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(exercise.name)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: Spacing.xs) {
                        // Category Badge
                        HStack(spacing: 4) {
                            Image(systemName: exercise.category.icon)
                                .font(.system(size: 10))
                            Text(exercise.category.rawValue)
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(categoryColor.opacity(0.2))
                        .cornerRadius(4)
                        
                        // Difficulty Badge
                        Text(exercise.difficulty.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(difficultyColor.opacity(0.2))
                            .cornerRadius(4)
                    }
                    
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.textTertiary)
                        
                        Text(exercise.duration)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(Spacing.s)
            .frame(width: 160)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
    ExerciseCard(exercise: SampleData.exercises[0], onTap: {})
        .padding()
        .background(Color.backgroundBlack)
}