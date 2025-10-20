// Features/CoachMode/CoachModeView.swift

import SwiftUI

/// Placeholder view for Coach Mode feature
struct CoachModeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xxl) {
                        // Hero Image/Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.primaryOrange.opacity(0.3),
                                            Color.primaryLight.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "person.badge.shield.checkmark")
                                .font(.system(size: 80))
                                .foregroundColor(.primaryOrange)
                        }
                        .padding(.top, Spacing.xxl)
                        
                        // Title and Description
                        VStack(spacing: Spacing.m) {
                            Text("Coach Mode")
                                .font(.displayMedium)
                                .foregroundColor(.textPrimary)
                            
                            Text("Help other runners improve their form")
                                .font(.bodyLarge)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, Spacing.xl)
                        
                        // Feature Cards
                        VStack(spacing: Spacing.m) {
                            CoachFeatureCard(
                                icon: "person.2.fill",
                                title: "Connect with Athletes",
                                description: "Coach multiple runners and track their progress"
                            )
                            
                            CoachFeatureCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Analyze Performance",
                                description: "View detailed Force Portraits and metrics for your athletes"
                            )
                            
                            CoachFeatureCard(
                                icon: "message.fill",
                                title: "Provide Feedback",
                                description: "Give personalized tips and exercise recommendations"
                            )
                            
                            CoachFeatureCard(
                                icon: "calendar.badge.clock",
                                title: "Track Progress",
                                description: "Monitor improvement over time with detailed analytics"
                            )
                        }
                        .padding(.horizontal, Spacing.m)
                        
                        // Coming Soon Badge
                        VStack(spacing: Spacing.s) {
                            Text("COMING SOON")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryOrange)
                                .padding(.horizontal, Spacing.m)
                                .padding(.vertical, Spacing.xs)
                                .background(Color.primaryOrange.opacity(0.2))
                                .cornerRadius(CornerRadius.small)
                            
                            Text("We're working hard to bring Coach Mode to you")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.m)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Coach Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Coach Feature Card
struct CoachFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.primaryOrange)
            }
            
            // Text
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    CoachModeView()
}