//
//  AuthenticationManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import Foundation
import SwiftUI

// MARK: - Authentication State
enum AuthState: Equatable {
    case loading
    case unauthenticated
    case emailVerificationNeeded(email: String)
    case profileIncomplete(user: User)
    case authenticated(user: User)
    
    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.unauthenticated, .unauthenticated):
            return true
        case (.emailVerificationNeeded(let lhsEmail), .emailVerificationNeeded(let rhsEmail)):
            return lhsEmail == rhsEmail
        case (.profileIncomplete(let lhsUser), .profileIncomplete(let rhsUser)):
            return lhsUser.id == rhsUser.id
        case (.authenticated(let lhsUser), .authenticated(let rhsUser)):
            return lhsUser.id == rhsUser.id
        default:
            return false
        }
    }
}

// MARK: - Authentication Manager
class AuthenticationManager: ObservableObject {
    
    @Published var authState: AuthState = .loading
    @Published var currentUser: User?
    
    init() {
        
        checkAuthState()
    }
    
    // MARK: - Check Auth State
    func checkAuthState() {
        
        
        // TODO: Check UserDefaults/Keychain for saved session
        // For now, simulate delay then set to unauthenticated
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.authState = .unauthenticated
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        // For testing: Check if profile is complete
        // In real app, API would return this info
        let hasCompletedProfile = false // Change to true to test different flow
        
        if hasCompletedProfile {
            // User has complete profile
            let user = User(
                id: UUID(),
                email: email,
                firstName: "Test",
                lastName: "User",
                birthdate: Date(),
                country: "United States",
                gender: .male,
                measurementSystem: .imperial,
                height: Height(feet: 5, inches: 10, centimeters: nil),
                weight: Weight(pounds: 165, kilograms: nil),
                averageMileage: .miles20to30,
                runningGoals: [.improvePerformance],
                profileImage: nil,
                stats: nil,
                hasActiveSubscription: false
            )
            
            await MainActor.run {
                self.currentUser = user
                self.authState = .authenticated(user: user)
            }
        } else {
            // User needs to complete profile
            let incompleteUser = User(
                id: UUID(),
                email: email,
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
                hasActiveSubscription: true
            )
            
            await MainActor.run {
                self.authState = .profileIncomplete(user: incompleteUser)
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(profile: UserProfile) async throws {
    
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        await MainActor.run {
            print("🔵 Setting authState to .emailVerificationNeeded")
            self.authState = .emailVerificationNeeded(email: profile.email)
        }
    }
    
    // MARK: - Verify Email
    func verifyEmail(email: String, code: String) async throws {
        
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Create incomplete user (needs to complete profile)
        let incompleteUser = User(
            id: UUID(),
            email: email,
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
        )
        
        await MainActor.run {
            print("🔵 Setting authState to .profileIncomplete")
            self.authState = .profileIncomplete(user: incompleteUser)
        }
    }
    
    // MARK: - Complete Profile
    func completeProfile(user: User, profile: UserProfile) async throws {
        print("🔵 completeProfile() called")
        
        // Update user with profile info
        var updatedUser = user
        updatedUser.firstName = profile.firstName
        updatedUser.lastName = profile.lastName
        updatedUser.birthdate = profile.birthdate
        updatedUser.country = profile.country
        updatedUser.gender = profile.gender
        updatedUser.measurementSystem = profile.measurementSystem
        updatedUser.height = profile.height
        updatedUser.weight = profile.weight
        updatedUser.averageMileage = profile.averageMileage
        updatedUser.runningGoals = profile.runningGoals
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        await MainActor.run {
        
            self.currentUser = updatedUser
            self.authState = .authenticated(user: updatedUser)
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        print("🔵 signOut() called")
        currentUser = nil
        authState = .unauthenticated
    }
}
