//
//  SignUpView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var onboardingState = OnboardingState(totalSteps: 4)
    @State private var profile = UserProfile()
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Indicator
                ProgressBar(currentStep: onboardingState.currentStep, totalSteps: onboardingState.totalSteps)
                    .padding(.horizontal, Spacing.l)
                    .padding(.top, Spacing.m)
                
                // Content
                TabView(selection: $onboardingState.currentStep) {
                    AccountInfoStep(profile: $profile)
                        .tag(1)
                    
                    PersonalInfoStep(profile: $profile)
                        .tag(2)
                    
                    PhysicalProfileStep(profile: $profile)
                        .tag(3)
                    
                    RunningGoalsStep(profile: $profile)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation Buttons
                HStack(spacing: Spacing.m) {
                    if onboardingState.currentStep > 1 {
                        SecondaryButton(title: "Back") {
                            withAnimation {
                                onboardingState.previousStep()
                            }
                        }
                    }
                    
                    PrimaryButton(
                        title: onboardingState.currentStep == 4 ? "Create Account" : "Next"
                        
                    ) {
                        if onboardingState.currentStep == 4 {
                            createAccount()
                        } else {
                            withAnimation {
                                onboardingState.nextStep()
                            }
                        }
                    }
                    .disabled(!canProceed || isLoading)
                    .opacity((canProceed && !isLoading) ? 1.0 : 0.5)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.bottom, Spacing.xl)
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
    }
    
    private var canProceed: Bool {
        switch onboardingState.currentStep {
        case 1:
            return !profile.email.isEmpty &&
                   !profile.password.isEmpty &&
                   profile.password.count >= 8 &&
                   profile.acceptedTerms
        case 2:
            return !profile.firstName.isEmpty &&
                   !profile.lastName.isEmpty
        case 3:
            return true
        case 4:
            return !profile.runningGoals.isEmpty
        default:
            return false
        }
    }
    
    private func createAccount() {
        print("🟡 Create Account button tapped")
        isLoading = true
        
        Task {
            do {
                try await authManager.signUp(profile: profile)
                print("🟡 Sign up successful")
                await MainActor.run {
                    isLoading = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    print("🔴 Sign up failed: \(error)")
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: 4) {
                ForEach(1...totalSteps, id: \.self) { step in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(step <= currentStep ? Color.primaryOrange : Color.cardBorder)
                        .frame(height: 4)
                }
            }
            
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(AuthenticationManager())
    }
}
