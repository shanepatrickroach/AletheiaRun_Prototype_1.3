//
//  AchievementDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Gamification/AchievementDetailView.swift (NEW FILE)

import SwiftUI

struct AchievementDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var gamificationManager: GamificationManager
    
    let achievement: Achievement
    
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Achievement Hero Section
                        AchievementHeroSection(achievement: achievement)
                            .padding(.top, Spacing.l)
                        
                        // Progress Section
                        if !achievement.isUnlocked {
                            ProgressSection(achievement: achievement)
                                .padding(.horizontal, Spacing.l)
                        }
                        
                        // Details Section
                        DetailsSection(achievement: achievement)
                            .padding(.horizontal, Spacing.l)
                        
                        // Related Achievements
                        RelatedAchievementsSection(achievement: achievement)
                            .padding(.horizontal, Spacing.l)
                        
                        // Tips Section
                        if !achievement.isUnlocked {
                            TipsSection(achievement: achievement)
                                .padding(.horizontal, Spacing.l)
                        }
                    }
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
                
                if achievement.isUnlocked {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showShareSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.primaryOrange)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(achievement: achievement)
        }
    }
}

// MARK: - Achievement Hero Section
struct AchievementHeroSection: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: Spacing.l) {
            // Achievement Icon with Glow
            ZStack {
                // Outer glow
                if achievement.isUnlocked {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    achievement.tier.color.opacity(0.3),
                                    achievement.tier.color.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 60,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                }
                
                // Icon background
                Circle()
                    .fill(achievement.isUnlocked ? achievement.tier.color.opacity(0.2) : Color.cardBackground)
                    .frame(width: 120, height: 120)
                
                // Icon
                Image(systemName: achievement.icon)
                    .font(.system(size: 60))
                    .foregroundColor(achievement.isUnlocked ? achievement.tier.color : .textTertiary)
                
                // Lock overlay
                if !achievement.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.textTertiary)
                        .offset(x: 35, y: -35)
                }
                
                // Checkmark for unlocked
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.successGreen)
                        .background(
                            Circle()
                                .fill(Color.backgroundBlack)
                                .frame(width: 28, height: 28)
                        )
                        .offset(x: 40, y: -40)
                }
            }
            
            // Achievement Name & Category
            VStack(spacing: Spacing.s) {
                // Category Badge
                HStack(spacing: Spacing.xs) {
                    Image(systemName: achievement.category.icon)
                        .font(.system(size: 12))
                    
                    Text(achievement.category.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(achievement.category.color)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, 6)
                .background(achievement.category.color.opacity(0.2))
                .cornerRadius(CornerRadius.large)
                
                // Achievement Name
                Text(achievement.name)
                    .font(.titleLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                // Description
                Text(achievement.description)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                
                // Tier Badge
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "seal.fill")
                        .font(.system(size: 16))
                    
                    Text(achievement.tier.rawValue)
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                }
                .foregroundColor(achievement.tier.color)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.s)
                .background(achievement.tier.color.opacity(0.2))
                .cornerRadius(CornerRadius.medium)
            }
            
            // Unlocked Date
            if achievement.isUnlocked, let date = achievement.unlockedDate {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.successGreen)
                    
                    Text("Unlocked \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Progress Section
struct ProgressSection: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Your Progress")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                // Progress Stats
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("\(Int(achievement.progress))")
                            .font(.titleMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryOrange)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Required")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("\(Int(achievement.requirement))")
                            .font(.titleMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                    }
                }
                
                // Progress Bar
                VStack(spacing: Spacing.xs) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.cardBorder)
                                .frame(height: 12)
                            
                            // Progress
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            achievement.category.color,
                                            achievement.category.color.opacity(0.7)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width * (achievement.progressPercentage / 100),
                                    height: 12
                                )
                        }
                    }
                    .frame(height: 12)
                    
                    // Percentage
                    HStack {
                        Text("\(Int(achievement.progressPercentage))% Complete")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        let remaining = achievement.requirement - achievement.progress
                        Text("\(Int(remaining)) to go")
                            .font(.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryOrange)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
}

// MARK: - Details Section
struct DetailsSection: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                DetailRow(
                    icon: "folder.fill",
                    label: "Category",
                    value: achievement.category.rawValue,
                    color: achievement.category.color
                )
                
                DetailRow(
                    icon: "seal.fill",
                    label: "Tier",
                    value: achievement.tier.rawValue,
                    color: achievement.tier.color
                )
                
                DetailRow(
                    icon: "flag.fill",
                    label: "Requirement",
                    value: "\(Int(achievement.requirement))",
                    color: .infoBlue
                )
                
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    DetailRow(
                        icon: "calendar.badge.checkmark",
                        label: "Unlocked",
                        value: date.formatted(date: .abbreviated, time: .shortened),
                        color: .successGreen
                    )
                }
                
                DetailRow(
                    icon: achievement.isUnlocked ? "checkmark.circle.fill" : "lock.fill",
                    label: "Status",
                    value: achievement.isUnlocked ? "Unlocked" : "Locked",
                    color: achievement.isUnlocked ? .successGreen : .textTertiary
                )
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Related Achievements Section
struct RelatedAchievementsSection: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    let achievement: Achievement
    
    private var relatedAchievements: [Achievement] {
        gamificationManager.achievements(for: achievement.category)
            .filter { $0.id != achievement.id }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        if !relatedAchievements.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.m) {
                Text("Related Achievements")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: Spacing.s) {
                    ForEach(relatedAchievements) { relatedAchievement in
                        RelatedAchievementRow(achievement: relatedAchievement)
                    }
                }
            }
        }
    }
}

