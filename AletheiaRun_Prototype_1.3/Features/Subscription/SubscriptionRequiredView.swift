// Features/Subscription/SubscriptionRequiredView.swift

import SwiftUI

struct SubscriptionRequiredView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    let user: User
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Header
                        VStack(spacing: Spacing.m) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Unlock Your Running Potential")
                                .font(.titleLarge)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("Get access to Force Portrait analysis, personalized coaching, and advanced metrics")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, Spacing.xxxl)
                        .padding(.horizontal, Spacing.l)
                        
                        // Features List
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            FeatureRow(
                                icon: "waveform.path.ecg",
                                title: "Force Portrait Analysis",
                                description: "Detailed biomechanics visualization"
                            )
                            FeatureRow(
                                icon: "figure.run",
                                title: "Unlimited Run Recording",
                                description: "Track all your sessions"
                            )
                            FeatureRow(
                                icon: "person.badge.shield.checkmark",
                                title: "Pocket Coach",
                                description: "Personalized exercise recommendations"
                            )
                            FeatureRow(
                                icon: "trophy.fill",
                                title: "Achievements & Challenges",
                                description: "Stay motivated with goals"
                            )
                            FeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Advanced Analytics",
                                description: "Deep insights into your progress"
                            )
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Subscription Options
                        VStack(spacing: Spacing.m) {
                            SubscriptionOptionCard(
                                title: "Free Trial",
                                price: "0",
                                period: "for 30 days",
                                isPopular: false
                            )
                            
                            SubscriptionOptionCard(
                                title: "Annual",
                                price: "$299.99",
                                period: "per year",
                                savings: "Save 17%",
                                isPopular: true
                            )
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Subscribe Button
                        PrimaryButton(
                            title: "Start Subscription"
                            
                        ) {
                            subscribe()
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Maybe Later
                        Button("Continue with Limited Features") {
                            skipSubscription()
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textTertiary)
                        
                    }
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        authManager.signOut()
                    }
                    .foregroundColor(.errorRed)
                    .font(.bodySmall)
                }
            }
        }
    }
    
    private func subscribe() {
       
        // For now, simulate successful subscription
        var updatedUser = user
        updatedUser.hasActiveSubscription = true
        
        authManager.currentUser = updatedUser
        authManager.authState = .authenticated(user: updatedUser)
    }
    
    private func skipSubscription() {
       
        // Allow limited access
        authManager.currentUser = user
        authManager.authState = .authenticated(user: user)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Subscription Option Card
struct SubscriptionOptionCard: View {
    let title: String
    let price: String
    let period: String
    var savings: String? = nil
    let isPopular: Bool
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            if isPopular {
                Text("MOST POPULAR")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.primaryOrange.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text(price)
                            .font(.titleMedium)
                            .foregroundColor(.primaryOrange)
                        
                        Text(period)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                if let savings = savings {
                    Text(savings)
                        .font(.caption)
                        .foregroundColor(.successGreen)
                        .padding(.horizontal, Spacing.s)
                        .padding(.vertical, 4)
                        .background(Color.successGreen.opacity(0.2))
                        .cornerRadius(CornerRadius.small)
                }
            }
        }
        .padding(Spacing.m)
        .background(isPopular ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(isPopular ? Color.primaryOrange : Color.cardBorder, lineWidth: isPopular ? 2 : 1)
        )
    }
}

#Preview {
    SubscriptionRequiredView(user: User(
        id: UUID(),
        email: "test@test.com",
        firstName: "John",
        lastName: "Doe",
        birthdate: Date(),
        country: "United States",
        gender: .male,
        measurementSystem: .imperial,
        height: Height(feet: 5, inches: 10, centimeters: nil),
        weight: Weight(pounds: 165, kilograms: nil),
        averageMileage: .miles20to30,
        runningGoals: [.improvePerformance],
        profileImage: nil,
        stats: nil,
        hasActiveSubscription: false
    ))
    .environmentObject(AuthenticationManager())
}
