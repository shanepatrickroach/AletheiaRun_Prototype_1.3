//
//  EnhancedSubscriptionView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//

//
//  EnhancedSubscriptionView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

/// Main subscription management view
struct EnhancedSubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingPurchaseSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var showingAssignSheet = false

    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.xl) {

                    // Purchase new subscription button
                    purchaseNewSubscriptionButton

                    // Active subscriptions section
                    if !subscriptionManager.activeSubscriptions.isEmpty {
                        activeSubscriptionsSection
                    }

                    // Features section
                    //featuresSection

                    // Managed subscriptions (assigned to others)
                    if !subscriptionManager.assignedToOthers.isEmpty {
                        managedSubscriptionsSection
                    }

                    // Help and support
                    //helpSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.l)
            }
        }

        .sheet(isPresented: $showingPurchaseSheet) {
            PurchaseSubscriptionSheet()
        }
        .sheet(item: $selectedSubscription) { subscription in
            SubscriptionDetailSheet(subscription: subscription)
        }
        .sheet(isPresented: $showingAssignSheet) {
            if let subscription = selectedSubscription {
                AssignSubscriptionSheet(subscription: subscription)
            }
        }
    }

    // MARK: - Active Subscriptions Section
    private var activeSubscriptionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Your Active Subscriptions")
                .font(.headline)
                .foregroundColor(.textPrimary)

            ForEach(subscriptionManager.activeSubscriptions) { subscription in
                SubscriptionCard(subscription: subscription) {
                    selectedSubscription = subscription
                }
            }
        }
    }

    // MARK: - Purchase Button
    private var purchaseNewSubscriptionButton: some View {
        Button(action: {
            showingPurchaseSheet = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)

                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Purchase New Subscription")
                        .font(.bodyMedium)
                        .fontWeight(.semibold)

                    Text("Buy for yourself or gift to others")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                    
                
            }
            .foregroundColor(.white)
            .padding(Spacing.m)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryOrange.opacity(0.2),
                        Color.red.opacity(0.2),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(CornerRadius.medium)
            .shadow(
                color: Color.primaryOrange.opacity(0.4),
                radius: 8,
                x: 0,
                y: 4
            ).overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            
            
        }
    }

    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.primaryOrange)

                Text("What's Included")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }

            VStack(spacing: 0) {
                ForEach(
                    Array(SubscriptionFeature.standardFeatures.enumerated()),
                    id: \.element.id
                ) { index, feature in
                    EnhancedSubscriptionFeatureRow(feature: feature)

                    if index < SubscriptionFeature.standardFeatures.count - 1 {
                        Divider()
                            .background(Color.cardBorder)
                    }
                }
            }
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }

    // MARK: - Managed Subscriptions Section
    private var managedSubscriptionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Subscriptions You Manage")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Text("Subscriptions assigned to other users")
                .font(.caption)
                .foregroundColor(.textSecondary)

            ForEach(subscriptionManager.assignedToOthers) { subscription in
                ManagedSubscriptionCard(subscription: subscription)
            }
        }
    }

    // MARK: - Help Section
    private var helpSection: some View {
        VStack(spacing: Spacing.m) {
            

            Button(action: {}) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.infoBlue)

                    Text("Terms & Conditions")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    Spacer()
                }
            }

           
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Subscription Card Component
struct SubscriptionCard: View {
    let subscription: Subscription
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.s) {
                // Header - More compact
                HStack(alignment: .center) {
                    // Status icon - smaller
                    ZStack {
                        Circle()
                            .fill(
                                Color(hex: subscription.status.color).opacity(0.2)
                            )
                            .frame(width: 40, height: 40)

                        Image(systemName: subscription.status.icon)
                            .font(.body)
                            .foregroundColor(
                                Color(hex: subscription.status.color)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        HStack(spacing: Spacing.xs) {
                            Text(subscription.type.rawValue)
                                .font(.bodyMedium)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)

                            // Status badge - inline
                            Text(subscription.status.rawValue)
                                .font(.system(size: 10))
                                .foregroundColor(
                                    Color(hex: subscription.status.color)
                                )
                                .padding(.horizontal, Spacing.xs)
                                .padding(.vertical, 2)
                                .background(
                                    Color(hex: subscription.status.color)
                                        .opacity(0.2)
                                )
                                .cornerRadius(CornerRadius.small)
                        }

                        // Assigned user or key info - single line
                        if let assignedName = subscription.assignedUserName {
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 10))

                                Text(
                                    subscription.isAssigned
                                        ? "Assigned to \(assignedName)"
                                        : assignedName
                                )
                                .font(.caption)
                            }
                            .foregroundColor(.textSecondary)
                        } else {
                            // Show key date info if not assigned
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: subscription.status == .trial ? "clock.fill" : "calendar")
                                    .font(.system(size: 10))
                                    .foregroundColor(.textTertiary)
                                
                                if subscription.status == .trial {
                                    Text("\(subscription.daysRemaining) days left")
                                        .font(.caption)
                                        .foregroundColor(
                                            subscription.isExpiringSoon ? .warningYellow : .textSecondary
                                        )
                                } else if let nextBilling = subscription.nextBillingDate {
                                    Text("Next: \(nextBilling.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                    }

                    Spacer()

                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
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
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Managed Subscription Card
struct ManagedSubscriptionCard: View {
    let subscription: Subscription
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingRevokeAlert = false

    var body: some View {
        VStack(spacing: Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(subscription.assignedUserName ?? "Unknown")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)

                    Text(subscription.assignedUserEmail ?? "")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    if let assignmentDate = subscription.assignmentDate {
                        Text(
                            "Assigned \(assignmentDate.formatted(date: .abbreviated, time: .omitted))"
                        )
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                    }
                }

                Spacer()

                Button(action: {
                    showingRevokeAlert = true
                }) {
                    Text("Revoke")
                        .font(.bodySmall)
                        .foregroundColor(.errorRed)
                        .padding(.horizontal, Spacing.m)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.errorRed.opacity(0.1))
                        .cornerRadius(CornerRadius.small)
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
        .alert("Revoke Subscription?", isPresented: $showingRevokeAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Revoke", role: .destructive) {
                Task {
                    try? await subscriptionManager.revokeAssignment(
                        subscriptionID: subscription.id
                    )
                }
            }
        } message: {
            Text(
                "This will immediately remove access for \(subscription.assignedUserName ?? "this user"). This action cannot be undone."
            )
        }
    }
}

// MARK: - Feature Row Component
struct EnhancedSubscriptionFeatureRow: View {
    let feature: SubscriptionFeature

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: feature.icon)
                    .foregroundColor(.primaryOrange)
            }

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(feature.title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)

                Text(feature.description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            if feature.isIncluded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.successGreen)
            }
        }
        .padding(Spacing.m)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EnhancedSubscriptionView()
            .environmentObject(SubscriptionManager())
    }
}
