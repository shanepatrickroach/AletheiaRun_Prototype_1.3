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
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .environmentObject(gamificationManager)
        }
        .sheet(isPresented: $gamificationManager.showAchievementUnlock) {
            if let achievement = gamificationManager.recentlyUnlockedAchievement {
                AchievementUnlockView(achievement: achievement)
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
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.bodyMedium)
                        .fontWeight(selection == tab ? .semibold : .regular)
                        .foregroundColor(selection == tab ? .textPrimary : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        .background(
                            ZStack {
                                if selection == tab {
                                    RoundedRectangle(cornerRadius: CornerRadius.small)
                                        .fill(Color.primaryOrange.opacity(0.2))
                                        .matchedGeometryEffect(id: "segment", in: animation)
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
