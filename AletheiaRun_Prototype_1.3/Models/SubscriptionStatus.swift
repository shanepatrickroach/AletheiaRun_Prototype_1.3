//
//  SubscriptionStatus.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//


//
//  Subscription.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import Foundation

// MARK: - Subscription Status
/// Represents the current state of a subscription
enum SubscriptionStatus: String, Codable, CaseIterable {
    case active = "Active"
    case trial = "Trial"
    case expired = "Expired"
    case cancelled = "Cancelled"
    case pendingCancellation = "Pending Cancellation"
    
    var color: String {
        switch self {
        case .active: return "4ADE80" // Success Green
        case .trial: return "60A5FA" // Info Blue
        case .expired: return "808080" // Text Tertiary
        case .cancelled: return "F87171" // Error Red
        case .pendingCancellation: return "FCD34D" // Warning Yellow
        }
    }
    
    var icon: String {
        switch self {
        case .active: return "checkmark.circle.fill"
        case .trial: return "gift.fill"
        case .expired: return "xmark.circle.fill"
        case .cancelled: return "xmark.circle"
        case .pendingCancellation: return "clock.fill"
        }
    }
}

// MARK: - Subscription Type
/// Different subscription plan types
enum SubscriptionType: String, Codable, CaseIterable {
    case trial = "30-Day Free Trial"
    case annual = "Annual Membership"
    
    var price: Double {
        switch self {
        case .trial: return 0
        case .annual: return 239.00
        }
    }
    
    var displayPrice: String {
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
    
    var duration: TimeInterval {
        switch self {
        case .trial: return 30 * 24 * 60 * 60 // 30 days in seconds
        case .annual: return 365 * 24 * 60 * 60 // 365 days in seconds
        }
    }
}

// MARK: - Subscription Model
/// Main subscription data model
struct Subscription: Identifiable, Codable, Equatable {
    let id: UUID
    let type: SubscriptionType
    var status: SubscriptionStatus
    
    // Primary subscriber (who purchased/controls the subscription)
    let primarySubscriberID: UUID
    let primarySubscriberName: String
    let primarySubscriberEmail: String
    
    // Assigned user (who uses the subscription, could be same as primary)
    var assignedUserID: UUID?
    var assignedUserName: String?
    var assignedUserEmail: String?
    
    // Dates
    var startDate: Date
    var endDate: Date
    var cancelledDate: Date?
    var lastBillingDate: Date?
    var nextBillingDate: Date?
    
    // Assignment tracking
    var assignmentDate: Date?
    var isAssigned: Bool {
        assignedUserID != nil && assignedUserID != primarySubscriberID
    }
    
    // Trial conversion
    var willConvertToAnnual: Bool
    var conversionDate: Date?
    
    // Payment info
    var paymentMethodLast4: String?
    
    // Computed properties
    var daysRemaining: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        return max(0, days)
    }
    
    var isExpiringSoon: Bool {
        daysRemaining <= 7 && daysRemaining > 0
    }
    
    var canBeAssigned: Bool {
        status == .active || status == .trial
    }
    
    var isPrimaryForUser: Bool {
        // Check if current user is the primary subscriber
        // This would be compared against AuthenticationManager.currentUser.id
        return true // Placeholder
    }
    
    // MARK: - Initializer with sensible defaults
    init(
        id: UUID = UUID(),
        type: SubscriptionType,
        status: SubscriptionStatus,
        primarySubscriberID: UUID,
        primarySubscriberName: String,
        primarySubscriberEmail: String,
        assignedUserID: UUID? = nil,
        assignedUserName: String? = nil,
        assignedUserEmail: String? = nil,
        startDate: Date = Date(),
        endDate: Date,
        cancelledDate: Date? = nil,
        lastBillingDate: Date? = nil,
        nextBillingDate: Date? = nil,
        assignmentDate: Date? = nil,
        willConvertToAnnual: Bool = false,
        conversionDate: Date? = nil,
        paymentMethodLast4: String? = nil
    ) {
        self.id = id
        self.type = type
        self.status = status
        self.primarySubscriberID = primarySubscriberID
        self.primarySubscriberName = primarySubscriberName
        self.primarySubscriberEmail = primarySubscriberEmail
        self.assignedUserID = assignedUserID
        self.assignedUserName = assignedUserName
        self.assignedUserEmail = assignedUserEmail
        self.startDate = startDate
        self.endDate = endDate
        self.cancelledDate = cancelledDate
        self.lastBillingDate = lastBillingDate
        self.nextBillingDate = nextBillingDate
        self.assignmentDate = assignmentDate
        self.willConvertToAnnual = willConvertToAnnual
        self.conversionDate = conversionDate
        self.paymentMethodLast4 = paymentMethodLast4
    }
    
