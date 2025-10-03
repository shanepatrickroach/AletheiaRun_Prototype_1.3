//
//  ChallengesTabView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Progress/ChallengesTabView.swift (NEW FILE)

import SwiftUI

struct ChallengesTabView: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    @State private var selectedFilter: ChallengeFilter = .active
    
    enum ChallengeFilter: String, CaseIterable {
        case active = "Active"
        case completed = "Completed"
        
        var icon: String {
            switch self {
            case .active: return "flame.fill"
            case .completed: return "checkmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                
                // Challenge Stats Card
                ChallengeStatsCard()
                    .padding(.horizontal, Spacing.l)
                    .padding(.top, Spacing.m)
                
                // Filter Buttons
                HStack(spacing: Spacing.m) {
                    ForEach(ChallengeFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.rawValue,
                            icon: filter.icon,
                            count: filter == .active ? gamificationManager.activeChallenges.count : gamificationManager.completedChallenges.count,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Challenges List
                VStack(spacing: Spacing.m) {
                    if displayedChallenges.isEmpty {
                        EmptyChallengesView(filter: selectedFilter)
                            .padding(.top, Spacing.xxxl)
                    } else {
                        ForEach(displayedChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, Spacing.xxxl)
        }
    }
    
    private var displayedChallenges: [Challenge] {
        selectedFilter == .active 
            ? gamificationManager.activeChallenges 
            : gamificationManager.completedChallenges
    }
}

// MARK: - Challenge Stats Card
struct ChallengeStatsCard: View {
    @EnvironmentObject var gamificationManager: GamificationManager
    
    var body: some View {
        HStack(spacing: Spacing.l) {
            StatItem(
                value: "\(gamificationManager.totalActiveChallenges)",
                label: "Active",
                icon: "flame.fill",
                color: .primaryOrange
            )
            
            Divider()
                .frame(height: 40)
                .background(Color.cardBorder)
            
            StatItem(
                value: "\(gamificationManager.totalCompletedChallenges)",
                label: "Completed",
                icon: "checkmark.circle.fill",
                color: .successGreen
            )
            
            Divider()
                .frame(height: 40)
                .background(Color.cardBorder)
            
            StatItem(
                value: "85%",
                label: "Success Rate",
                icon: "chart.line.uptrend.xyaxis",
                color: .infoBlue
            )
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let title: String
    let icon: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.bodyMedium)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                Spacer()
                
                Text("\(count)")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .primaryOrange : .textTertiary)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(
                        isSelected 
                            ? Color.primaryOrange.opacity(0.2)
                            : Color.cardBorder.opacity(0.3)
                    )
                    .cornerRadius(CornerRadius.small)
            }
            .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            .padding(Spacing.m)
            .background(
                isSelected 
                    ? Color.primaryOrange.opacity(0.1)
                    : Color.cardBackground
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Empty Challenges View
struct EmptyChallengesView: View {
    let filter: ChallengesTabView.ChallengeFilter
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: filter == .active ? "flag.fill" : "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text(filter == .active ? "No Active Challenges" : "No Completed Challenges")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(filter == .active 
                ? "New challenges will appear here. Keep running!"
                : "Complete challenges to see them here."
            )
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
        }
        .padding(.vertical, Spacing.xxxl)
    }
}

#Preview {
    ChallengesTabView()
        .environmentObject(GamificationManager())
}