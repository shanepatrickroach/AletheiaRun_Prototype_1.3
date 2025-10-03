//
//  SubscriptionBanner.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Core/Components/SubscriptionBanner.swift (NEW FILE)

import SwiftUI

struct SubscriptionBanner: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSubscription = false
    @State private var isDismissed = false
    
    var body: some View {
        if !isDismissed {
            VStack(spacing: 0) {
                HStack(spacing: Spacing.m) {
                    // Icon
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                    
                    // Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Unlock Premium Features")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("Get Force Portrait analysis and more")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Upgrade Button
                    Button(action: {
                        showingSubscription = true
                    }) {
                        Text("Upgrade")
                            .font(.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.backgroundBlack)
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.s)
                            .background(Color.primaryOrange)
                            .cornerRadius(CornerRadius.small)
                    }
                    
                    // Dismiss Button
                    Button(action: {
                        withAnimation {
                            isDismissed = true
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.textTertiary)
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(Spacing.m)
                .background(Color.primaryOrange.opacity(0.1))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.primaryOrange.opacity(0.3)),
                    alignment: .bottom
                )
            }
            .sheet(isPresented: $showingSubscription) {
                if let user = authManager.currentUser {
                    SubscriptionRequiredView(user: user)
                }
            }
        }
    }
}

#Preview {
    SubscriptionBanner()
        .environmentObject(AuthenticationManager())
}