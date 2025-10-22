//
//  UserProfile.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


//
//  UserProfile.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import Foundation

// MARK: - User Profile (for sign-up flow)
struct UserProfile: Codable {
    // Step 1: Account Info
    var email: String = ""
    var password: String = ""
    var acceptedTerms: Bool = false
    
    // Step 2: Personal Info
    var firstName: String = ""
    var lastName: String = ""
    var birthdate: Date = Date()
    var country: String = "United States"
    var gender: Gender = .male
    
    // Step 3: Physical Profile
    var measurementSystem: MeasurementSystem = .imperial
    var height: Height = Height(feet: 5, inches: 8, centimeters: nil)
    var weight: Weight = Weight(pounds: 150, kilograms: nil)
    var averageMileage: AverageMileage = .miles10to20
    
    // Step 4: Running Goals
    var runningGoals: Set<RunGoal> = []
}