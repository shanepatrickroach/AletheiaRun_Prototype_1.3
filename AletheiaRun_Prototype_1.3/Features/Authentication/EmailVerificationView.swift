//
//  EmailVerificationView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Features/Authentication/EmailVerificationView.swift (NEW)

import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    
    @State private var verificationCode = ""
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var canResend = false
    @State private var resendCountdown = 60
    
    private let codeLength = 6
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Header
                        VStack(spacing: Spacing.m) {
                            Image(systemName: "envelope.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Verify Your Email")
                                .font(.titleLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("We sent a verification code to")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                            
                            Text(email)
                                .font(.bodyMedium)
                                .foregroundColor(.primaryOrange)
                        }
                        .padding(.top, Spacing.xxxl)
                        
                        // Verification Code Input
                        VStack(spacing: Spacing.m) {
                            Text("Enter Verification Code")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: Spacing.s) {
                                ForEach(0..<codeLength, id: \.self) { index in
                                    CodeDigitBox(
                                        digit: getDigit(at: index),
                                        isActive: verificationCode.count == index
                                    )
                                }
                            }
                            
                            // Hidden TextField for input
                            TextField("", text: $verificationCode)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .frame(width: 0, height: 0)
                                .opacity(0)
                                .onChange(of: verificationCode) { _, newValue in
                                    // Limit to 6 digits
                                    if newValue.count > codeLength {
                                        verificationCode = String(newValue.prefix(codeLength))
                                    }
                                    // Auto-verify when 6 digits entered
                                    if verificationCode.count == codeLength {
                                        verifyCode()
                                    }
                                }
                        }
                        
                        // Resend Code
                        VStack(spacing: Spacing.s) {
                            if canResend {
                                Button("Resend Code") {
                                    resendCode()
                                }
                                .font(.bodyMedium)
                                .foregroundColor(.primaryOrange)
                            } else {
                                Text("Resend code in \(resendCountdown)s")
                                    .font(.bodySmall)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                        .padding(.top, Spacing.m)
                        
                        // Info Card
                        VStack(alignment: .leading, spacing: Spacing.s) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.infoBlue)
                                
                                Text("Didn't receive the code?")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Text("Check your spam folder or try resending the code. If you continue having issues, please contact support.")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(Spacing.m)
                        .background(Color.infoBlue.opacity(0.1))
                        .cornerRadius(CornerRadius.medium)
                        
                        // Manual Verify Button (if needed)
                        if verificationCode.count == codeLength && !isLoading {
                            PrimaryButton(
                                title: "Verify"
                                
                            ) {
                                verifyCode()
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                startResendTimer()
            }
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard index < verificationCode.count else { return "" }
        return String(verificationCode[verificationCode.index(verificationCode.startIndex, offsetBy: index)])
    }
    
    private func verifyCode() {
        guard verificationCode.count == codeLength else { return }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.verifyEmail(email: email, code: verificationCode)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Invalid verification code. Please try again."
                    showingError = true
                    isLoading = false
                    verificationCode = ""
                }
            }
        }
    }
    
    private func resendCode() {
        // TODO: Implement resend API call
        canResend = false
        resendCountdown = 60
        startResendTimer()
    }
    
    private func startResendTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if resendCountdown > 0 {
                resendCountdown -= 1
            } else {
                canResend = true
                timer.invalidate()
            }
        }
    }
}

// MARK: - Code Digit Box
struct CodeDigitBox: View {
    let digit: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(isActive ? Color.primaryOrange : Color.cardBorder, lineWidth: isActive ? 2 : 1)
                .frame(width: 45, height: 55)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(digit.isEmpty ? Color.cardBackground : Color.primaryOrange.opacity(0.1))
                )
            
            Text(digit)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    EmailVerificationView(email: "user@example.com")
        .environmentObject(AuthenticationManager())
}
