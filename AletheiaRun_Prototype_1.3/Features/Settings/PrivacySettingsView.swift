//
//  PrivacySettingsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/PrivacySettingsView.swift

import SwiftUI

struct PrivacySettingsView: View {
    @State private var shareDataForResearch = false
    @State private var allowAnalytics = true
    @State private var showInLeaderboards = true
    @State private var allowFriendRequests = true
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryOrange)
                        
                        Text("Privacy & Data")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Control how your data is used")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Data Sharing
                    SettingsToggleSection(title: "Data Sharing") {
                        SettingsToggle(
                            icon: "chart.xyaxis.line",
                            title: "Research Contribution",
                            description: "Share anonymized data to improve running science",
                            isOn: $shareDataForResearch
                        )
                        
                        SettingsToggle(
                            icon: "chart.bar.xaxis",
                            title: "Usage Analytics",
                            description: "Help us improve the app with usage data",
                            isOn: $allowAnalytics
                        )
                    }
                    
                    // Social Privacy
                    SettingsToggleSection(title: "Social Privacy") {
                        SettingsToggle(
                            icon: "list.number",
                            title: "Show in Leaderboards",
                            description: "Display your stats in anonymous leaderboards",
                            isOn: $showInLeaderboards
                        )
                        
                        SettingsToggle(
                            icon: "person.badge.plus",
                            title: "Friend Requests",
                            description: "Allow others to send you friend requests",
                            isOn: $allowFriendRequests
                        )
                    }
                    
                    // Data Management
                    SettingsSection(title: "Data Management") {
                        SettingsActionRow(
                            icon: "square.and.arrow.down",
                            title: "Download My Data",
                            description: "Get a copy of all your data",
                            action: { }
                        )
                        
                        SettingsActionRow(
                            icon: "trash",
                            title: "Delete All Data",
                            description: "Permanently delete all your data",
                            isDestructive: true,
                            action: { }
                        )
                    }
                    
                    // Privacy Info
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        Text("Your Privacy Matters")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("We take your privacy seriously. Your personal information is encrypted and never sold to third parties. Read our full Privacy Policy for more details.")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        Button("View Privacy Policy") {
                            // Open privacy policy
                        }
                        .font(.bodySmall)
                        .foregroundColor(.primaryOrange)
                        .padding(.top, Spacing.xs)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.m)
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings Action Row
struct SettingsActionRow: View {
    let icon: String
    let title: String
    let description: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isDestructive ? .errorRed : .primaryOrange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bodyMedium)
                        .foregroundColor(isDestructive ? .errorRed : .textPrimary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
        }
        
        Divider()
            .background(Color.cardBorder)
            .padding(.leading, 44)
    }
}

#Preview {
    NavigationStack {
        PrivacySettingsView()
    }
}