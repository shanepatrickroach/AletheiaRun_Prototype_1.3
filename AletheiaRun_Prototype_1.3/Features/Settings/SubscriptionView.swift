//
//  SubscriptionsSettingView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//

import SwiftUI

// MARK: - Subscription View
struct SubscriptionView: View {
    @State private var currentPlan: PlanType = .trial
    @State private var showingCancelAlert = false
    @State private var showingUpgradeSheet = false
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Current plan card
                    currentPlanCard
                    
                    // Available plans
                    availablePlansSection
                    
                    // Features comparison
                    featuresSection
                    
                    // Billing info
                    billingInfoSection
                    
                    // Manage subscription
                    manageSubscriptionSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.m)
            }
        }
        .navigationTitle("Subscription")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingUpgradeSheet) {
            UpgradeSheet(selectedPlan: $currentPlan)
        }
        .alert("Cancel Subscription?", isPresented: $showingCancelAlert) {
            Button("Keep Subscription", role: .cancel) { }
            Button("Cancel", role: .destructive) {
                // Handle cancellation
            }
        } message: {
            Text("You'll lose access to premium features at the end of your billing period.")
        }
    }
    
    // MARK: - Current Plan Card
    private var currentPlanCard: some View {
        VStack(spacing: Spacing.m) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Text("Current Plan")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        if currentPlan == .trial {
                            Text("TRIAL")
                                .font(.caption)
                                .foregroundColor(.infoBlue)
                                .padding(.horizontal, Spacing.xs)
                                .padding(.vertical, 2)
                                .background(Color.infoBlue.opacity(0.2))
                                .cornerRadius(CornerRadius.small)
                        }
                    }
                    
                    Text(currentPlan.displayName)
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Plan icon
                ZStack {
                    Circle()
                        .fill(currentPlan.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: currentPlan.icon)
                        .font(.system(size: 28))
                        .foregroundColor(currentPlan.color)
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Plan details
            VStack(spacing: Spacing.s) {
                if currentPlan == .trial {
                    // Trial details
                    SubscriptionDetailRow(
                        icon: "calendar",
                        label: "Trial Ends",
                        value: "Dec 15, 2024"
                    )
                    
                    SubscriptionDetailRow(
                        icon: "clock.fill",
                        label: "Days Remaining",
                        value: "23 days"
                    )
                } else {
                    // Annual details
                    SubscriptionDetailRow(
                        icon: "calendar",
                        label: "Next Billing Date",
                        value: "Jan 15, 2025"
                    )
                    
                    SubscriptionDetailRow(
                        icon: "dollarsign.circle.fill",
                        label: "Amount",
                        value: "$239.00"
                    )
                }
                
                SubscriptionDetailRow(
                    icon: "checkmark.circle.fill",
                    label: "Status",
                    value: "Active",
                    valueColor: .successGreen
                )
            }
            
            // Action button
            if currentPlan == .trial {
                Button(action: { showingUpgradeSheet = true }) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("Upgrade to Annual")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.backgroundBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(Color.primaryOrange)
                    .cornerRadius(CornerRadius.medium)
                }
                .padding(.top, Spacing.s)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(currentPlan.color.opacity(0.5), lineWidth: 2)
        )
    }
    
    // MARK: - Available Plans Section
    private var availablePlansSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Available Plans")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                // Trial Plan
                PlanCard(
                    plan: .trial,
                    isCurrentPlan: currentPlan == .trial,
                    action: {
                        if currentPlan != .trial {
                            // Can't downgrade to trial
                        }
                    }
                )
                
                // Annual Plan
                PlanCard(
                    plan: .annual,
                    isCurrentPlan: currentPlan == .annual,
                    action: {
                        if currentPlan == .trial {
                            showingUpgradeSheet = true
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("What's Included")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                SubscriptionFeatureRow(
                    icon: "waveform.path.ecg",
                    title: "Force Portrait Analysis",
                    description: "Advanced biomechanics visualization",
                    isIncluded: true
                )
                
                Divider().background(Color.cardBorder)
                
                SubscriptionFeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Performance Metrics",
                    description: "Track efficiency, sway, impact & more",
                    isIncluded: true
                )
                
                Divider().background(Color.cardBorder)
                
                SubscriptionFeatureRow(
                    icon: "cross.case.fill",
                    title: "Injury Diagnostics",
                    description: "Hip mobility & stability tracking",
                    isIncluded: true
                )
                
                Divider().background(Color.cardBorder)
                
                SubscriptionFeatureRow(
                    icon: "person.fill.checkmark",
                    title: "Pocket Coach",
                    description: "Personalized exercise recommendations",
                    isIncluded: true
                )
                
                Divider().background(Color.cardBorder)
                
                SubscriptionFeatureRow(
                    icon: "calendar.badge.clock",
                    title: "Unlimited Run Recording",
                    description: "No limits on your training",
                    isIncluded: true
                )
                
                Divider().background(Color.cardBorder)
                
                SubscriptionFeatureRow(
                    icon: "arrow.down.circle.fill",
                    title: "Data Export",
                    description: "Download your complete run history",
                    isIncluded: true
                )
            }
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Billing Info Section
    private var billingInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Billing Information")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                // Payment method
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.infoBlue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Payment Method")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("•••• 4242")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Update")
                            .font(.bodySmall)
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.small)
                
                // Billing history
                Button(action: {}) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.infoBlue)
                            .frame(width: 24)
                        
                        Text("View Billing History")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
                }
            }
        }
    }
    
    // MARK: - Manage Subscription Section
    private var manageSubscriptionSection: some View {
        VStack(spacing: Spacing.m) {
            if currentPlan == .annual {
                // Cancel subscription button
                Button(action: { showingCancelAlert = true }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Cancel Subscription")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.errorRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(Color.errorRed.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                }
            }
            
            // Help links
            VStack(spacing: Spacing.s) {
                Button(action: {}) {
                    Text("Restore Purchases")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Button(action: {}) {
                    Text("Terms & Conditions")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Plan Type Enum
enum PlanType {
    case trial
    case annual
    
    var displayName: String {
        switch self {
        case .trial: return "30-Day Free Trial"
        case .annual: return "Annual Membership"
        }
    }
    
    var price: String {
        switch self {
        case .trial: return "Free"
        case .annual: return "$239"
        }
    }
    
    var billingPeriod: String {
        switch self {
        case .trial: return "for 30 days"
        case .annual: return "per year"
        }
    }
    
    var icon: String {
        switch self {
        case .trial: return "gift.fill"
        case .annual: return "crown.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .trial: return .infoBlue
        case .annual: return .warningYellow
        }
    }
    
    var features: [String] {
        switch self {
        case .trial:
            return [
                "Full access to all features",
                "No credit card required",
                "Cancel anytime"
            ]
        case .annual:
            return [
                "Unlimited run recording",
                "Advanced analytics",
                "Priority support",
                "Save $60 vs monthly"
            ]
        }
    }
}

// MARK: - Plan Card Component
struct PlanCard: View {
    let plan: PlanType
    let isCurrentPlan: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(plan.displayName)
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: Spacing.xxs) {
                            Text(plan.price)
                                .font(.titleLarge)
                                .foregroundColor(.primaryOrange)
                                .fontWeight(.bold)
                            
                            Text(plan.billingPeriod)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Icon
                    ZStack {
                        Circle()
                            .fill(plan.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: plan.icon)
                            .font(.titleMedium)
                            .foregroundColor(plan.color)
                    }
                }
                
                // Features
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(plan.features, id: \.self) { feature in
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(plan.color)
                            
                            Text(feature)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                // Current plan badge or select button
                if isCurrentPlan {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.successGreen)
                        
                        Text("Current Plan")
                            .font(.bodySmall)
                            .foregroundColor(.successGreen)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.successGreen.opacity(0.1))
                    .cornerRadius(CornerRadius.small)
                } else {
                    Text("Select Plan")
                        .font(.bodyMedium)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        .background(plan.color)
                        .cornerRadius(CornerRadius.small)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isCurrentPlan ? plan.color : Color.cardBorder, lineWidth: isCurrentPlan ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isCurrentPlan)
    }
}

// MARK: - Detail Row Component
struct SubscriptionDetailRow: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = .textPrimary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.textTertiary)
                .frame(width: 24)
            
            Text(label)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodySmall)
                .foregroundColor(valueColor)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Feature Row Component
struct SubscriptionFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let isIncluded: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            if isIncluded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.successGreen)
            }
        }
        .padding(Spacing.m)
    }
}

