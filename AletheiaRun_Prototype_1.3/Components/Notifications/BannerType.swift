//
//  BannerType.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/6/25.
//


//
//  BannerSystem.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI

// MARK: - Banner Type
/// Different types of banners for various use cases
enum BannerType {
    // Informational
    case info
    case tip
    case announcement
    case tutorial
    
    // Status
    case success
    case warning
    case error
    case loading
    
    // Action Required
    case action
    case upgrade
    case subscription
    
    // Engagement
    case achievement
    case milestone
    case social
    case challenge
    
    // System
    case maintenance
    case update
    case connection
    case sensor
    
    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .tip: return "lightbulb.fill"
        case .announcement: return "megaphone.fill"
        case .tutorial: return "graduationcap.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .loading: return "arrow.clockwise"
        case .action: return "hand.tap.fill"
        case .upgrade: return "arrow.up.circle.fill"
        case .subscription: return "crown.fill"
        case .achievement: return "trophy.fill"
        case .milestone: return "star.fill"
        case .social: return "person.2.fill"
        case .challenge: return "flame.fill"
        case .maintenance: return "wrench.fill"
        case .update: return "arrow.down.circle.fill"
        case .connection: return "wifi.slash"
        case .sensor: return "sensor.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .info, .tutorial: return .infoBlue
        case .tip: return .warningYellow
        case .announcement: return .primaryOrange
        case .success, .achievement: return .successGreen
        case .warning, .action: return .warningYellow
        case .error, .connection: return .errorRed
        case .loading: return .textSecondary
        case .upgrade, .subscription: return Color(hex: "FFD700")
        case .milestone: return .primaryOrange
        case .social: return .infoBlue
        case .challenge: return Color(hex: "FF6B35")
        case .maintenance: return .textSecondary
        case .update: return .infoBlue
        case .sensor: return .primaryOrange
        }
    }
}

// MARK: - Banner Model
struct Banner: Identifiable {
    let id: UUID = UUID()
    let type: BannerType
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    var dismissible: Bool = true
    var autoDismiss: TimeInterval? = nil
    
    init(
        type: BannerType,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        dismissible: Bool = true,
        autoDismiss: TimeInterval? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
        self.dismissible = dismissible
        self.autoDismiss = autoDismiss
    }
}

// MARK: - Banner View
struct BannerView: View {
    let banner: Banner
    let onDismiss: () -> Void
    
    @State private var isVisible: Bool = true
    @State private var offset: CGFloat = -100
    
