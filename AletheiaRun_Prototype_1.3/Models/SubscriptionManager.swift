//
//  SubscriptionManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//


//
//  SubscriptionManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

/// Manages all subscription-related operations
class SubscriptionManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var subscriptions: [Subscription] = []
    @Published var notifications: [SubscriptionNotification] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    
    /// Get all subscriptions where current user is the primary subscriber
    var ownedSubscriptions: [Subscription] {
        subscriptions.filter { subscription in
            // In real app, compare with AuthenticationManager.currentUser.id
            subscription.isPrimaryForUser
        }
    }
    
    /// Get all subscriptions assigned to current user (including own)
    var activeSubscriptions: [Subscription] {
        subscriptions.filter { subscription in
            subscription.status == .active || subscription.status == .trial
        }
    }
    
    /// Get subscriptions assigned to other users
    var assignedToOthers: [Subscription] {
        subscriptions.filter { $0.isAssigned }
    }
    
    /// Get unread notification count
    var unreadNotificationCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    /// Check if user has any active subscription
    var hasActiveSubscription: Bool {
        !activeSubscriptions.isEmpty
    }
    
    // MARK: - Initialization
    init() {
        loadSampleData()
    }
    
    // MARK: - Load Data
    /// Load subscriptions from backend (currently using sample data)
    func loadSubscriptions() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            // In real app, fetch from API
            self.subscriptions = Subscription.sampleSubscriptions
            isLoading = false
        }
    }
    
    /// Load sample data for testing
    func loadSampleData() {
        subscriptions = Subscription.sampleSubscriptions
        
        // Create a sample notification
        if let firstSubscription = subscriptions.first {
            let notification = SubscriptionNotification(
                subscription: firstSubscription,
                message: "You've been gifted a subscription by \(firstSubscription.primarySubscriberName)!",
                isRead: false
            )
            notifications.append(notification)
        }
    }
    
    // MARK: - Purchase Subscription
    /// Purchase a new subscription
    func purchaseSubscription(
        type: SubscriptionType,
        paymentMethodLast4: String
    ) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let calendar = Calendar.current
        let now = Date()
        
        // Create new subscription
        let newSubscription = Subscription(
            type: type,
            status: type == .trial ? .trial : .active,
            primarySubscriberID: UUID(), // In real app: AuthenticationManager.currentUser.id
            primarySubscriberName: "Current User", // In real app: from auth
            primarySubscriberEmail: "user@example.com", // In real app: from auth
            assignedUserID: UUID(), // Assign to self initially
            assignedUserName: "Current User",
            assignedUserEmail: "user@example.com",
            startDate: now,
            endDate: calendar.date(
                byAdding: .second,
                value: Int(type.duration),
                to: now
            )!,
            lastBillingDate: now,
            nextBillingDate: calendar.date(
                byAdding: .second,
                value: Int(type.duration),
                to: now
            )!,
            willConvertToAnnual: type == .trial,
            conversionDate: type == .trial ? calendar.date(
                byAdding: .day,
                value: 30,
                to: now
            ) : nil,
            paymentMethodLast4: paymentMethodLast4
        )
        
        await MainActor.run {
            subscriptions.append(newSubscription)
            isLoading = false
        }
    }
    
    // MARK: - Assign Subscription
    /// Assign a subscription to another user
    func assignSubscription(
        subscriptionID: UUID,
        recipientEmail: String,
        message: String?
    ) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        // Check if subscription can be assigned
        guard subscriptions[index].canBeAssigned else {
            await MainActor.run {
                errorMessage = "This subscription cannot be assigned"
                isLoading = false
            }
            return
        }
        
        await MainActor.run {
            // Update subscription with assignment info
            subscriptions[index].assignedUserID = UUID() // In real app: look up user by email
            subscriptions[index].assignedUserName = "Recipient Name" // From API
            subscriptions[index].assignedUserEmail = recipientEmail
            subscriptions[index].assignmentDate = Date()
            
            // Create notification for recipient
            let notification = SubscriptionNotification(
                subscription: subscriptions[index],
                message: message ?? "You've been gifted a subscription to Aletheia Run!",
                isRead: false
            )
            
            // In real app, this would be sent to the recipient's notification queue
            notifications.append(notification)
            
            isLoading = false
        }
    }
    
    // MARK: - Revoke Assignment
    /// Revoke a subscription assignment
    func revokeAssignment(subscriptionID: UUID) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        await MainActor.run {
            // Clear assignment
            subscriptions[index].assignedUserID = nil
            subscriptions[index].assignedUserName = nil
            subscriptions[index].assignedUserEmail = nil
            subscriptions[index].assignmentDate = nil
            
            isLoading = false
        }
    }
    
    // MARK: - Cancel Subscription
    /// Cancel a subscription
    func cancelSubscription(subscriptionID: UUID, immediately: Bool = false) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        await MainActor.run {
            if immediately {
                // Cancel immediately
                subscriptions[index].status = .cancelled
                subscriptions[index].cancelledDate = Date()
                subscriptions[index].endDate = Date()
            } else {
                // Cancel at end of period
                subscriptions[index].status = .pendingCancellation
                subscriptions[index].cancelledDate = Date()
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Reactivate Subscription
    /// Reactivate a cancelled subscription
    func reactivateSubscription(subscriptionID: UUID) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        await MainActor.run {
            subscriptions[index].status = .active
            subscriptions[index].cancelledDate = nil
            
            isLoading = false
        }
    }
    
    // MARK: - Mark Notification as Read
    /// Mark a notification as read
    func markNotificationAsRead(notificationID: UUID) {
        if let index = notifications.firstIndex(where: { $0.id == notificationID }) {
            notifications[index].isRead = true
        }
    }
    
    // MARK: - Accept Subscription
    /// Accept an assigned subscription
    func acceptSubscription(notificationID: UUID) async throws {
        guard let index = notifications.firstIndex(where: { $0.id == notificationID }) else {
            return
        }
        
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            notifications[index].isAccepted = true
            notifications[index].isRead = true
            isLoading = false
        }
    }
    
    // MARK: - Decline Subscription
    /// Decline an assigned subscription
    func declineSubscription(notificationID: UUID) async throws {
        guard let notificationIndex = notifications.firstIndex(where: { $0.id == notificationID }) else {
            return
        }
        
        let subscriptionID = notifications[notificationIndex].subscription.id
        
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Revoke the assignment
        try await revokeAssignment(subscriptionID: subscriptionID)
        
        await MainActor.run {
            notifications[notificationIndex].isAccepted = false
            notifications[notificationIndex].isRead = true
            isLoading = false
        }
    }
    
    // MARK: - Update Payment Method
    /// Update payment method for a subscription
    func updatePaymentMethod(
        subscriptionID: UUID,
        paymentMethodLast4: String
    ) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        await MainActor.run {
            subscriptions[index].paymentMethodLast4 = paymentMethodLast4
            isLoading = false
        }
    }
    
    // MARK: - Convert Trial to Annual
    /// Convert a trial subscription to annual
    func convertTrialToAnnual(subscriptionID: UUID) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard let index = subscriptions.firstIndex(where: { $0.id == subscriptionID }) else {
            await MainActor.run {
                errorMessage = "Subscription not found"
                isLoading = false
            }
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        await MainActor.run {
            // Convert to annual
            subscriptions[index].status = .active
            subscriptions[index].endDate = calendar.date(
                byAdding: .year,
                value: 1,
                to: now
            )!
            subscriptions[index].willConvertToAnnual = false
            subscriptions[index].conversionDate = nil
            subscriptions[index].lastBillingDate = now
            subscriptions[index].nextBillingDate = calendar.date(
                byAdding: .year,
                value: 1,
                to: now
            )!
            
            isLoading = false
        }
    }
}