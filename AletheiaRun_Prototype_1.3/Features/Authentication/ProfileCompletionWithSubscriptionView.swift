//
//  ProfileCompletionWithSubscriptionView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Features/Authentication/ProfileCompletionWithSubscriptionView.swift (NEW)

import SwiftUI

struct ProfileCompletionWithSubscriptionView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    let user: User
    
    @State private var showingSubscription = false
    
    var body: some View {
        ZStack {
            // Profile Completion
            ProfileCompletionView(user: user)
            
            // Subscription overlay appears after profile completion
            if showingSubscription {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                SubscriptionPromptCard {
                    // User completed subscription
                    var updatedUser = user
                    updatedUser.hasActiveSubscription = true
                    authManager.currentUser = updatedUser
                    authManager.authState = .authenticated(user: updatedUser)
                }
            }
        }
        .onChange(of: authManager.authState) { _, newState in
            // When profile is completed, show subscription
            if case .authenticated(let user) = newState, !user.hasActiveSubscription {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showingSubscription = true
                    }
                }
            }
        }
    }
}

// MARK: - Subscription Prompt Card
struct SubscriptionPromptCard: View {
    let onSubscribe: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
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
            
            // Subscription Options
            VStack(spacing: Spacing.m) {
                SubscriptionOption(
                    title: "Monthly",
                    price: "$29.99",
                    period: "per month",
                    isPopular: false
                )
                
                SubscriptionOption(
                    title: "Annual",
                    price: "$299.99",
                    period: "per year",
                    savings: "Save 17%",
                    isPopular: true
                )
            }
            
            PrimaryButton(
                title: "Start Subscription"
                
            ) {
                // TODO: Implement subscription flow
                onSubscribe()
            }
            
            Button("Maybe Later") {
                // Skip for now (limited functionality)
                onSubscribe()
            }
            .font(.bodySmall)
            .foregroundColor(.textTertiary)
        }
        .padding(Spacing.xl)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.xLarge)
        .padding(.horizontal, Spacing.l)
    }
}

// MARK: - Subscription Option
struct SubscriptionOption: View {
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