struct RelatedAchievementRow: View {
    let achievement: Achievement
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            HStack(spacing: Spacing.m) {
                // Icon
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.tier.color.opacity(0.2) : Color.cardBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 24))
                        .foregroundColor(achievement.isUnlocked ? achievement.tier.color : .textTertiary)
                    
                    if !achievement.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                            .offset(x: 15, y: -15)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.name)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    if achievement.isUnlocked {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.successGreen)
                            
                            Text("Unlocked")
                                .font(.caption)
                                .foregroundColor(.successGreen)
                        }
                    } else {
                        Text("\(Int(achievement.progressPercentage))% complete")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Tier badge
                Text(achievement.tier.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.tier.color)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(achievement.tier.color.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
        .sheet(isPresented: $showDetail) {
            AchievementDetailView(achievement: achievement)
                .environmentObject(GamificationManager())
        }
    }
}

// MARK: - Tips Section
struct TipsSection: View {
    let achievement: Achievement
    
    private var tips: [String] {
        getTips(for: achievement)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.warningYellow)
                
                Text("Tips to Unlock")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.s) {
                ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                    AchievementTipRow(number: index + 1, tip: tip)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
    
    private func getTips(for achievement: Achievement) -> [String] {
        switch achievement.category {
        case .distance:
            return [
                "Run consistently to accumulate miles",
                "Mix shorter and longer runs throughout the week",
                "Track all your outdoor and treadmill runs"
            ]
        case .performance:
            return [
                "Focus on proper running form",
                "Use Force Portrait analysis to identify areas for improvement",
                "Gradually work on technique adjustments"
            ]
        case .portrait:
            return [
                "Record runs regularly to generate Force Portraits",
                "Ensure sensor is properly positioned",
                "Run on varied terrain for comprehensive data"
            ]
        case .consistency:
            return [
                "Set a daily running schedule and stick to it",
                "Even short runs count toward your streak",
                "Enable reminders to maintain consistency"
            ]
        case .injuryPrevention:
            return [
                "Pay attention to hip balance metrics",
                "Address asymmetries shown in Force Portrait",
                "Follow recommended exercises from Pocket Coach"
            ]
        case .pocketCoach:
            return [
                "Check Pocket Coach recommendations after each run",
                "Complete suggested exercises regularly",
                "Track your progress on exercise completion"
            ]
        }
    }
}

struct AchievementTipRow: View {
    let number: Int
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 28, height: 28)
                
                Text("\(number)")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryOrange)
            }
            
            Text(tip)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    let achievement: Achievement
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    Spacer()
                    
                    // Share Preview
                    RunDetailSharePreviewCard(achievement: achievement)
                        .padding(.horizontal, Spacing.l)
                    
                    Spacer()
                    
                    // Share Options
                    VStack(spacing: Spacing.m) {
                        ShareButton(
                            icon: "square.and.arrow.up",
                            title: "Share Image",
                            subtitle: "Save or share as image"
                        ) {
                            // TODO: Generate and share image
                            dismiss()
                        }
                        
                        ShareButton(
                            icon: "link",
                            title: "Copy Link",
                            subtitle: "Share achievement link"
                        ) {
                            // TODO: Copy link to clipboard
                            UIPasteboard.general.string = "https://aletheia.app/achievement/\(achievement.id)"
                            dismiss()
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.bottom, Spacing.xl)
                }
            }
            .navigationTitle("Share Achievement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
}

struct RunDetailSharePreviewCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: Spacing.l) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.tier.color.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 50))
                    .foregroundColor(achievement.tier.color)
            }
            
            // Text
            VStack(spacing: Spacing.s) {
                Text("Achievement Unlocked!")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(achievement.name)
                    .font(.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "seal.fill")
                        .font(.system(size: 12))
                    
                    Text(achievement.tier.rawValue)
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                }
                .foregroundColor(achievement.tier.color)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, 6)
                .background(achievement.tier.color.opacity(0.2))
                .cornerRadius(CornerRadius.small)
            }
            
            // App branding
            Text("Aletheia Running")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.xl)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.xxLarge)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.xxLarge)
                .stroke(achievement.tier.color.opacity(0.3), lineWidth: 2)
        )
    }
}

struct ShareButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.primaryOrange)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
}

#Preview {
    AchievementDetailView(achievement: Achievement.sampleAchievements[0])
        .environmentObject(GamificationManager())
}
