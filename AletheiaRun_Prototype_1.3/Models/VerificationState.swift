//
//  VerificationState.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//


import Foundation

class VerificationState: ObservableObject {
    @Published var email: String = ""
    @Published var verificationCode: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var currentStep: VerificationStep = .enterEmail
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var resendCooldown: Int = 0
    
    enum VerificationStep {
        case enterEmail
        case enterCode
        case setPassword
    }
    
    func sendVerificationCode() {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to send verification code
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.currentStep = .enterCode
            self?.startResendCooldown()
        }
    }
    
    func verifyCode() {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to verify code
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // In real app, check if code is valid
            if self?.verificationCode.count == 6 {
                self?.isLoading = false
                self?.currentStep = .setPassword
            } else {
                self?.isLoading = false
                self?.errorMessage = "Invalid verification code. Please try again."
            }
        }
    }
    
    func resendCode() {
        guard resendCooldown == 0 else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to resend code
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.verificationCode = ""
            self?.startResendCooldown()
        }
    }
    
    func setPassword(authManager: AuthenticationManager) {
        isLoading = true
        errorMessage = nil
        
//        // Simulate API call to set password
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
//            guard let self = self else { return }
//            
//            // Create basic user profile and sign in
//            let profile = UserProfile(
//                email: self.email,
//                password: self.newPassword,
//                firstName: "",
//                lastName: ""
//            )
//            
//            self.isLoading = false
//            authManager.signUp(profile: profile)
//        }
    }
    
    private func startResendCooldown() {
        resendCooldown = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.resendCooldown > 0 {
                self.resendCooldown -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    func reset() {
        email = ""
        verificationCode = ""
        newPassword = ""
        confirmPassword = ""
        currentStep = .enterEmail
        errorMessage = nil
        resendCooldown = 0
    }
}
