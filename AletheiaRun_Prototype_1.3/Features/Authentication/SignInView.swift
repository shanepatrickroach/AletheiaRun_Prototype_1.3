//
//  SignInView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showingForgotPassword = false
    @State private var showingSignUp = false
    @State private var isAnimating: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Logo and Header
                        VStack(spacing: Spacing.m) {
                            Image("LogoGradient")
                                .resizable()
                                    .frame(width: 200, height: 200)
                                    .scaleEffect(isAnimating ? 1.03 : 1.0)
                                    .shadow(
                                        color: .primaryOrange.opacity(isAnimating ? 0.4 : 0.15),
                                        radius: isAnimating ? 15 : 8
                                    )
                                    .animation(
                                        .easeInOut(duration: 2.5)
                                        .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                    .onAppear { isAnimating = true }
                            
                            Text("Welcome Back")
                                .font(.titleLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("Sign in to continue your journey")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, Spacing.xxxl)
                        
                        // Sign In Form
                        VStack(spacing: Spacing.m) {
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope"
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            
                            CustomSecureField(
                                placeholder: "Password",
                                text: $password,
                                icon: "lock"
                            )
                            
                            Button("Forgot Password?") {
                                showingForgotPassword = true
                            }
                            .font(.bodySmall)
                            .foregroundColor(.primaryOrange)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        // Sign In Button
                        PrimaryButton(
                            title: isLoading ? "Signing In..." : "Sign In"
                            
                        ) {
                            signIn()
                        }
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                        .opacity((email.isEmpty || password.isEmpty || isLoading) ? 0.5 : 1.0)
                        
                        // Sign Up Link
                        VStack(spacing: Spacing.s) {
                            Text("Don't have an account?")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                            
                            Button("Create Account") {
                                showingSignUp = true
                            }
                            .font(.bodyLarge)
                            .foregroundColor(.primaryOrange)
                        }
                        .padding(.top, Spacing.l)
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
    }
    
    private func signIn() {
        print("🟡 Sign In button tapped")
        isLoading = true
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
                print("🟡 Sign in successful")
            } catch {
                await MainActor.run {
                    print("🔴 Sign in failed: \(error)")
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationManager())
}
