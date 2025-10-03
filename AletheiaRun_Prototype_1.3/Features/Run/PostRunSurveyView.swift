//
//  PostRunSurveyView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Features/Run/PostRunSurveyView.swift

import SwiftUI

struct PostRunSurveyView: View {
    @ObservedObject var runSession: RunSessionManager
    
    @State private var selectedPainPoints: Set<PainPoint> = []
    @State private var painPointDetails = ""
    @State private var energyLevel: EnergyLevel = .moderate
    @State private var perceivedEffort = 5
    @State private var notes = ""
    @State private var showingCompletion = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // MARK: - Header
                    header
                    
                    // MARK: - Run Summary
                    runSummary
                    
                    // MARK: - Pain Points
                    painPointsSection
                    
                    // MARK: - Energy Level
                    energyLevelSection
                    
                    // MARK: - Perceived Effort
                    perceivedEffortSection
                    
                    // MARK: - Notes
                    notesSection
                    
                    // MARK: - Submit Button
                    PrimaryButton(
                        title: "Complete Session"
                        )
                    {
                        submitSurvey()
                    }
                    .padding(.bottom, Spacing.xl)
                }
                .padding(Spacing.m)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Session Saved!", isPresented: $showingCompletion) {
            Button("Done") {
                // Navigate back to home
                dismiss()
            }
        } message: {
            Text("Your run has been saved and is ready for analysis.")
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.successGreen)
            
            Text("Great Work!")
                .font(Font.titleLarge)
                .foregroundColor(.textPrimary)
            
            Text("Help us understand your run better")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, Spacing.xl)
    }
    
    // MARK: - Run Summary
    private var runSummary: some View {
        VStack(spacing: Spacing.m) {
            Text("Session Summary")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.m) {
                SummaryMetric(
                    icon: "clock.fill",
                    value: runSession.formattedDuration,
                    label: "Duration"
                )
                
                SummaryMetric(
                    icon: "road.lanes",
                    value: String(format: "%.2f mi", runSession.distance),
                    label: "Distance"
                )
                
                SummaryMetric(
                    icon: "speedometer",
                    value: runSession.formattedPace,
                    label: "Avg Pace"
                )
            }
            
            HStack(spacing: Spacing.m) {
                SummaryMetric(
                    icon: "chart.line.uptrend.xyaxis",
                    value: "\(runSession.averageEfficiency)",
                    label: "Efficiency"
                )
                
                SummaryMetric(
                    icon: runSession.configuration?.mode.icon ?? "figure.run",
                    value: runSession.configuration?.mode.rawValue ?? "Run",
                    label: "Type"
                )
                
                SummaryMetric(
                    icon: runSession.configuration?.terrain.icon ?? "road.lanes",
                    value: runSession.configuration?.terrain.rawValue ?? "Road",
                    label: "Terrain"
                )
            }
        }
    }
    
    // MARK: - Pain Points Section
    private var painPointsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Any Pain or Discomfort?")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
            
            Text("Select all areas where you felt pain")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.s) {
                ForEach(PainPoint.allCases, id: \.self) { painPoint in
                    PainPointButton(
                        painPoint: painPoint,
                        isSelected: selectedPainPoints.contains(painPoint)
                    ) {
                        if selectedPainPoints.contains(painPoint) {
                            selectedPainPoints.remove(painPoint)
                        } else {
                            selectedPainPoints.insert(painPoint)
                        }
                    }
                }
            }
            
            // Pain details text field
            if !selectedPainPoints.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Additional Details (Optional)")
                        .font(Font.caption)
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $painPointDetails)
                        .font(Font.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .frame(height: 80)
                        .padding(Spacing.s)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.small)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                }
                .transition(.opacity)
            }
        }
    }
    
    // MARK: - Energy Level Section
    private var energyLevelSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Energy Level")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
            
            Text("How did you feel during this run?")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: Spacing.s) {
                ForEach(EnergyLevel.allCases, id: \.self) { level in
                    EnergyLevelButton(
                        level: level,
                        isSelected: energyLevel == level
                    ) {
                        energyLevel = level
                    }
                }
            }
        }
    }
    
    // MARK: - Perceived Effort Section
    private var perceivedEffortSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Perceived Effort")
                    .font(Font.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(perceivedEffort)/10")
                    .font(Font.titleMedium)
                    .foregroundColor(.primaryOrange)
            }
            
            Text("Rate how hard this run felt (1 = very easy, 10 = maximum effort)")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: Spacing.s) {
                // Slider
                Slider(value: Binding(
                    get: { Double(perceivedEffort) },
                    set: { perceivedEffort = Int($0) }
                ), in: 1...10, step: 1)
                    .tint(.primaryOrange)
                
                // Labels
                HStack {
                    Text("Easy")
                        .font(Font.caption)
                        .foregroundColor(.successGreen)
                    
                    Spacer()
                    
                    Text("Moderate")
                        .font(Font.caption)
                        .foregroundColor(.warningYellow)
                    
                    Spacer()
                    
                    Text("Hard")
                        .font(Font.caption)
                        .foregroundColor(.errorRed)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Additional Notes")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
            
            Text("Any other insights about this run? (Optional)")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)
            
            TextEditor(text: $notes)
                .font(Font.bodyMedium)
                .foregroundColor(.textPrimary)
                .frame(height: 120)
                .padding(Spacing.s)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        }
    }
    
    // MARK: - Submit Survey
    private func submitSurvey() {
        let survey = PostRunSurvey(
            painPoints: selectedPainPoints,
            painPointDetails: painPointDetails,
            energyLevel: energyLevel,
            perceivedEffort: perceivedEffort,
            notes: notes,
            wouldRecommendSettings: true
        )
        
        runSession.completeSurvey(survey)
        showingCompletion = true
    }
}

// MARK: - Summary Metric
struct SummaryMetric: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)
            
            Text(value)
                .font(Font.bodyLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(label)
                .font(Font.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Pain Point Button
struct PainPointButton: View {
    let painPoint: PainPoint
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: painPoint.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                
                Text(painPoint.rawValue)
                    .font(Font.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(isSelected ? Color.primaryOrange.opacity(0.2) : Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Energy Level Button
struct EnergyLevelButton: View {
    let level: EnergyLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Text(level.emoji)
                    .font(.system(size: 32))
                
                Text(level.title)
                    .font(Font.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(isSelected ? Color.primaryOrange.opacity(0.2) : Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        PostRunSurveyView(runSession: RunSessionManager())
    }
}
