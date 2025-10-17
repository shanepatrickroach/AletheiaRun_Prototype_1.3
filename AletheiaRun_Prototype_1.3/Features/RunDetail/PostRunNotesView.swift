//
//  PostRunNotesView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


import SwiftUI

// MARK: - Post Run Notes View
/// Displays the post-run survey data and allows users to view/edit their notes
struct PostRunNotesView: View {
    // MARK: - Properties
    let run: Run
    @State private var survey: PostRunSurvey = PostRunSurvey()
    @State private var isEditing = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header with edit button
            HStack {
                Text("Post-Run Survey")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.bodyMedium)
                        .foregroundColor(.primaryOrange)
                }
            }
            
            // Energy Level Section
            energyLevelSection
            
            // Pain Points Section
            painPointsSection
            
            // Perceived Effort Section
            perceivedEffortSection
            
            // Notes Section
            notesSection
            
            // Settings Recommendation
            settingsRecommendationSection
        }
    }
    
    // MARK: - Energy Level Section
    private var energyLevelSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Energy Level")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            HStack(spacing: Spacing.s) {
                ForEach(EnergyLevel.allCases, id: \.self) { level in
                    EnergyButton(
                        level: level,
                        isSelected: survey.energyLevel == level,
                        isEnabled: isEditing,
                        action: { 
                            if isEditing {
                                survey.energyLevel = level
                            }
                        }
                    )
                }
            }
            
            // Selected energy description
            HStack(spacing: Spacing.xs) {
                Text(survey.energyLevel.emoji)
                    .font(.headline)
                
                Text(survey.energyLevel.title)
                    .font(.bodySmall)
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
    
    // MARK: - Pain Points Section
    private var painPointsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Pain Points")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            if survey.painPoints.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.successGreen)
                    
                    Text("No pain reported")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                }
                .padding(Spacing.s)
                .background(Color.successGreen.opacity(0.1))
                .cornerRadius(CornerRadius.small)
            } else {
                // Pain points grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.xs) {
                    ForEach(PainPoint.allCases, id: \.self) { point in
                        RunDetailPainPointButton(
                            point: point,
                            isSelected: survey.painPoints.contains(point),
                            isEnabled: isEditing,
                            action: {
                                if isEditing {
                                    if survey.painPoints.contains(point) {
                                        survey.painPoints.remove(point)
                                    } else {
                                        survey.painPoints.insert(point)
                                    }
                                }
                            }
                        )
                    }
                }
                
                // Pain details text field (if editing and has pain)
                if isEditing && !survey.painPoints.isEmpty {
                    TextField("Additional details about pain...", text: $survey.painPointDetails, axis: .vertical)
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .padding(Spacing.s)
                        .background(Color.backgroundBlack)
                        .cornerRadius(CornerRadius.small)
                        .lineLimit(3...6)
                } else if !survey.painPointDetails.isEmpty {
                    Text(survey.painPointDetails)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .padding(Spacing.s)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.backgroundBlack)
                        .cornerRadius(CornerRadius.small)
                }
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
    
    // MARK: - Perceived Effort Section
    private var perceivedEffortSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Text("Perceived Effort")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(survey.perceivedEffort)/10")
                    .font(.headline)
                    .foregroundColor(.primaryOrange)
            }
            
            // Effort scale
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    Button(action: {
                        if isEditing {
                            survey.perceivedEffort = level
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(level <= survey.perceivedEffort ? Color.primaryOrange : Color.cardBorder)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .disabled(!isEditing)
                }
            }
            .frame(height: 32)
            
            // Scale labels
            HStack {
                Text("Easy")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                Spacer()
                
                Text("Moderate")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                Spacer()
                
                Text("Maximum")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
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
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Additional Notes")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            if isEditing {
                TextField("How did you feel? Any observations?", text: $survey.notes, axis: .vertical)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                    .padding(Spacing.s)
                    .background(Color.backgroundBlack)
                    .cornerRadius(CornerRadius.small)
                    .lineLimit(4...10)
            } else {
                if survey.notes.isEmpty {
                    Text("No additional notes")
                        .font(.bodySmall)
                        .foregroundColor(.textTertiary)
                        .italic()
                } else {
                    Text(survey.notes)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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
    
    // MARK: - Settings Recommendation Section
    private var settingsRecommendationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Would you recommend these settings?")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            HStack(spacing: Spacing.m) {
                // Yes button
                Button(action: { 
                    if isEditing {
                        survey.wouldRecommendSettings = true
                    }
                }) {
                    HStack {
                        Image(systemName: survey.wouldRecommendSettings ? "hand.thumbsup.fill" : "hand.thumbsup")
                        Text("Yes")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(survey.wouldRecommendSettings ? .backgroundBlack : .successGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(survey.wouldRecommendSettings ? Color.successGreen : Color.successGreen.opacity(0.15))
                    .cornerRadius(CornerRadius.small)
                }
                .disabled(!isEditing)
                
                // No button
                Button(action: { 
                    if isEditing {
                        survey.wouldRecommendSettings = false
                    }
                }) {
                    HStack {
                        Image(systemName: !survey.wouldRecommendSettings ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        Text("No")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(!survey.wouldRecommendSettings ? .backgroundBlack : .errorRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(!survey.wouldRecommendSettings ? Color.errorRed : Color.errorRed.opacity(0.15))
                    .cornerRadius(CornerRadius.small)
                }
                .disabled(!isEditing)
            }
            
            Text("This helps us improve recommendations for your next run")
                .font(.caption)
                .foregroundColor(.textTertiary)
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

// MARK: - Energy Button Component
struct EnergyButton: View {
    let level: EnergyLevel
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xxs) {
                Text(level.emoji)
                    .font(.titleMedium)
                
                Text("\(level.rawValue)")
                    .font(.caption)
                    .foregroundColor(isSelected ? .primaryOrange : .textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.primaryOrange.opacity(0.15) : Color.clear)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(isSelected ? Color.primaryOrange : Color.clear, lineWidth: 2)
            )
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Pain Point Button Component
struct RunDetailPainPointButton: View {
    let point: PainPoint
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: point.icon)
                    .font(.bodySmall)
                
                Text(point.rawValue)
                    .font(.bodySmall)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.bodySmall)
                        .foregroundColor(.primaryOrange)
                }
            }
            .foregroundColor(isSelected ? .primaryOrange : .textPrimary)
            .padding(.horizontal, Spacing.s)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.primaryOrange.opacity(0.15) : Color.backgroundBlack)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: 1)
            )
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            PostRunNotesView(run: Run(
                date: Date(),
                mode: .run,
                terrain: .road,
                distance: 5.0,
                duration: 2400,
                metrics: RunMetrics(
                    efficiency: 85,
                    sway: 78,
                    endurance: 82,
                    warmup: 75,
                    impact: 88,
                    braking: 80,
                    variation: 77
                )
            ))
            .padding(Spacing.m)
        }
    }
}
