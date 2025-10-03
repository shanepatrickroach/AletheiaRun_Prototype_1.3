//
//  PopupType.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//


// Core/Components/GenericPopup.swift
import SwiftUI

// MARK: - Popup Types
enum PopupType {
    case info
    case success
    case warning
    case error
    case confirmation
    
    var iconName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .confirmation: return "questionmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .info: return Color.infoBlue
        case .success: return Color.successGreen
        case .warning: return Color.warningYellow
        case .error: return Color.errorRed
        case .confirmation: return Color.primaryOrange
        }
    }
}

// MARK: - Popup Configuration
struct PopupConfig {
    let type: PopupType
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryButtonAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryButtonAction: (() -> Void)?
    
    init(
        type: PopupType,
        title: String,
        message: String,
        primaryButtonTitle: String = "OK",
        primaryButtonAction: @escaping () -> Void = {},
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAction = secondaryButtonAction
    }
}

// MARK: - Generic Popup View
struct GenericPopup: View {
    let config: PopupConfig
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPresented = false
                    }
                }
            
            // Popup card
            VStack(spacing: Spacing.l) {
                // Icon
                Image(systemName: config.type.iconName)
                    .font(.system(size: 48))
                    .foregroundColor(config.type.iconColor)
                
                // Title
                Text(config.title)
                    .font(Font.titleMedium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Message
                Text(config.message)
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Buttons
                VStack(spacing: Spacing.s) {
                    // Primary button
                    PrimaryButton(title: config.primaryButtonTitle) {
                        config.primaryButtonAction()
                        withAnimation(.easeOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }
                    
                    // Secondary button (optional)
                    if let secondaryTitle = config.secondaryButtonTitle,
                       let secondaryAction = config.secondaryButtonAction {
                        SecondaryButton(title: secondaryTitle) {
                            secondaryAction()
                            withAnimation(.easeOut(duration: 0.2)) {
                                isPresented = false
                            }
                        }
                    }
                }
                .padding(.top, Spacing.s)
            }
            .padding(Spacing.xl)
            .frame(maxWidth: 340)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
}

// MARK: - View Extension for Popup
extension View {
    func popup(isPresented: Binding<Bool>, config: PopupConfig) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                GenericPopup(config: config, isPresented: isPresented)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    .zIndex(999)
            }
        }
    }
}

// MARK: - Preview
struct GenericPopup_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Background Content")
        }
        .popup(
            isPresented: .constant(true),
            config: PopupConfig(
                type: .success,
                title: "Achievement Unlocked!",
                message: "You've completed your first 5K run. Keep up the great work!",
                primaryButtonTitle: "Awesome!",
                secondaryButtonTitle: "View Progress",
                secondaryButtonAction: {}
            )
        )
        .preferredColorScheme(.dark)
    }
}
