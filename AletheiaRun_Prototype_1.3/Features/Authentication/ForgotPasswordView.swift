//
//  ForgotPasswordView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Features/Authentication/ForgotPasswordView.swift (NEW)

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var isLoading = false
    @State private var showingSuccess = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Header
                        VStack(spacing: Spacing.m) {
                            Image(systemName: "lock.rotation")
                                .font(.system(size: 80))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Reset Password")
                                .font(.titleLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("Enter your email address and we'll send you instructions to reset your password")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, Spacing.xxxl)
                        .padding(.horizontal, Spacing.l)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: Spacing.s) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            CustomTextField(
                                
                                placeholder: "your.email@example.com",
                                text: $email,
                                icon: "envelope"
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Send Button
                        PrimaryButton(
                            title: isLoading ? "Sending..." : "Send Reset Link"
                            
                        ) {
                            sendResetLink()
                        }
                        .disabled(email.isEmpty || isLoading)
                        .opacity((email.isEmpty || isLoading) ? 0.5 : 1.0)
                        .padding(.horizontal, Spacing.l)
                        
                        // Back to Sign In
                        Button("Back to Sign In") {
                            dismiss()
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.primaryOrange)
                    }
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
            .alert("Check Your Email", isPresented: $showingSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("We've sent password reset instructions to \(email)")
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func sendResetLink() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // TODO: Implement actual password reset API call
            // In real app: POST /api/auth/reset-password
            
            // For now, show success
            showingSuccess = true
        }
    }
}

#Preview {
    ForgotPasswordView()
}
