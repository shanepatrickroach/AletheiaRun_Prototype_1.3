
// Features/Profile/Settings/NotificationSettingsView.swift

import SwiftUI

struct NotificationSettingsView: View {
    @State private var runReminders = true
    @State private var achievementNotifications = true
    @State private var weeklyReport = true
    @State private var challengeUpdates = true
    @State private var sensorBatteryAlerts = true
    @State private var socialUpdates = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryOrange)
                        
                        Text("Notifications")
                            .font(Font.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Choose what updates you want to receive")
                            .font(Font.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Run Notifications
                    SettingsToggleSection(title: "Run Notifications") {
                        SettingsToggle(
                            icon: "alarm",
                            title: "Run Reminders",
                            description: "Daily reminders to stay active",
                            isOn: $runReminders
                        )
                        
                        SettingsToggle(
                            icon: "battery.25",
                            title: "Sensor Battery",
                            description: "Alerts when sensor battery is low",
                            isOn: $sensorBatteryAlerts
                        )
                    }
                    
                    // Achievement Notifications
                    SettingsToggleSection(title: "Achievements") {
                        SettingsToggle(
                            icon: "trophy",
                            title: "Achievement Unlocks",
                            description: "When you earn new achievements",
                            isOn: $achievementNotifications
                        )
                        
                        SettingsToggle(
                            icon: "target",
                            title: "Challenge Updates",
                            description: "Progress on active challenges",
                            isOn: $challengeUpdates
                        )
                    }
                    
                    // Reports
                    SettingsToggleSection(title: "Reports") {
                        SettingsToggle(
                            icon: "chart.bar",
                            title: "Weekly Summary",
                            description: "Your weekly running stats",
                            isOn: $weeklyReport
                        )
                    }
                    
                    // Social (Future Feature)
                    SettingsToggleSection(title: "Social") {
                        SettingsToggle(
                            icon: "person.2",
                            title: "Social Updates",
                            description: "Friend activities and leaderboards",
                            isOn: $socialUpdates
                        )
                    }
                    
                    // Info Card
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.infoBlue)
                            
                            Text("Notification Permissions")
                                .font(Font.bodyMedium)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Text("Make sure notifications are enabled in your device Settings for Aletheia.")
                            .font(Font.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(Font.bodySmall)
                        .foregroundColor(.primaryOrange)
                        .padding(.top, Spacing.xs)
                    }
                    .padding(Spacing.m)
                    .background(Color.infoBlue.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.m)
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings Toggle Section
struct SettingsToggleSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .font(Font.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.m)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .padding(.horizontal, Spacing.m)
        }
    }
}

// MARK: - Settings Toggle
struct SettingsToggle: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryOrange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text(description)
                        .font(Font.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .tint(.primaryOrange)
            }
            .padding(Spacing.m)
            
            Divider()
                .background(Color.cardBorder)
                .padding(.leading, 44)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