// MARK: - Upgrade Sheet
struct UpgradeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPlan: PlanType
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    Spacer()
                    
                    // Success icon
                    ZStack {
                        Circle()
                            .fill(Color.warningYellow.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.warningYellow)
                    }
                    
                    // Title and description
                    VStack(spacing: Spacing.m) {
                        Text("Upgrade to Annual")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("Get full access to all premium features for an entire year")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xl)
                    }
                    
                    // Pricing
                    VStack(spacing: Spacing.xs) {
                        HStack(alignment: .firstTextBaseline, spacing: Spacing.xs) {
                            Text("$239")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primaryOrange)
                            
                            Text("per year")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Text("Just $19.92 per month")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Upgrade button
                    Button(action: {
                        selectedPlan = .annual
                        showingSuccessAlert = true
                    }) {
                        Text("Upgrade Now")
                            .font(.bodyLarge)
                            .foregroundColor(.backgroundBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.m)
                            .background(Color.primaryOrange)
                            .cornerRadius(CornerRadius.medium)
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    // Cancel button
                    Button(action: { dismiss() }) {
                        Text("Maybe Later")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .padding(.vertical, Spacing.s)
                    }
                    .padding(.bottom, Spacing.xl)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Subscription Updated", isPresented: $showingSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("You're now subscribed to the Annual Membership. Enjoy all premium features!")
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        SubscriptionView()
    }
}
