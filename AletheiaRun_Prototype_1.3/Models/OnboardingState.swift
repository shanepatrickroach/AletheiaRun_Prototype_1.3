// Models/OnboardingState.swift

import Foundation
import SwiftUI

class OnboardingState: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var totalSteps: Int = 4 // Default for sign-up
    
    // MARK: - Navigation
    func nextStep() {
        if currentStep < totalSteps {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }
    
    func goToStep(_ step: Int) {
        if step >= 1 && step <= totalSteps {
            currentStep = step
        }
    }
    
    func reset() {
        currentStep = 1
    }
    
    // MARK: - Initialization
    init(totalSteps: Int = 4) {
        self.totalSteps = totalSteps
        self.currentStep = 1
    }
}
