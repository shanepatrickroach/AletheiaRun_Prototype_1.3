//
//  PurchaseSubscriptionSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

/// Sheet for purchasing a new subscription via browser
struct PurchaseSubscriptionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State private var selectedType: SubscriptionType = .annual
    @State private var isProcessing: Bool = false
    
    // Your purchase URLs - UPDATE THESE WITH YOUR ACTUAL LINKS
    private let trialPurchaseURL = "https://aletheia.com/purchase/trial"
    private let annualPurchaseURL = "https://aletheia.com/purchase/annual"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        headerSection
                        
                        // Plan selection
                        planSelectionSection
                        
                        // Features
                        featuresSection
                        
                        // Important info
                        infoSection
                        
                        Spacer()
                        
                        // Purchase button
                        purchaseButton
                        
                        // Help links
                        helpLinks
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Purchase Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "cart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.primaryOrange)
            }
            
            Text("Choose Your Plan")
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            
            Text("Secure checkout in your browser")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Plan Selection Section
    private var planSelectionSection: some View {
        VStack(spacing: Spacing.m) {
            // Trial option
            PlanSelectionCard(
                type: .trial,
                isSelected: selectedType == .trial,
                action: { selectedType = .trial }
            )
            
            // Annual option
            PlanSelectionCard(
                type: .annual,
                isSelected: selectedType == .annual,
                action: { selectedType = .annual }
            )
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.primaryOrange)
                
                Text("Everything Included. No Surprises.")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.s) {
                ForEach(SubscriptionFeature.standardFeatures) { feature in
                    HStack(spacing: Spacing.m) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.successGreen)
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(feature.title)
                                .font(.bodySmall)
                                .foregroundColor(.textPrimary)
                                .fontWeight(.semibold)
                            
                            Text(feature.description)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        VStack(spacing: Spacing.m) {
            HStack(alignment: .top, spacing: Spacing.m) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.successGreen)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Secure Payment")
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text("You'll be redirected to our secure payment page to complete your purchase")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                Spacer()
            }
            .padding(Spacing.m)
            .frame(width: .infinity)
            .background(Color.successGreen.opacity(0.1))
            .cornerRadius(CornerRadius.medium)
            
            if selectedType == .trial {
                HStack(alignment: .top, spacing: Spacing.m) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.infoBlue)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Trial Information")
                            .font(.bodySmall)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text("Start with 30 days free. If you don't cancel before the trial ends, you'll automatically be charged $239 for an annual subscription")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(Spacing.m)
                .background(Color.infoBlue.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
            }
        }
    }
    
    // MARK: - Purchase Button
    private var purchaseButton: some View {
        Button(action: openPurchaseLink) {
            HStack {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .backgroundBlack))
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title3)
                    
                    Text("Continue to Checkout")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.backgroundBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryOrange,
                        Color.primaryLight
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(CornerRadius.medium)
            .shadow(color: Color.primaryOrange.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .disabled(isProcessing)
    }
    
    // MARK: - Help Links
    private var helpLinks: some View {
        VStack(spacing: Spacing.s) {
            Button(action: {
                // Open FAQ or support
                if let url = URL(string: "https://aletheia.run/faq") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Have questions? View our FAQ")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Button(action: {
                // Open terms
                if let url = URL(string: "https://aletheia.run/terms") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Terms & Conditions")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
    }
    
    // MARK: - Open Purchase Link
    private func openPurchaseLink() {
        isProcessing = true
        
        // Determine which URL to use based on selected plan
        let urlString = selectedType == .trial ? trialPurchaseURL : annualPurchaseURL
        
        guard let url = URL(string: urlString) else {
            isProcessing = false
            return
        }
        
        // Open in Safari
        UIApplication.shared.open(url) { success in
            DispatchQueue.main.async {
                isProcessing = false
                if success {
                    // Dismiss the sheet since user is going to browser
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Plan Selection Card (Simplified)
struct PlanSelectionCard: View {
    let type: SubscriptionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(type.rawValue)
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: Spacing.xxs) {
                            Text(type.displayPrice)
                                .font(.titleMedium)
                                .foregroundColor(.primaryOrange)
                                .fontWeight(.bold)
                            
                            Text(type.billingPeriod)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Selection indicator
                    ZStack {
                        Circle()
                            .strokeBorder(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.primaryOrange)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                // Quick features
                if type == .trial {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        FeatureBullet(text: "Full access for 30 days")
                        
                        FeatureBullet(text: "Cancel anytime")
                    }
                } else {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                    
                        FeatureBullet(text: "Unlimited app access")
                        FeatureBullet(text: "Best value - just $19.92/month")
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeatureBullet: View {
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "checkmark")
                .font(.caption)
                .foregroundColor(.successGreen)
            
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Preview
#Preview {
    PurchaseSubscriptionSheet()
        .environmentObject(SubscriptionManager())
}
