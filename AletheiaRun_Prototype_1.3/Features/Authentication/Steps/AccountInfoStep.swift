//
//  AccountInfoStep.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct AccountInfoStep: View {
    @Binding var profile: UserProfile
    
    @State private var confirmPassword = ""
    
    
    
    var passwordsMatch: Bool {
        !confirmPassword.isEmpty && profile.password == confirmPassword
    }
    
    var passwordStrength: PasswordStrengthIndicator.PasswordStrength {
        getPasswordStrength(profile.password)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                
                
                // Header
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Create Account")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Enter your email and create a secure password")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.xl)
                
                // Email Field
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    CustomTextField(
                        placeholder: "your.email@example.com",
                        text: $profile.email,
                        icon: "envelope"
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                }
                .padding(.horizontal, Spacing.l)
                
                // Password Field
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    CustomSecureField(
                        placeholder: "Create a strong password",
                        text: $profile.password,
                        icon: "lock"
                    )
                    
                    // Password Strength Indicator
                    if !profile.password.isEmpty {
                        PasswordStrengthIndicator(strength: passwordStrength)
                            .padding(.top, Spacing.xs)
                    }
                    
                    // Password Requirements
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        PasswordRequirement(
                            text: "At least 8 characters",
                            isMet: profile.password.count >= 8
                        )
                        PasswordRequirement(
                            text: "Contains uppercase letter",
                            isMet: profile.password.contains(where: { $0.isUppercase })
                        )
                        PasswordRequirement(
                            text: "Contains lowercase letter",
                            isMet: profile.password.contains(where: { $0.isLowercase })
                        )
                        PasswordRequirement(
                            text: "Contains number",
                            isMet: profile.password.contains(where: { $0.isNumber })
                        )
                    }
                    .padding(.top, Spacing.s)
                }
                .padding(.horizontal, Spacing.l)
                
                // Confirm Password Field
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Confirm Password")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    CustomSecureField(
                        placeholder: "Re-enter your password",
                        text: $confirmPassword,
                        icon: "lock.fill"
                    )
                    
                    // Password Match Indicator
                    if !confirmPassword.isEmpty {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(passwordsMatch ? .successGreen : .errorRed)
                            
                            Text(passwordsMatch ? "Passwords match" : "Passwords don't match")
                                .font(.caption)
                                .foregroundColor(passwordsMatch ? .successGreen : .errorRed)
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Terms and Conditions
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Button(action: {
                        profile.acceptedTerms.toggle()
                    }) {
                        HStack(alignment: .top, spacing: Spacing.m) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(profile.acceptedTerms ? Color.primaryOrange : Color.cardBorder, lineWidth: 2)
                                    .frame(width: 24, height: 24)
                                
                                if profile.acceptedTerms {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text("I agree to the Terms of Service and Privacy Policy")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom,6)
                                
                                HStack(spacing: Spacing.m) {
                                    Button("Terms of Service") {
                                        
                                    }
                                    .font(.caption)
                                    .foregroundColor(.primaryOrange)
                                    
                                    Button("Privacy Policy") {
                                        
                                    }
                                    .font(.caption)
                                    .foregroundColor(.primaryOrange)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, Spacing.xxxl)
            .background(Color.black)
        }
    }
    
    // MARK: - Password Strength Helper
    private func getPasswordStrength(_ password: String) -> PasswordStrengthIndicator.PasswordStrength {
        var strength = 0
        
        if password.count >= 8 { strength += 1 }
        if password.contains(where: { $0.isUppercase }) { strength += 1 }
        if password.contains(where: { $0.isLowercase }) { strength += 1 }
        if password.contains(where: { $0.isNumber }) { strength += 1 }
        if password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) { strength += 1 }
        
        if strength <= 2 { return .weak }
        if strength <= 3 { return .medium }
        return .strong
    }
}

// MARK: - Password Requirement Row
struct PasswordRequirement: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14))
                .foregroundColor(isMet ? .successGreen : .textTertiary)
            
            Text(text)
                .font(.caption)
                .foregroundColor(isMet ? .textPrimary : .textSecondary)
        }
    }
}

#Preview {
    AccountInfoStep(profile: .constant(UserProfile()))
}
