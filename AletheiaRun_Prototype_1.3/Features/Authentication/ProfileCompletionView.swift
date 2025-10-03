//
//  ProfileCompletionView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Features/Authentication/ProfileCompletionView.swift (NEW)

import SwiftUI

struct ProfileCompletionView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    let user: User
    
    @StateObject private var onboardingState = OnboardingState()
    @State private var profile = UserProfile()
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 60))
                            .foregroundColor(.primaryOrange)
                        
                        Text("Complete Your Profile")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("Just a few more details to get started")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.vertical, Spacing.l)
                    
                    // Progress Indicator
                    ProgressBar(currentStep: onboardingState.currentStep, totalSteps: 3)
                        .padding(.horizontal, Spacing.l)
                    
                    // Content
                    TabView(selection: $onboardingState.currentStep) {
                        // Step 1: Personal Info
                        PersonalInfoStep(profile: $profile)
                            .tag(1)
                        
                        // Step 2: Physical Profile
                        PhysicalProfileStep(profile: $profile)
                            .tag(2)
                        
                        // Step 3: Running Goals
                        RunningGoalsStep(profile: $profile)
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Navigation Buttons
                    HStack(spacing: Spacing.m) {
                        if onboardingState.currentStep > 1 {
                            SecondaryButton(title: "Back"
                                            ) {
                                withAnimation {
                                    onboardingState.previousStep()
                                }
                            }
                        }
                        
                        PrimaryButton(
                            title: onboardingState.currentStep == 3 ? "Complete" : "Next"
                            
                        ) {
                            if onboardingState.currentStep == 3 {
                                completeProfile()
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
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            // Pre-fill email from user
            profile.email = user.email
        }
    }
    
    private var canProceed: Bool {
        switch onboardingState.currentStep {
        case 1:
            return !profile.firstName.isEmpty &&
                   !profile.lastName.isEmpty &&
                   !profile.country.isEmpty
        case 2:
            return true // All fields have defaults
        case 3:
            return !profile.runningGoals.isEmpty
        default:
            return false
        }
    }
    
    private func completeProfile() {
        isLoading = true
        
        Task {
            do {
                try await authManager.completeProfile(user: user, profile: profile)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

//// MARK: - Progress Bar
//struct ProgressBar: View {
//    let currentStep: Int
//    let totalSteps: Int
//    
//    var body: some View {
//        VStack(spacing: Spacing.xs) {
//            HStack(spacing: 4) {
//                ForEach(1...totalSteps, id: \.self) { step in
//                    RoundedRectangle(cornerRadius: 2)
//                        .fill(step <= currentStep ? Color.primaryOrange : Color.cardBorder)
//                        .frame(height: 4)
//                }
//            }
//            
//            Text("Step \(currentStep) of \(totalSteps)")
//                .font(.caption)
//                .foregroundColor(.textSecondary)
//        }
//    }
//}

#Preview {
    ProfileCompletionView(user: User(
        id: UUID(),
        email: "user@example.com",
        firstName: "",
        lastName: "",
        birthdate: Date(),
        country: "United States",
        gender: .male,
        measurementSystem: .imperial,
        height: Height(feet: 5, inches: 8, centimeters: nil),
        weight: Weight(pounds: 150, kilograms: nil),
        averageMileage: .miles10to20,
        runningGoals: [],
        profileImage: nil,
        stats: nil,
        hasActiveSubscription: false
    ))
    .environmentObject(AuthenticationManager())
}
