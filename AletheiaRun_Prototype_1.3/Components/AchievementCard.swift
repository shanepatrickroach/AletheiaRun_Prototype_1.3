//
//  AchievementCard.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Core/Components/AchievementCard.swift (NEW FILE)

import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement
    
    @State private var showDetail = false
    
    var body: some View {
        
        
        Button(
            action:
                {showDetail = true}
        ){
            VStack(spacing: Spacing.m) {
                // Icon with tier background
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.tier.color.opacity(0.2) : Color.cardBackground)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 32))
                        .foregroundColor(achievement.isUnlocked ? achievement.tier.color : .textTertiary)
                    
                    // Lock overlay for locked achievements
                    if !achievement.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.textTertiary)
                            .offset(x: 22, y: -22)
                    }
                }
                
                // Achievement name
                Text(achievement.name)
                    .font(.bodyMedium)
                    .foregroundColor(achievement.isUnlocked ? .textPrimary : .textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Progress or unlocked status
                if achievement.isUnlocked {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.successGreen)
                        
                        Text("Unlocked")
                            .font(.caption)
                            .foregroundColor(.successGreen)
                    }
                } else {
                    VStack(spacing: 4) {
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.cardBorder)
                                    .frame(height: 4)
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(achievement.category.color)
                                    .frame(width: geometry.size.width * (achievement.progressPercentage / 100), height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        // Progress text
                        Text("\(Int(achievement.progress))/\(Int(achievement.requirement))")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Tier badge
                Text(achievement.tier.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.tier.color)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(achievement.tier.color.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
            }
            .padding(Spacing.m)
            .frame(maxWidth: .infinity)
            .background(
                achievement.isUnlocked
                    ? achievement.tier.color.opacity(0.05)
                    : Color.cardBackground
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        achievement.isUnlocked
                            ? achievement.tier.color.opacity(0.3)
                            : Color.cardBorder,
                        lineWidth: 1
                    )
            )
            
            
        }
        .sheet(isPresented: $showDetail) {
            AchievementDetailView(achievement: achievement)
                .environmentObject(GamificationManager())
        }
        
    }
}

#Preview {
    HStack(spacing: Spacing.m) {
        AchievementCard(achievement: Achievement.sampleAchievements[0])
        AchievementCard(achievement: Achievement.sampleAchievements[3])
    }
    .padding()
    .background(Color.backgroundBlack)
}
