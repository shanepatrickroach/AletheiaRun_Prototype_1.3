//
//  AchievementsTabView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Progress/AchievementsTabView.swift (NEW FILE)

import SwiftUI

struct AchievementsTabView: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    @State private var selectedCategory: AchievementCategory?
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                
                // Overall Progress Card
                OverallProgressCard()
                    .padding(.horizontal, Spacing.l)
                    .padding(.top, Spacing.m)
                
                // Category Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.s) {
                        // All button
                        CategoryFilterButton(
                            title: "All",
                            icon: "square.grid.2x2.fill",
                            isSelected: selectedCategory == nil,
                            count: gamificationManager.totalAchievements
                        ) {
                            selectedCategory = nil
                        }
                        
                        // Category buttons
                        ForEach(AchievementCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category,
                                count: gamificationManager.achievements(for: category).count,
                                color: category.color
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                }
                
                // Achievements Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: Spacing.m),
                    GridItem(.flexible(), spacing: Spacing.m)
                ], spacing: Spacing.m) {
                    ForEach(filteredAchievements) { achievement in
                        Button(action: {
                            // Show achievement detail
                        }) {
                            AchievementCard(achievement: achievement)
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .background(Color.backgroundBlack)
            .padding(.bottom, Spacing.xxxl)
        }
    }
    
    private var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return gamificationManager.achievements(for: category)
                .sorted { achievement1, achievement2 in
                    // Sort: unlocked first, then by tier, then by progress
                    if achievement1.isUnlocked != achievement2.isUnlocked {
                        return achievement1.isUnlocked && !achievement2.isUnlocked
                    }
                    if achievement1.tier.sortOrder != achievement2.tier.sortOrder {
                        return achievement1.tier.sortOrder > achievement2.tier.sortOrder
                    }
                    return achievement1.progressPercentage > achievement2.progressPercentage
                }
        } else {
            return gamificationManager.achievements
                .sorted { achievement1, achievement2 in
                    if achievement1.isUnlocked != achievement2.isUnlocked {
                        return achievement1.isUnlocked && !achievement2.isUnlocked
                    }
                    if achievement1.tier.sortOrder != achievement2.tier.sortOrder {
                        return achievement1.tier.sortOrder > achievement2.tier.sortOrder
                    }
                    return achievement1.progressPercentage > achievement2.progressPercentage
                }
        }
    }
}

// MARK: - Overall Progress Card
struct OverallProgressCard: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(gamificationManager.totalUnlockedAchievements) of \(gamificationManager.totalAchievements) unlocked")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
//                // Circular progress
//                ZStack {
//                    Circle()
//                        .stroke(Color.cardBorder, lineWidth: 6)
//                        .frame(width: 60, height: 60)
//                    
//                    Circle()
//                        .trim(from: 0, to: gamificationManager.achievementProgress / 100)
//                        .stroke(Color.primaryOrange, style: StrokeStyle(lineWidth: 6, lineCap: .round))
//                        .frame(width: 60, height: 60)
//                        .rotationEffect(.degrees(-90))
//                    
//                    Text("\(Int(gamificationManager.achievementProgress))%")
//                        .font(.bodySmall)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.textPrimary)
//                }
            }
            
            // Tier Breakdown
            HStack(spacing: Spacing.m) {
                TierBadge(tier: .bronze, count: gamificationManager.bronzeCount)
                TierBadge(tier: .silver, count: gamificationManager.silverCount)
                TierBadge(tier: .gold, count: gamificationManager.goldCount)
                TierBadge(tier: .platinum, count: gamificationManager.platinumCount)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Tier Badge
struct TierBadge: View {
    let tier: AchievementTier
    let count: Int
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(tier.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text("\(count)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(tier.color)
            }
            
            Text(tier.rawValue)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Category Filter Button
struct CategoryFilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let count: Int
    var color: Color = .primaryOrange
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.bodySmall)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                Text("(\(count))")
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.s)
            .background(
                isSelected 
                    ? color.opacity(0.2)
                    : Color.cardBackground
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? color.opacity(0.5) : Color.cardBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    AchievementsTabView()
        .environmentObject(GamificationManager())
}
