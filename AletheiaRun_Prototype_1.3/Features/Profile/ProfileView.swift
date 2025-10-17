//
//  ProfileView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSignOutAlert = false
    @State private var showingEditProfile = false
    @State private var showingNotifications = false
    @State private var showingPrivacy = false
    @State private var showingSubscription = false
    @State private var showingSensorSettings = false
    @State private var showingAbout = false
    @State private var showingHelp = false
    @State private var showingContact = false
    @State private var showingUnits = false
    
    var user: User? {
        authManager.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Profile header
                        ProfileHeader(user: user)
                        
                        // Stats overview
                        StatsOverviewSection(stats: user?.stats)
                        
                        // Settings sections
                        SettingsSection(title: "Account") {
                            SettingsRow(
                                icon: "person.fill",
                                title: "Edit Profile"
                            ) {
                                showingEditProfile = true
                            }
                            
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Notifications"
                            ) {
                                showingNotifications = true
                            }
                            
                            SettingsRow(
                                icon: "lock.fill",
                                title: "Privacy"
                            ) {
                                showingPrivacy = true
                            }
                            SettingsRow(
                                icon: "ticket.fill",
                                title: "Subscription"
                            ) {
                                showingSubscription = true
                            }
                        }
                        
                        SettingsSection(title: "App") {
                            SettingsRow(
                                icon: "sensor",
                                title: "Sensor Settings"
                            ) {
                                showingSensorSettings = true
                            }
                            SettingsRow(
                                icon: "base.unit",
                                title: "Units"
                            ) {
                                showingUnits = true
                            }
                            
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "About"
                            ) {
                                showingAbout = true
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                icon: "questionmark.circle.fill",
                                title: "Help Center"
                            ) {
                                showingHelp = true
                            }
                            
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us"
                            ) {
                                showingContact = true
                            }
                            
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App"
                            ) {
                                rateApp()
                            }
                        }
                        
                        // Sign out button
                        Button(action: {
                            showingSignOutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 20))
                                
                                Text("Sign Out")
                                    .font(Font.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.errorRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.m)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(CornerRadius.medium)
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Version info
                        Text("Version 1.0.0")
                            .font(Font.caption)
                            .foregroundColor(.textTertiary)
                            .padding(.top, Spacing.m)
                    }
                    .padding(.top, Spacing.xl)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
             // Navigation destinations
            .navigationDestination(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .navigationDestination(isPresented: $showingNotifications) {
                NotificationSettingsView()
            }
            .navigationDestination(isPresented: $showingPrivacy) {
                PrivacySettingsView()
            }
            .navigationDestination(isPresented: $showingSubscription) {
                SubscriptionView()
            }
            
            .navigationDestination(isPresented: $showingSensorSettings) {
                SensorSettingsView()
            }
            .navigationDestination(isPresented: $showingUnits) {
                UnitSettingsView()
            }
            .navigationDestination(isPresented: $showingAbout) {
                AboutView()
            }
            .navigationDestination(isPresented: $showingHelp) {
                HelpCenterView()
            }
            .navigationDestination(isPresented: $showingContact) {
                ContactUsView()
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    // MARK: - Rate App
    private func rateApp() {
        // Open App Store rating
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
}
// MARK: - Profile Header (UPDATED)
struct ProfileHeader: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Profile image
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.primaryOrange, .primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                if let profileImage = user?.profileImage {
                    // In real app, load actual image
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                } else {
                    Text(user?.firstName.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            VStack(spacing: 4) {
                Text(user?.fullName ?? "User")
                    .font(.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text(user?.email ?? "user@example.com")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            // User details
            HStack(spacing: Spacing.l) {
                ProfileDetailBadge(
                    icon: "calendar",
                    text: "\(user?.age ?? 0) years"
                )
                
                ProfileDetailBadge(
                    icon: "figure.run",
                    text: user?.averageMileage.rawValue ?? ""
                )
            }
            
            HStack(spacing: Spacing.l) {
                ProfileDetailBadge(
                    icon: "ruler",
                    text: user?.height.displayString ?? ""
                )
                
                ProfileDetailBadge(
                    icon: "scalemass",
                    text: user?.weight.displayString ?? ""
                )
            }
            
            // Running goals
            if let goals = user?.runningGoals, !goals.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Goals")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    FlowLayout(spacing: Spacing.xs) {
                        ForEach(Array(goals), id: \.self) { goal in
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: goal.icon)
                                    .font(.system(size: 12))
                                
                                Text(goal.rawValue)
                                    .font(.caption)
                            }
                            .foregroundColor(.primaryOrange)
                            .padding(.horizontal, Spacing.s)
                            
                            .background(Color.primaryOrange.opacity(0.2))
                            .cornerRadius(CornerRadius.small)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, Spacing.l)
    }
}

struct ProfileDetailBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Enhanced Stats Overview Section (UPDATED)
struct StatsOverviewSection: View {
    let stats: UserStats?
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            HStack {
                Text("Your Stats")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
//                Button(action: {
//                    // View all stats
//                }) {
//                    HStack(spacing: 4) {
//                        Text("View All")
//                            .font(.caption)
//                            .foregroundColor(.primaryOrange)
//                        
//                        Image(systemName: "chevron.right")
//                            .font(.system(size: 10))
//                            .foregroundColor(.primaryOrange)
//                    }
//                }
            }
            .padding(.horizontal, Spacing.l)
            
            // First row
            HStack(spacing: Spacing.m) {
                StatCard(
                    icon: "figure.run",
                    value: "\(stats?.totalRuns ?? 0)",
                    label: "Total Runs",
                    color: .primaryOrange
                )
                
                StatCard(
                    icon: "flame.fill",
                    value: "\(stats?.currentStreak ?? 0)",
                    label: "Day Streak",
                    color: .warningYellow
                )
            }
            .padding(.horizontal, Spacing.l)
            
            // Second row
            HStack(spacing: Spacing.m) {
                StatCard(
                    icon: "road.lanes",
                    value: String(format: "%.1f", stats?.totalDistance ?? 0),
                    label: "Total Miles",
                    color: .infoBlue
                )
                
                StatCard(
                    icon: "clock.fill",
                    value: stats?.averagePace ?? "0:00",
                    label: "Avg Pace",
                    color: .successGreen
                )
            }
            .padding(.horizontal, Spacing.l)
            
            // Third row
            HStack(spacing: Spacing.m) {
                StatCard(
                    icon: "trophy.fill",
                    value: "\(stats?.achievements.count ?? 0)",
                    label: "Achievements",
                    color: Color(hex: "FFD700")
                )
                
                StatCard(
                    icon: "flame.circle.fill",
                    value: "\(stats?.longestStreak ?? 0)",
                    label: "Best Streak",
                    color: .errorRed
                )
            }
            .padding(.horizontal, Spacing.l)
        }
    }
}
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.titleSmall)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.l)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.l)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .padding(.horizontal, Spacing.l)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryOrange)
                    .frame(width: 32)
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.s)
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
            .background(Color.cardBorder)
            .padding(.leading, 44)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}
