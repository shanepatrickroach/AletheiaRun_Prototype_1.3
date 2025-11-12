//
//  FloatingSubscriptionBanner.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Core/Components/FloatingSubscriptionBanner.swift (NEW FILE)

import SwiftUI

struct FloatingSubscriptionBanner: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSubscription = false
    @State private var isDismissed = false
    @State private var offset: CGFloat = -100
    
    var body: some View {
        if !isDismissed {
            HStack(spacing: Spacing.s) {
                Image(systemName: "crown.fill")
                    .foregroundColor(.warningYellow)
                
                Text("Upgrade to unlock all features")
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View Plans") {
                    showingSubscription = true
                }
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundColor(.primaryOrange)
                
                Button(action: {
                    withAnimation(.spring()) {
                        offset = -100
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isDismissed = true
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.s)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.cardBackground)
                    .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, Spacing.m)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    offset = 0
                }
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
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        VStack {
            FloatingSubscriptionBanner()
                .environmentObject(AuthenticationManager())
            
            Spacer()
        }
    }
}