//
//  ChallengeCard.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Core/Components/ChallengeCard.swift (NEW FILE)

import SwiftUI

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(challenge.type.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: challenge.icon)
                        .font(.system(size: 24))
                        .foregroundColor(challenge.type.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.name)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(challenge.type.rawValue)
                        .font(.caption)
                        .foregroundColor(challenge.type.color)
                }
                
                Spacer()
                
                // Status badge
                StatusBadge(challenge: challenge)
            }
            
            // Description
            Text(challenge.description)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            // Progress
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progress))/\(Int(challenge.requirement))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.cardBorder)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [challenge.type.color, challenge.type.color.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (challenge.progressPercentage / 100), height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            // Footer
            HStack {
                // Time remaining
                HStack(spacing: Spacing.xs) {
                    Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(challenge.isCompleted ? .successGreen : .textTertiary)
                    
                    Text(challenge.statusText)
                        .font(.caption)
                        .foregroundColor(challenge.isCompleted ? .successGreen : .textSecondary)
                }
                
                Spacer()
                
                // Reward
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.warningYellow)
                    
                    Text(challenge.reward.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(Spacing.m)
        .background(
            challenge.isCompleted 
                ? challenge.type.color.opacity(0.05)
                : Color.cardBackground
        )
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(
                    challenge.isCompleted 
                        ? challenge.type.color.opacity(0.3)
                        : Color.cardBorder,
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let challenge: Challenge
    
    var body: some View {
        HStack(spacing: 4) {
            if challenge.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                Text("Done")
                    .font(.caption)
                    .fontWeight(.semibold)
            } else if challenge.isExpired {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                Text("Expired")
                    .font(.caption)
                          fontWeight(.semibold)
                                    } else {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 10, weight: .bold))
                                        Text("Active")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .foregroundColor(badgeTextColor)
                                .padding(.horizontal, Spacing.s)
                                .padding(.vertical, 4)
                                .background(badgeBackgroundColor)
                                .cornerRadius(CornerRadius.small)
                            }
                            
                            private var badgeTextColor: Color {
                                if challenge.isCompleted { return .successGreen }
                                if challenge.isExpired { return .errorRed }
                                return .primaryOrange
                            }
                            
                            private var badgeBackgroundColor: Color {
                                if challenge.isCompleted { return Color.successGreen.opacity(0.2) }
                                if challenge.isExpired { return Color.errorRed.opacity(0.2) }
                                return Color.primaryOrange.opacity(0.2)
                            }
                        }

                #Preview {
                            VStack(spacing: Spacing.m) {
                                ChallengeCard(challenge: Challenge.sampleChallenges[0])
                                ChallengeCard(challenge: Challenge.sampleChallenges[4])
                            }
                            .padding()
                            .background(Color.backgroundBlack)
                        }