    static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Subscription Features
/// Features included in subscriptions
struct SubscriptionFeature: Identifiable, Codable {
    let id: UUID
    let icon: String
    let title: String
    let description: String
    let isIncluded: Bool
    
    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        description: String,
        isIncluded: Bool = true
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.description = description
        self.isIncluded = isIncluded
    }
}

// MARK: - Subscription Assignment Request
/// Model for requesting to assign a subscription to another user
struct SubscriptionAssignmentRequest: Codable {
    let subscriptionID: UUID
    let recipientEmail: String
    let message: String?
    let createdDate: Date
    
    init(
        subscriptionID: UUID,
        recipientEmail: String,
        message: String? = nil,
        createdDate: Date = Date()
    ) {
        self.subscriptionID = subscriptionID
        self.recipientEmail = recipientEmail
        self.message = message
        self.createdDate = createdDate
    }
}

// MARK: - Subscription Notification
/// Notification when a user receives a subscription
struct SubscriptionNotification: Identifiable, Codable {
    let id: UUID
    let subscription: Subscription
    let message: String
    let createdDate: Date
    var isRead: Bool
    var isAccepted: Bool?
    
    init(
        id: UUID = UUID(),
        subscription: Subscription,
        message: String,
        createdDate: Date = Date(),
        isRead: Bool = false,
        isAccepted: Bool? = nil
    ) {
        self.id = id
        self.subscription = subscription
        self.message = message
        self.createdDate = createdDate
        self.isRead = isRead
        self.isAccepted = isAccepted
    }
}

// MARK: - Sample Data
extension Subscription {
    /// Create sample subscriptions for testing
    static var sampleSubscriptions: [Subscription] {
        let calendar = Calendar.current
        let now = Date()
        
        let primaryUserID = UUID()
        
        return [
            // Active annual subscription (self)
            Subscription(
                type: .annual,
                status: .active,
                primarySubscriberID: primaryUserID,
                primarySubscriberName: "John Doe",
                primarySubscriberEmail: "john@example.com",
                assignedUserID: primaryUserID,
                assignedUserName: "John Doe",
                assignedUserEmail: "john@example.com",
                startDate: calendar.date(byAdding: .month, value: -3, to: now)!,
                endDate: calendar.date(byAdding: .month, value: 9, to: now)!,
                lastBillingDate: calendar.date(byAdding: .month, value: -3, to: now)!,
                nextBillingDate: calendar.date(byAdding: .month, value: 9, to: now)!,
                paymentMethodLast4: "4242"
            ),
            
            // Active annual subscription (assigned to someone else)
            Subscription(
                type: .annual,
                status: .active,
                primarySubscriberID: primaryUserID,
                primarySubscriberName: "John Doe",
                primarySubscriberEmail: "john@example.com",
                assignedUserID: UUID(),
                assignedUserName: "Jane Smith",
                assignedUserEmail: "jane@example.com",
                startDate: calendar.date(byAdding: .month, value: -2, to: now)!,
                endDate: calendar.date(byAdding: .month, value: 10, to: now)!,
                assignmentDate: calendar.date(byAdding: .month, value: -2, to: now)!,
                paymentMethodLast4: "4242"
            ),
            
            // Trial subscription (unassigned)
            Subscription(
                type: .trial,
                status: .trial,
                primarySubscriberID: primaryUserID,
                primarySubscriberName: "John Doe",
                primarySubscriberEmail: "john@example.com",
                startDate: calendar.date(byAdding: .day, value: -15, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 15, to: now)!,
                willConvertToAnnual: true,
                conversionDate: calendar.date(byAdding: .day, value: 15, to: now)!
            )
        ]
    }
}

extension SubscriptionFeature {
    /// Standard features included in all subscriptions
    static var standardFeatures: [SubscriptionFeature] {
        [
            SubscriptionFeature(
                icon: "sensor",
                title: "Aletheia Sensor",
                description: "Professional-grade running sensor included"
            ),
            SubscriptionFeature(
                icon: "infinity",
                title: "Unlimited App Access",
                description: "Full access to the Aletheia Run App"
            ),
            SubscriptionFeature(
                icon: "waveform.path.ecg",
                title: "Real-time Insights",
                description: "Get instant feedback after every run"
            ),
            SubscriptionFeature(
                icon: "figure.run",
                title: "Personalized Training",
                description: "Movement corrections & custom training plans"
            ),
            SubscriptionFeature(
                icon: "sparkles",
                title: "New Features",
                description: "Latest updates & live support included"
            )
        ]
    }
}
