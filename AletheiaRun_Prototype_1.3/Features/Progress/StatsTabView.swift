//
//  StatsTabView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Progress/StatsTabView.swift (NEW FILE)

import SwiftUI

struct StatsTabView: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                
                // Overall Stats
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Overall Statistics")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.m) {
                        StatRow(
                            icon: "trophy.fill",
                            label: "Total Achievements",
                            value: "\(gamificationManager.totalUnlockedAchievements)/\(gamificationManager.totalAchievements)",
                            color: .primaryOrange
                        )
                        
                        StatRow(
                            icon: "checkmark.circle.fill",
                            label: "Challenges Completed",
                            value: "\(gamificationManager.totalCompletedChallenges)",
                            color: .successGreen
                        )
                        
                        StatRow(
                            icon: "flame.fill",
                            label: "Active Challenges",
                            value: "\(gamificationManager.totalActiveChallenges)",
                            color: .warningYellow
                        )
                        
                        StatRow(
                            icon: "percent",
                            label: "Completion Rate",
                            value: "\(Int(gamificationManager.achievementProgress))%",
                            color: .infoBlue
                        )
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.large)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.m)
                
                // Achievement Breakdown by Category
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Achievement Categories")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.m) {
                        ForEach(AchievementCategory.allCases, id: \.self) { category in
                            CategoryProgressRow(category: category)
                        }
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.large)
                }
                .padding(.horizontal, Spacing.l)
                
                // Tier Distribution
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Achievements by Tier")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.m) {
                        TierProgressRow(
                            tier: .bronze,
                            count: gamificationManager.bronzeCount,
                            total: gamificationManager.achievements(for: .bronze).count
                        )
                        
                        TierProgressRow(
                            tier: .silver,
                            count: gamificationManager.silverCount,
                            total: gamificationManager.achievements(for: .silver).count
                        )
                        
                        TierProgressRow(
                            tier: .gold,
                            count: gamificationManager.goldCount,
                            total: gamificationManager.achievements(for: .gold).count
                        )
                        
                        TierProgressRow(
                            tier: .platinum,
                            count: gamificationManager.platinumCount,
                            total: gamificationManager.achievements(for: .platinum).count
                        )
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.large)
                }
                .padding(.horizontal, Spacing.l)
                
                // Recent Unlocks
                if !gamificationManager.unlockedAchievements.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text("Recently Unlocked")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        VStack(spacing: Spacing.s) {
                            ForEach(gamificationManager.unlockedAchievements.prefix(5)) { achievement in
                                RecentUnlockRow(achievement: achievement)
                            }
                        }
                        .padding(Spacing.m)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.large)
                    }
                    .padding(.horizontal, Spacing.l)
                }
            }
            .padding(.bottom, Spacing.xxxl)
        }
    }
}

// MARK: - Stat Row
struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Category Progress Row
struct CategoryProgressRow: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    let category: AchievementCategory
    
    private var unlocked: Int {
        gamificationManager.achievements(for: category).filter { $0.isUnlocked }.count
    }
    
    private var total: Int {
        gamificationManager.achievements(for: category).count
    }
    
    private var percentage: Double {
        total > 0 ? (Double(unlocked) / Double(total)) * 100 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 16))
                    .foregroundColor(category.color)
                    .frame(width: 24)
                
                Text(category.rawValue)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(unlocked)/\(total)")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.color)
                        .frame(width: geometry.size.width * (percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Tier Progress Row
struct TierProgressRow: View {
    let tier: AchievementTier
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? (Double(count) / Double(total)) * 100 : 0
    }
    
    var body: some View {
        HStack {
            Text(tier.rawValue)
                .font(.bodyMedium)
                .foregroundColor(tier.color)
                .frame(width: 80, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(tier.color)
                        .frame(width: geometry.size.width * (percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
            
            Text("\(count)/\(total)")
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)
                .frame(width: 50, alignment: .trailing)
        }
    }
}

// MARK: - Recent Unlock Row
struct RecentUnlockRow: View {
    let achievement: Achievement
    
    private var timeAgo: String {
        guard let date = achievement.unlockedDate else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(achievement.tier.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 18))
                    .foregroundColor(achievement.tier.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Text(timeAgo)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text(achievement.tier.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(achievement.tier.color)
                .padding(.horizontal, Spacing.s)
                .padding(.vertical, 4)
                .background(achievement.tier.color.opacity(0.2))
                .cornerRadius(CornerRadius.small)
        }
    }
}

#Preview {
    StatsTabView()
        .environmentObject(GamificationManager())
}