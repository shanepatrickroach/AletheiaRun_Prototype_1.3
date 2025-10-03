//
//  FirstTimeUserView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//


import SwiftUI

struct FirstTimeUserView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var verificationState = VerificationState()
    
    var body: some View {
        ZStack {
            Color.backgroundBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                VerificationProgressBar(currentStep: verificationState.currentStep)
                
                // Content
                Group {
                    switch verificationState.currentStep {
                    case .enterEmail:
                        EnterEmailStep(verificationState: verificationState)
                    case .enterCode:
                        EnterCodeStep(verificationState: verificationState)
                    case .setPassword:
                        SetPasswordStep(verificationState: verificationState, authManager: authManager)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if verificationState.currentStep == .enterEmail {
                        dismiss()
                    } else {
                        // Go back to previous step
                        withAnimation {
                            switch verificationState.currentStep {
                            case .enterCode:
                                verificationState.currentStep = .enterEmail
                            case .setPassword:
                                verificationState.currentStep = .enterCode
                            default:
                                break
                            }
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Verification Progress Bar
struct VerificationProgressBar: View {
    let currentStep: VerificationState.VerificationStep
    
    var progress: Double {
        switch currentStep {
        case .enterEmail: return 0.33
        case .enterCode: return 0.66
        case .setPassword: return 1.0
        }
    }
    
    var stepText: String {
        switch currentStep {
        case .enterEmail: return "Step 1 of 3"
        case .enterCode: return "Step 2 of 3"
        case .setPassword: return "Step 3 of 3"
        }
    }
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: 4) {
                Text(stepText)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryOrange)
            }
            .padding(.horizontal, Spacing.l)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.cardBackground)
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.primaryOrange, .primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 4)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.top, Spacing.m)
        .padding(.bottom, Spacing.s)
    }
}

// MARK: - Step 1: Enter Email
struct EnterEmailStep: View {
    @ObservedObject var verificationState: VerificationState
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.m) {
                    Image(systemName: "envelope.badge.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Welcome to Aletheia")
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Run Smarter. Run Longer. Run Faster.")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.l)
                }
                .padding(.top, Spacing.xxxl)
                
                VStack(spacing: Spacing.m) {
                    CustomTextField(
                        placeholder: "Email Address",
                        text: $verificationState.email,
                        icon: "envelope.fill"
                        
                    )
                    
                    if let error = verificationState.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.errorRed)
                            
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.errorRed)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                VStack(spacing: Spacing.m) {
                    if verificationState.isLoading {
                        ProgressView()
                            .tint(.primaryOrange)
                            .frame(height: 60)
                    } else {
                        PrimaryButton(
                            title: "Send Verification Code",
                            action: {
                                withAnimation {
                                    verificationState.sendVerificationCode()
                                }
                            }, isEnabled: isValidEmail(verificationState.email)
                        )
                    }
                }
                .padding(.horizontal, Spacing.l)
                
