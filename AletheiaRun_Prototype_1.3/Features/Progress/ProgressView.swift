// Features/Progress/ProgressView.swift (COMPLETE VERSION)

import SwiftUI

struct ProgressView: View {
    @StateObject private var gamificationManager = GamificationManager()
    @State private var selectedTab: ProgressTab = .achievements

    enum ProgressTab: String, CaseIterable {
        case achievements = "Achievements"
        case challenges = "Challenges"
        case stats = "Stats"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()

                VStack(spacing: 0) {

                    // Weekly Streak Banner
                    WeeklyStreakBanner()
                        .padding(.horizontal, Spacing.m)
                        .padding(.top, Spacing.s)
                        .padding(.bottom, Spacing.m)
                    
                    // Segmented Control
                    SegmentedControl(selection: $selectedTab)
                        .padding(.horizontal, Spacing.l)
                        .padding(.vertical, Spacing.m)

                    // Content
                    TabView(selection: $selectedTab) {
                        AchievementsTabView()
                            .tag(ProgressTab.achievements)

                        ChallengesTabView()
                            .tag(ProgressTab.challenges)

                        StatsTabView()
                            .tag(ProgressTab.stats)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
              
            }
            .environmentObject(gamificationManager)
        }
        .sheet(isPresented: $gamificationManager.showAchievementUnlock) {
            if let achievement = gamificationManager.recentlyUnlockedAchievement
            {
                AchievementUnlockView(achievement: achievement)
            }
        }
    }
}
// MARK: - Weekly Streak Banner
struct WeeklyStreakBanner: View {
    // In a real app, this would come from your data manager
    @State private var currentWeekRuns = 3 // Runs completed this week
    @State private var weeklyStreak = 8 // Consecutive weeks with 3+ runs
    
    // Animation state
    @State private var isAnimating = false
    
    private let targetRuns = 3 // Target runs per week
    private var progress: Double {
        min(Double(currentWeekRuns) / Double(targetRuns), 1.0)
    }
    
    private var isStreakActive: Bool {
        currentWeekRuns >= targetRuns
    }
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Flame Icon with animated glow and grow effect
            ZStack {
                // Outer glow layer (largest)
                if weeklyStreak > 0 {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.primaryOrange.opacity(isAnimating ? 0.4 : 0.2),
                                    Color.primaryOrange.opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 35
                            )
                        )
                        .frame(
                            width: isAnimating ? 70 : 60,
                            height: isAnimating ? 70 : 60
                        )
                        .blur(radius: 10)
                }
                
                // Inner glow layer (medium)
                if weeklyStreak > 0 {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.primaryOrange.opacity(isAnimating ? 0.5 : 0.3),
                                    Color.primaryOrange.opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 25
                            )
                        )
                        .frame(
                            width: isAnimating ? 50 : 45,
                            height: isAnimating ? 50 : 45
                        )
                        .blur(radius: 6)
                }
                
                // Flame icon with scale animation
                Image(systemName: weeklyStreak > 0 ? "flame.fill" : "flame")
                    .font(.system(size: 32))
                    .foregroundColor(weeklyStreak > 0 ? .primaryOrange : .textTertiary)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .shadow(
                        color: weeklyStreak > 0 ? Color.primaryOrange.opacity(0.5) : .clear,
                        radius: isAnimating ? 8 : 4,
                        x: 0,
                        y: 0
                    )
            }
            .frame(width: 56, height: 56)
            
            // Streak Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                if weeklyStreak > 0 {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(weeklyStreak)")
                            .font(.titleLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryOrange)
                        
                        Text("Week Streak")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Text("Running \(targetRuns)+ times per week")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                } else {
                    Text("Start Your Streak")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Run \(targetRuns) times this week")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            // This Week Progress
            VStack(spacing: Spacing.xs) {
                // Weekly run indicators
                HStack(spacing: 6) {
                    ForEach(0..<targetRuns, id: \.self) { index in
                        Circle()
                            .fill(index < currentWeekRuns ? Color.primaryOrange : Color.cardBorder)
                            .frame(width: 12, height: 12)
                            .scaleEffect(index < currentWeekRuns && isAnimating ? 1.15 : 1.0)
                    }
                }
                
                Text("\(currentWeekRuns)/\(targetRuns)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isStreakActive ? .primaryOrange : .textSecondary)
            }
        }
        .padding(Spacing.m)
        .background(
            ZStack {
                // Base background
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.cardBackground)
                
                // Gradient overlay when streak is active
                if weeklyStreak > 0 {
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.primaryOrange.opacity(isAnimating ? 0.15 : 0.1),
                                    Color.primaryOrange.opacity(0.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(
                    weeklyStreak > 0 ?
                        Color.primaryOrange.opacity(isAnimating ? 0.4 : 0.3) :
                        Color.cardBorder,
                    lineWidth: 1
                )
        )
        .onAppear {
            if weeklyStreak > 0 {
                // Start the breathing animation
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
        }
    }
}

// MARK: - Segmented Control
struct SegmentedControl: View {
    @Binding var selection: ProgressView.ProgressTab
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProgressView.ProgressTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                    {
                        selection = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.bodyMedium)
                        .fontWeight(selection == tab ? .semibold : .regular)
                        .foregroundColor(
                            selection == tab ? .textPrimary : .textSecondary
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        .background(
                            ZStack {
                                if selection == tab {
                                    RoundedRectangle(
                                        cornerRadius: CornerRadius.small
                                    )
                                    .fill(Color.primaryOrange.opacity(0.2))
                                    .matchedGeometryEffect(
                                        id: "segment", in: animation)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

#Preview {
    ProgressView()
}