    var body: some View {
        if isVisible {
            HStack(alignment: .top, spacing: Spacing.m) {
                // Icon
                ZStack {
                    Circle()
                        .fill(banner.type.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: banner.type.icon)
                        .font(.body)
                        .foregroundColor(banner.type.color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(banner.title)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(banner.message)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Action button (if provided)
                    if let actionTitle = banner.actionTitle, let action = banner.action {
                        Button(action: {
                            action()
                            dismiss()
                        }) {
                            Text(actionTitle)
                                .font(.bodySmall)
                                .foregroundColor(banner.type.color)
                                .fontWeight(.semibold)
                                .padding(.top, Spacing.xxs)
                        }
                    }
                }
                
                Spacer()
                
                // Dismiss button
                if banner.dismissible {
                    Button(action: dismiss) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                            .padding(Spacing.xs)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(banner.type.color.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            .padding(.horizontal, Spacing.m)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    offset = 0
                }
                
                // Auto dismiss if specified
                if let autoDismiss = banner.autoDismiss {
                    DispatchQueue.main.asyncAfter(deadline: .now() + autoDismiss) {
                        dismiss()
                    }
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private func dismiss() {
        withAnimation {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Inline Banner (For in-screen use)
struct InlineBanner: View {
    let banner: Banner
    var onDismiss: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            // Icon
            Image(systemName: banner.type.icon)
                .font(.title3)
                .foregroundColor(banner.type.color)
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(banner.title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(banner.message)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Action button
                if let actionTitle = banner.actionTitle, let action = banner.action {
                    Button(action: action) {
                        HStack {
                            Text(actionTitle)
                                .font(.bodySmall)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                        .foregroundColor(banner.type.color)
                        .padding(.top, Spacing.xs)
                    }
                }
            }
            
            Spacer()
            
            // Dismiss button
            if banner.dismissible, let dismiss = onDismiss {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(banner.type.color.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(banner.type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Banner Manager
class BannerManager: ObservableObject {
    @Published var currentBanner: Banner?
    private var bannerQueue: [Banner] = []
    
    func show(_ banner: Banner) {
        if currentBanner != nil {
            // Queue banner if one is already showing
            bannerQueue.append(banner)
        } else {
            currentBanner = banner
        }
    }
    
    func dismiss() {
        currentBanner = nil
        
        // Show next banner in queue
        if !bannerQueue.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.currentBanner = self.bannerQueue.removeFirst()
            }
        }
    }
    
    func dismissAll() {
        currentBanner = nil
        bannerQueue.removeAll()
    }
}

// MARK: - Banner Templates
extension Banner {
    
    // MARK: - Informational
    
    static func welcomeNewUser() -> Banner {
        Banner(
            type: .announcement,
            title: "Welcome to Aletheia! 👋",
            message: "Let's get you started with your first run analysis",
            actionTitle: "Start Tutorial",
            action: { /* Start tutorial */ }
        )
    }
    
    static func tipOfTheDay(_ tip: String) -> Banner {
        Banner(
            type: .tip,
            title: "💡 Running Tip",
            message: tip,
            autoDismiss: 5.0
        )
    }
    
    static func newFeature(feature: String, description: String) -> Banner {
        Banner(
            type: .announcement,
            title: "🎉 New: \(feature)",
            message: description,
            actionTitle: "Learn More",
            action: { /* Show feature details */ }
        )
    }
    
    // MARK: - Status
    
    static func runSaved() -> Banner {
        Banner(
            type: .success,
            title: "Run Saved!",
            message: "Your run has been successfully recorded",
            autoDismiss: 3.0
        )
    }
    
    static func syncComplete() -> Banner {
        Banner(
            type: .success,
            title: "Synced Successfully",
            message: "Your data has been backed up to the cloud",
            autoDismiss: 2.5
        )
    }
    
    static func lowBattery(percentage: Int) -> Banner {
        Banner(
            type: .warning,
            title: "Sensor Battery Low",
            message: "Your sensor is at \(percentage)%. Charge it soon to avoid interruptions",
            actionTitle: "View Battery Tips",
            action: { /* Show battery tips */ }
        )
    }
    
    static func noConnection() -> Banner {
        Banner(
            type: .error,
            title: "No Internet Connection",
            message: "Some features may be limited. Data will sync when connection is restored",
            dismissible: false
        )
    }
    
    static func sensorDisconnected() -> Banner {
        Banner(
            type: .sensor,
            title: "Sensor Disconnected",
            message: "Trying to reconnect...",
            actionTitle: "Reconnect Now",
            action: { /* Attempt reconnection */ },
            dismissible: false
        )
    }
    
    // MARK: - Action Required
    
    static func trialEnding(daysLeft: Int) -> Banner {
        Banner(
            type: .subscription,
            title: "Trial Ending Soon",
            message: "Only \(daysLeft) days left in your trial. Subscribe to keep full access",
            actionTitle: "View Plans",
            action: { /* Show subscription view */ },
            dismissible: true
        )
    }
    
    static func subscriptionExpired() -> Banner {
        Banner(
            type: .error,
            title: "Subscription Expired",
            message: "Renew your subscription to continue using all features",
            actionTitle: "Renew Now",
            action: { /* Show subscription view */ },
            dismissible: false
        )
    }
    
    static func paymentFailed() -> Banner {
        Banner(
            type: .warning,
            title: "Payment Issue",
            message: "We couldn't process your payment. Update your payment method to avoid service interruption",
            actionTitle: "Update Payment",
            action: { /* Show payment update */ }
        )
    }
    
    static func profileIncomplete() -> Banner {
        Banner(
            type: .action,
            title: "Complete Your Profile",
            message: "Add your height and weight for more accurate metrics",
            actionTitle: "Complete Now",
            action: { /* Show profile edit */ }
        )
    }
    
    // MARK: - Engagement
    
    static func newAchievement(name: String) -> Banner {
        Banner(
            type: .achievement,
            title: "Achievement Unlocked! 🏆",
            message: "You earned: \(name)",
            actionTitle: "View Achievement",
            action: { /* Show achievement detail */ },
            autoDismiss: 4.0
        )
    }
    
    static func personalBest(metric: String) -> Banner {
        Banner(
            type: .milestone,
            title: "New Personal Best! ⭐",
            message: "You just set a new record for \(metric)",
            actionTitle: "View Records",
            action: { /* Show personal bests */ },
            autoDismiss: 4.0
        )
    }
    
    static func streakMilestone(days: Int) -> Banner {
        Banner(
            type: .challenge,
            title: "🔥 \(days) Day Streak!",
            message: "You're on fire! Keep it going",
            autoDismiss: 3.5
        )
    }
    
    static func inviteFriend() -> Banner {
        Banner(
            type: .social,
            title: "Share Your Progress",
            message: "Invite friends to join Aletheia and compare your runs",
            actionTitle: "Invite Friends",
            action: { /* Show invite screen */ }
        )
    }
    
    static func weeklyChallenge(description: String) -> Banner {
        Banner(
            type: .challenge,
            title: "New Weekly Challenge",
            message: description,
            actionTitle: "Accept Challenge",
            action: { /* Show challenge details */ }
        )
    }
    
    // MARK: - System
    
    static func appUpdate() -> Banner {
        Banner(
            type: .update,
            title: "Update Available",
            message: "A new version of Aletheia is available with bug fixes and improvements",
            actionTitle: "Update Now",
            action: { /* Open App Store */ }
        )
    }
    
    static func maintenance() -> Banner {
        Banner(
            type: .maintenance,
            title: "Scheduled Maintenance",
            message: "Cloud sync will be unavailable tonight from 2-4 AM EST",
            dismissible: true
        )
    }
    
    static func permissionNeeded(permission: String) -> Banner {
        Banner(
            type: .action,
            title: "Permission Needed",
            message: "Aletheia needs \(permission) access to function properly",
            actionTitle: "Grant Access",
            action: { /* Open settings */ }
        )
    }
    
    // MARK: - Custom
    
    static func custom(
        type: BannerType,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> Banner {
        Banner(
            type: type,
            title: title,
            message: message,
            actionTitle: actionTitle,
            action: action
        )
    }
}

// MARK: - View Extension for Easy Banner Integration
extension View {
    func bannerOverlay(banner: Binding<Banner?>) -> some View {
        ZStack(alignment: .top) {
            self
            
            if let currentBanner = banner.wrappedValue {
                VStack {
                    BannerView(banner: currentBanner) {
                        banner.wrappedValue = nil
                    }
                    .padding(.top, Spacing.s)
                    
                    Spacer()
                }
                .zIndex(999)
            }
        }
    }
}

// MARK: - Preview
#Preview("Banners Showcase") {
    struct BannerShowcase: View {
        @StateObject private var bannerManager = BannerManager()
        
        var body: some View {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.m) {
                        Text("Banner Templates")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                            .padding(.top, Spacing.xl)
                        
                        // Inline examples
                        VStack(spacing: Spacing.m) {
                            InlineBanner(banner: .welcomeNewUser())
                            InlineBanner(banner: .tipOfTheDay("Increase your cadence to 170-180 steps per minute for better efficiency"))
                            InlineBanner(banner: .lowBattery(percentage: 15))
                            InlineBanner(banner: .newAchievement(name: "Marathon Runner"))
                            InlineBanner(banner: .trialEnding(daysLeft: 3))
                        }
                        
                        // Test buttons
                        Text("Test Overlay Banners")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                            .padding(.top, Spacing.xl)
                        
                        VStack(spacing: Spacing.s) {
                            Button("Show Success") {
                                bannerManager.show(.runSaved())
                            }
                            
                            Button("Show Warning") {
                                bannerManager.show(.lowBattery(percentage: 10))
                            }
                            
                            Button("Show Achievement") {
                                bannerManager.show(.newAchievement(name: "Speed Demon"))
                            }
                            
                            Button("Show Trial Ending") {
                                bannerManager.show(.trialEnding(daysLeft: 5))
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .bannerOverlay(banner: $bannerManager.currentBanner)
        }
    }
    
    return BannerShowcase()
}