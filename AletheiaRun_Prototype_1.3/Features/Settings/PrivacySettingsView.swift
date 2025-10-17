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
                    
                    // Permissions
                    SettingsToggleSection(title: "Data Sharing") {
                        
                        
                        SettingsToggle(
                            icon: "chart.bar.xaxis",
                            title: "Location",
                            description: "Aletheia Run uses location information to track your speef and distance.",
                            isOn: $allowAnalytics
                        )
                        
                        SettingsToggle(
                            icon: "chart.bar.yaxis",
                            title: "Bluetooth",
                            description: "Aletheia Run uses bluetooth to conect to the sensor.",
                            isOn: $allowAnalytics
                        )
                    }
                    
                    // Data Sharing
                    SettingsToggleSection(title: "Data Sharing") {
                        
                        
                        SettingsToggle(
                            icon: "chart.bar.xaxis",
                            title: "Usage Analytics",
                            description: "Help us improve the app with usage data",
                            isOn: $allowAnalytics
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
