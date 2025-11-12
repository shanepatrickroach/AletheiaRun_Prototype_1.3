//
//  SubscriptionDetailSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//


//
//  SubscriptionSheets.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

// MARK: - Subscription Detail Sheet
/// Detailed view of a single subscription with management options
struct SubscriptionDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    let subscription: Subscription
    
    @State private var showingCancelAlert = false
    @State private var showingAssignSheet = false
    @State private var showingPaymentSheet = false
    @State private var cancelImmediately = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Subscription header
                        subscriptionHeader
                        
                        // Details section
                        detailsSection
                        
//                        // Payment section (if applicable)
//                        if subscription.type != .trial {
//                            paymentSection
//                        }
                        
                        // Assignment section
                        assignmentSection
                        
                        // Actions section
                        actionsSection
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Subscription Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
        .sheet(isPresented: $showingAssignSheet) {
            AssignSubscriptionSheet(subscription: subscription)
        }
        .sheet(isPresented: $showingPaymentSheet) {
            UpdatePaymentSheet(subscription: subscription)
        }
        .alert("Cancel Subscription?", isPresented: $showingCancelAlert) {
            Button("Cancel", role: .cancel) {}
            
            if !cancelImmediately {
                Button("Cancel at Period End", role: .destructive) {
                    Task {
                        try? await subscriptionManager.cancelSubscription(
                            subscriptionID: subscription.id,
                            immediately: false
                        )
                        dismiss()
                    }
                }
            }
            
            Button("Cancel Immediately", role: .destructive) {
                Task {
                    try? await subscriptionManager.cancelSubscription(
                        subscriptionID: subscription.id,
                        immediately: true
                    )
                    dismiss()
                }
            }
        } message: {
            Text(cancelImmediately ?
                "Your subscription will be cancelled immediately and you'll lose access to all features." :
                "Your subscription will be cancelled at the end of the current billing period.")
        }
    }
    
    // MARK: - Subscription Header
    private var subscriptionHeader: some View {
        VStack(spacing: Spacing.m) {
            // Status icon
            ZStack {
                Circle()
                    .fill(Color(hex: subscription.status.color).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: subscription.status.icon)
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: subscription.status.color))
            }
            
            // Subscription type
            Text(subscription.type.rawValue)
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            // Status badge
            Text(subscription.status.rawValue)
                .font(.bodyMedium)
                .foregroundColor(Color(hex: subscription.status.color))
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xs)
                .background(Color(hex: subscription.status.color).opacity(0.2))
                .cornerRadius(CornerRadius.medium)
            
            // Price (if not trial)
            if subscription.type != .trial {
                VStack(spacing: Spacing.xxs) {
                    HStack(alignment: .firstTextBaseline, spacing: Spacing.xxs) {
                        Text("$239")
                            .font(.titleMedium)
                            .foregroundColor(.primaryOrange)
                        
                        Text("per year")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text("Just $19.92 per month")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
    }
    
    // MARK: - Details Section
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Subscription Details")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                SubscriptionDetailSheetRow(
                    icon: "calendar",
                    label: "Start Date",
                    value: subscription.startDate.formatted(date: .long, time: .omitted)
                )
                
                SubscriptionDetailSheetRow(
                    icon: subscription.status == .trial ? "hourglass" : "calendar.badge.clock",
                    label: subscription.status == .trial ? "Trial Ends" : "Renews On",
                    value: subscription.endDate.formatted(date: .long, time: .omitted),
                    valueColor: subscription.isExpiringSoon ? .warningYellow : .textPrimary
                )
                
                if subscription.daysRemaining > 0 {
                    SubscriptionDetailSheetRow(
                        icon: "clock",
                        label: "Days Remaining",
                        value: "\(subscription.daysRemaining) days",
                        valueColor: subscription.isExpiringSoon ? .warningYellow : .textPrimary
                    )
                }
                
                if subscription.status == .pendingCancellation,
                   let cancelDate = subscription.cancelledDate {
                    SubscriptionDetailSheetRow(
                        icon: "xmark.circle",
                        label: "Cancellation Requested",
                        value: cancelDate.formatted(date: .abbreviated, time: .omitted),
                        valueColor: .warningYellow
                    )
                }
                
                if subscription.willConvertToAnnual,
                   let conversionDate = subscription.conversionDate {
                    SubscriptionDetailSheetRow(
                        icon: "arrow.triangle.2.circlepath",
                        label: "Converts to Annual",
                        value: conversionDate.formatted(date: .abbreviated, time: .omitted),
                        valueColor: .infoBlue
                    )
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    // MARK: - Payment Section
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Payment Information")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                if let paymentLast4 = subscription.paymentMethodLast4 {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.infoBlue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Payment Method")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text("•••• \(paymentLast4)")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingPaymentSheet = true
                        }) {
                            Text("Update")
                                .font(.bodySmall)
                                .foregroundColor(.primaryOrange)
                        }
                    }
                }
                
                if let lastBilling = subscription.lastBillingDate {
                    HStack {
                        Image(systemName: "calendar.badge.checkmark")
                            .foregroundColor(.successGreen)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Last Billing")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text(lastBilling.formatted(date: .abbreviated, time: .omitted))
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    // MARK: - Assignment Section
    private var assignmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Assignment")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if subscription.isAssigned {
                // Currently assigned
                VStack(spacing: Spacing.m) {
                    HStack(spacing: Spacing.m) {
                        ZStack {
                            Circle()
                                .fill(Color.infoBlue.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.infoBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(subscription.assignedUserName ?? "Unknown")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .fontWeight(.semibold)
                            
                            Text(subscription.assignedUserEmail ?? "")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            if let assignmentDate = subscription.assignmentDate {
                                Text("Assigned \(assignmentDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        Task {
                            try? await subscriptionManager.revokeAssignment(subscriptionID: subscription.id)
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Revoke Assignment")
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.errorRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(Color.errorRed.opacity(0.1))
                        .cornerRadius(CornerRadius.medium)
                    }
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
            } else if subscription.canBeAssigned {
                // Can be assigned
                Button(action: {
                    showingAssignSheet = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Assign to Someone")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                }
            } else {
                Text("This subscription cannot be assigned")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .padding(Spacing.m)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
            }
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: Spacing.m) {
            if subscription.status == .trial && subscription.willConvertToAnnual {
                // Cancel auto-conversion
                Button(action: {
                    // Cancel conversion to annual
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Cancel Auto-Conversion")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.warningYellow)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(Color.warningYellow.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                }
            }
            
            if subscription.status == .active || subscription.status == .trial {
                // Cancel subscription
                Button(action: {
                    showingCancelAlert = true
                }) {
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
            
            if subscription.status == .pendingCancellation {
                // Reactivate
                Button(action: {
                    Task {
                        try? await subscriptionManager.reactivateSubscription(subscriptionID: subscription.id)
                        dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                        Text("Reactivate Subscription")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.successGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(Color.successGreen.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                }
            }
        }
    }
}

// MARK: - Detail Row Component
struct SubscriptionDetailSheetRow: View {
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

// MARK: - Assign Subscription Sheet
struct AssignSubscriptionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    let subscription: Subscription
    
    @State private var recipientEmail: String = ""
    @State private var personalMessage: String = ""
    @State private var isAssigning: Bool = false
    @State private var showingSuccessAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        VStack(spacing: Spacing.m) {
                            ZStack {
                                Circle()
                                    .fill(Color.infoBlue.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.infoBlue)
                            }
                            
                            Text("Assign Subscription")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                            
                            Text("Share your subscription with someone else")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Form
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            // Recipient email
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Recipient Email")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                
                                TextField("email@example.com", text: $recipientEmail)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .padding(Spacing.m)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            }
                            
                            // Personal message (optional)
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Personal Message (Optional)")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                
                                TextEditor(text: $personalMessage)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .frame(height: 100)
                                    .padding(Spacing.s)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            }
                        }
                        
                        // Info box
                        HStack(alignment: .top, spacing: Spacing.m) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.infoBlue)
                            
                            VStack(alignment: .leading, spacing: Spacing.xxs) {
                                Text("Important")
                                    .font(.bodySmall)
                                    .foregroundColor(.textPrimary)
                                    .fontWeight(.semibold)
                                
                                Text("The recipient will receive a notification and email. You can revoke access at any time.")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(Spacing.m)
                        .background(Color.infoBlue.opacity(0.1))
                        .cornerRadius(CornerRadius.medium)
                        
                        Spacer()
                        
                        // Assign button
                        Button(action: assignSubscription) {
                            if isAssigning {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .backgroundBlack))
                            } else {
                                Text("Assign Subscription")
                            }
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(recipientEmail.isEmpty ? Color.textTertiary : Color.primaryOrange)
                        .cornerRadius(CornerRadius.medium)
                        .disabled(recipientEmail.isEmpty || isAssigning)
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Assign Subscription")
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
        .alert("Subscription Assigned!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your subscription has been assigned to \(recipientEmail). They will receive a notification shortly.")
        }
    }
    
    private func assignSubscription() {
        isAssigning = true
        
        Task {
            try? await subscriptionManager.assignSubscription(
                subscriptionID: subscription.id,
                recipientEmail: recipientEmail,
                message: personalMessage.isEmpty ? nil : personalMessage
            )
            
            await MainActor.run {
                isAssigning = false
                showingSuccessAlert = true
            }
        }
    }
}

// MARK: - Update Payment Sheet
struct UpdatePaymentSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    let subscription: Subscription
    
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    @State private var isUpdating: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        VStack(spacing: Spacing.m) {
                            ZStack {
                                Circle()
                                    .fill(Color.infoBlue.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.infoBlue)
                            }
                            
                            Text("Update Payment Method")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                        }
                        
                        // Form
                        VStack(spacing: Spacing.m) {
                            // Card number
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Card Number")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                
                                TextField("1234 5678 9012 3456", text: $cardNumber)
                                    .keyboardType(.numberPad)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .padding(Spacing.m)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            }
                            
                            HStack(spacing: Spacing.m) {
                                // Expiry
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("Expiry")
                                        .font(.bodySmall)
                                        .foregroundColor(.textSecondary)
                                    
                                    TextField("MM/YY", text: $expiryDate)
                                        .keyboardType(.numberPad)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                        .padding(Spacing.m)
                                        .background(Color.cardBackground)
                                        .cornerRadius(CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                }
                                
                                // CVV
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("CVV")
                                        .font(.bodySmall)
                                        .foregroundColor(.textSecondary)
                                    
                                    TextField("123", text: $cvv)
                                        .keyboardType(.numberPad)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                        .padding(Spacing.m)
                                        .background(Color.cardBackground)
                                        .cornerRadius(CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Update button
                        Button(action: updatePayment) {
                            if isUpdating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .backgroundBlack))
                            } else {
                                Text("Update Payment Method")
                            }
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(cardNumber.isEmpty ? Color.textTertiary : Color.primaryOrange)
                        .cornerRadius(CornerRadius.medium)
                        .disabled(cardNumber.isEmpty || isUpdating)
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Update Payment")
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
    
    private func updatePayment() {
        isUpdating = true
        
        Task {
            // Get last 4 digits
            let last4 = String(cardNumber.suffix(4))
            
            try? await subscriptionManager.updatePaymentMethod(
                subscriptionID: subscription.id,
                paymentMethodLast4: last4
            )
            
            await MainActor.run {
                isUpdating = false
                dismiss()
            }
        }
    }
}

// MARK: - Preview
#Preview("Subscription Detail") {
    SubscriptionDetailSheet(subscription: Subscription.sampleSubscriptions[0])
        .environmentObject(SubscriptionManager())
}

#Preview("Assign Subscription") {
    AssignSubscriptionSheet(subscription: Subscription.sampleSubscriptions[0])
        .environmentObject(SubscriptionManager())
}