//                // Info box
//                InfoBox(
//                    icon: "info.circle.fill",
//                    title: "Purchased a membership?",
//                    message: "Use the same email address you used when purchasing through our online store."
//                )
//                .padding(.horizontal, Spacing.l)
                
                Spacer()
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Step 2: Enter Verification Code
struct EnterCodeStep: View {
    @ObservedObject var verificationState: VerificationState
    @FocusState private var isCodeFieldFocused: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.m) {
                    Image(systemName: "envelope.open.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Check Your Email")
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.xs) {
                        Text("We sent a 6-digit code to")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        
                        Text(verificationState.email)
                            .font(.bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryOrange)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.l)
                }
                .padding(.top, Spacing.xxxl)
                
                // Code input
                VStack(spacing: Spacing.m) {
                    CodeInputField(code: $verificationState.verificationCode)
                        .focused($isCodeFieldFocused)
                    
                    if let error = verificationState.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.errorRed)
                            
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.errorRed)
                            
                            Spacer()
                        }
                    }
                    
                    // Resend code
                    HStack {
                        Text("Didn't receive the code?")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        if verificationState.resendCooldown > 0 {
                            Text("Resend in \(verificationState.resendCooldown)s")
                                .font(.bodySmall)
                                .foregroundColor(.textTertiary)
                        } else {
                            Button(action: {
                                verificationState.resendCode()
                            }) {
                                Text("Resend")
                                    .font(.bodySmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryOrange)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                VStack(spacing: Spacing.m) {
                    if verificationState.isLoading {
                        ProgressView()
                            .tint(.primaryOrange)
                            .frame(height: 60)
                    } else {
                        PrimaryButton(
                            title: "Verify Code",
                            action: {
                                withAnimation {
                                    verificationState.verifyCode()
                                }
                            }, isEnabled: verificationState.verificationCode.count == 6
                        )
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Info box
                InfoBox(
                    icon: "clock.fill",
                    title: "Code expires soon",
                    message: "This verification code will expire in 10 minutes. If it expires, you can request a new one."
                )
                .padding(.horizontal, Spacing.l)
                
                Spacer()
            }
        }
        .onAppear {
            isCodeFieldFocused = true
        }
    }
}

// MARK: - Step 3: Set Password
struct SetPasswordStep: View {
    @ObservedObject var verificationState: VerificationState
    @ObservedObject var authManager: AuthenticationManager
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    var isValidPassword: Bool {
        verificationState.newPassword.count >= 8 &&
        verificationState.newPassword == verificationState.confirmPassword
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.m) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Set Your Password")
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Create a secure password for your account")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.l)
                }
                .padding(.top, Spacing.xxxl)
                
                VStack(spacing: Spacing.m) {
                    CustomSecureField(
                        placeholder: "New Password (min 8 characters)",
                        text: $verificationState.newPassword,
                        icon: "lock.fill"
                        
                    )
                    
                    
                    
                    CustomSecureField(
                        placeholder: "Confirm Password",
                        text: $verificationState.confirmPassword,
                        icon: "lock.fill"
                        
                    )
                    
                    if !verificationState.confirmPassword.isEmpty &&
                       verificationState.newPassword != verificationState.confirmPassword {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.errorRed)
                            
                            Text("Passwords do not match")
                                .font(.caption)
                                .foregroundColor(.errorRed)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                VStack(spacing: Spacing.m) {
                    if verificationState.isLoading {
                        ProgressView()
                            .tint(.primaryOrange)
                            .frame(height: 60)
                    } else {
                        PrimaryButton(
                            title: "Complete Setup", 
                            action: {
                                verificationState.setPassword(authManager: authManager)
                            }, isEnabled: isValidPassword
                        )
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Info box
                InfoBox(
                    icon: "checkmark.shield.fill",
                    title: "Password requirements",
                    message: "Your password must be at least 8 characters long. For better security, use a mix of letters, numbers, and symbols."
                )
                .padding(.horizontal, Spacing.l)
                
                Spacer()
            }
        }
    }
}

// MARK: - Code Input Field
struct CodeInputField: View {
    @Binding var code: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ForEach(0..<6, id: \.self) { index in
                CodeDigitBox(digit: getDigit(at: index), isActive: code.count == index)
            }
        }
        .background(
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .onChange(of: code) { newValue in
                    // Limit to 6 digits
                    if newValue.count > 6 {
                        code = String(newValue.prefix(6))
                    }
                }
        )
        .onTapGesture {
            isFocused = true
        }
    }
    
    func getDigit(at index: Int) -> String {
        guard index < code.count else { return "" }
        return String(code[code.index(code.startIndex, offsetBy: index)])
    }
}

//struct CodeDigitBox: View {
//    let digit: String
//    let isActive: Bool
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: CornerRadius.medium)
//                .stroke(
//                    isActive ? Color.primaryOrange : Color.cardBorder,
//                    lineWidth: isActive ? 2 : 1
//                )
//                .background(
//                    RoundedRectangle(cornerRadius: CornerRadius.medium)
//                        .fill(Color.cardBackground)
//                )
//                .frame(width: 45, height: 55)
//            
//            Text(digit)
//                .font(.titleMedium)
//                .fontWeight(.bold)
//                .foregroundColor(.textPrimary)
//            
//            // Blinking cursor
//            if isActive && digit.isEmpty {
//                Rectangle()
//                    .fill(Color.primaryOrange)
//                    .frame(width: 2, height: 30)
//                    .opacity(0.7)
//            }
//        }
//    }
//}

// MARK: - Info Box Component
struct InfoBox: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.infoBlue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.m)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.infoBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        FirstTimeUserView()
            .environmentObject(AuthenticationManager())
    }
}
