//
//  SubscriptionNotificationBanner.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/3/25.
//


//
//  SubscriptionNotificationViews.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

// MARK: - Subscription Notification Banner
/// Banner that appears when a user receives a subscription
struct SubscriptionNotificationBanner: View {
    let notification: SubscriptionNotification
    let onAccept: () -> Void
    let onDecline: () -> Void
    let onDismiss: () -> Void
    
    @State private var offset: CGFloat = -200
    @State private var isVisible: Bool = true
    
    var body: some View {
        if isVisible {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: Spacing.m) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.primaryOrange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "gift.fill")
                            .font(.title3)
                            .foregroundColor(.primaryOrange)
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("New Subscription!")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text(notification.message)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                        
                        // Action buttons
                        HStack(spacing: Spacing.m) {
                            Button(action: {
                                withAnimation {
                                    isVisible = false
                                }
                                onAccept()
                            }) {
                                Text("Accept")
                                    .font(.bodySmall)
                                    .foregroundColor(.backgroundBlack)
                                    .padding(.horizontal, Spacing.m)
                                    .padding(.vertical, Spacing.xs)
                                    .background(Color.primaryOrange)
                                    .cornerRadius(CornerRadius.small)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    isVisible = false
                                }
                                onDecline()
                            }) {
                                Text("Decline")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                    .padding(.horizontal, Spacing.m)
                                    .padding(.vertical, Spacing.xs)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.small)
                            }
                        }
                        .padding(.top, Spacing.xs)
                    }
                    
                    Spacer()
                    
                    // Dismiss button
                    Button(action: {
                        withAnimation {
                            isVisible = false
                        }
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                            .padding(Spacing.xs)
                            .background(Color.cardBackground)
                            .clipShape(Circle())
                    }
                }
                .padding(Spacing.m)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.primaryOrange.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, Spacing.m)
                .offset(y: offset)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        offset = 0
                    }
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

// MARK: - Notification Center View
/// View showing all subscription notifications
struct SubscriptionNotificationCenterView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            if subscriptionManager.notifications.isEmpty {
                // Empty state
                emptyState
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.m) {
                        ForEach(subscriptionManager.notifications) { notification in
                            NotificationCard(notification: notification)
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !subscriptionManager.notifications.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        subscriptionManager.notifications.removeAll()
                    }
                    .font(.bodySmall)
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.l) {
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.textTertiary)
            }
            
            VStack(spacing: Spacing.xs) {
                Text("No Notifications")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("You're all caught up!")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Notification Card
struct NotificationCard: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    let notification: SubscriptionNotification
    
    @State private var showingDetail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header
            HStack(alignment: .top, spacing: Spacing.m) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "gift.fill")
                        .font(.title3)
                        .foregroundColor(.primaryOrange)
                }
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text("Subscription Gift")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.semibold)
                        
                        if !notification.isRead {
                            Circle()
                                .fill(Color.primaryOrange)
                                .frame(width: 8, height: 8)
                        }
                        
                        Spacer()
                        
                        Text(timeAgo(from: notification.createdDate))
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    
                    Text(notification.message)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(3)
                    
                    // Subscription details
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        
                        Text("From \(notification.subscription.primarySubscriberName)")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Actions
            if notification.isAccepted == nil {
                HStack(spacing: Spacing.m) {
                    Button(action: {
                        Task {
                            try? await subscriptionManager.acceptSubscription(notificationID: notification.id)
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Accept")
                        }
                        .font(.bodySmall)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        .background(Color.successGreen)
                        .cornerRadius(CornerRadius.small)
                    }
                    
                    Button(action: {
                        Task {
                            try? await subscriptionManager.declineSubscription(notificationID: notification.id)
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Decline")
                        }
                        .font(.bodySmall)
                        .foregroundColor(.errorRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        .background(Color.errorRed.opacity(0.1))
                        .cornerRadius(CornerRadius.small)
                    }
                }
            } else {
                HStack {
                    Image(systemName: notification.isAccepted == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(notification.isAccepted == true ? .successGreen : .errorRed)
                    
                    Text(notification.isAccepted == true ? "Accepted" : "Declined")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Button("View Details") {
                        showingDetail = true
                    }
                    .font(.bodySmall)
                    .foregroundColor(.primaryOrange)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(notification.isRead ? Color.cardBorder : Color.primaryOrange.opacity(0.5), lineWidth: 1)
        )
        .onTapGesture {
            subscriptionManager.markNotificationAsRead(notificationID: notification.id)
        }
        .sheet(isPresented: $showingDetail) {
            SubscriptionDetailSheet(subscription: notification.subscription)
        }
    }
    
    // MARK: - Time Ago Helper
    private func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
        } else if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Notification Badge
/// Badge showing notification count
struct NotificationBadge: View {
    let count: Int
    
    var body: some View {
        if count > 0 {
            ZStack {
                Circle()
                    .fill(Color.errorRed)
                    .frame(width: 20, height: 20)
                
                Text("\(min(count, 99))")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Notification Button
/// Button to open notification center
struct NotificationButton: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showingNotifications: Bool = false
    
    var body: some View {
        Button(action: {
            showingNotifications = true
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundColor(.textPrimary)
                
                NotificationBadge(count: subscriptionManager.unreadNotificationCount)
                    .offset(x: 8, y: -8)
            }
        }
        .sheet(isPresented: $showingNotifications) {
            NavigationView {
                SubscriptionNotificationCenterView()
            }
        }
    }
}

// MARK: - Preview
#Preview("Notification Banner") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        VStack {
            SubscriptionNotificationBanner(
                notification: SubscriptionNotification(
                    subscription: Subscription.sampleSubscriptions[0],
                    message: "You've been gifted a subscription by John Doe!"
                ),
                onAccept: {},
                onDecline: {},
                onDismiss: {}
            )
            
            Spacer()
        }
    }
}

#Preview("Notification Center") {
    NavigationStack {
        SubscriptionNotificationCenterView()
            .environmentObject(SubscriptionManager())
    }
}