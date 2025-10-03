//
//  RunningGoalsStep.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct RunningGoalsStep: View {
    @Binding var profile: UserProfile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Header
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Running Goals")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Select all that apply")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.xl)
                
                // Goals
                VStack(spacing: Spacing.m) {
                    ForEach(RunGoal.allCases, id: \.self) { goal in
                        GoalCard(
                            goal: goal,
                            isSelected: profile.runningGoals.contains(goal)
                        ) {
                            if profile.runningGoals.contains(goal) {
                                profile.runningGoals.remove(goal)
                            } else {
                                profile.runningGoals.insert(goal)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, Spacing.xxxl)
        }
    }
}

struct GoalCard: View {
    let goal: RunGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryOrange.opacity(0.2) : Color.cardBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: goal.icon)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.rawValue)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text(goal.description)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
            }
            .padding(Spacing.m)
            .background(isSelected ? Color.primaryOrange.opacity(0.05) : Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    RunningGoalsStep(profile: .constant(UserProfile()))
}
