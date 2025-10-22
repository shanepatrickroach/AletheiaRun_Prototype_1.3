//
//  User.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import Foundation

// MARK: - Gender
enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case custom = "Custom"
}

// MARK: - Measurement System
enum MeasurementSystem: String, Codable, CaseIterable {
    case imperial = "Imperial"
    case metric = "Metric"
}

// MARK: - Height
struct Height: Codable, Equatable {
    var feet: Int?
    var inches: Int?
    var centimeters: Double?
    
    var displayString: String {
        if let cm = centimeters {
            return "\(Int(cm)) cm"
        } else if let ft = feet, let inch = inches {
            return "\(ft)'\(inch)\""
        }
        return "Not set"
    }
    
    // MARK: - Conversion Methods
        
        /// Convert from imperial (feet and inches) to both imperial and metric
        static func fromImperial(feet: Int, inches: Int) -> Height {
            let totalInches = (feet * 12) + inches
            let cm = Double(totalInches) * 2.54
            return Height(feet: feet, inches: inches, centimeters: cm)
        }
        
        /// Convert from metric (centimeters) to both imperial and metric
        static func fromCentimeters(_ cm: Double) -> Height {
            let totalInches = cm / 2.54
            let feet = Int(totalInches / 12)
            let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
            return Height(feet: feet, inches: inches, centimeters: cm)
        }
        
        /// Get total inches (useful for calculations)
        var totalInches: Double? {
            if let ft = feet, let inch = inches {
                return Double((ft * 12) + inch)
            } else if let cm = centimeters {
                return cm / 2.54
            }
            return nil
        }
}

// MARK: - Weight
struct Weight: Codable, Equatable {
    var pounds: Double?
    var kilograms: Double?
    
    var displayString: String {
        if let kg = kilograms {
            return String(format: "%.1f kg", kg)
        } else if let lbs = pounds {
            return String(format: "%.1f lbs", lbs)
        }
        return "Not set"
    }
    
    static func fromPounds(_ lbs: Double) -> Weight {
        let kg = lbs * 0.453592
        return Weight(pounds: lbs, kilograms: kg)
    }
    
    static func fromKilograms(_ kg: Double) -> Weight {
        let lbs = kg / 0.453592
        return Weight(pounds: lbs, kilograms: kg)
    }
}

// MARK: - Average Mileage
enum AverageMileage: String, Codable, CaseIterable {
    case miles0to10 = "0-10 miles"
    case miles10to20 = "10-20 miles"
    case miles20to30 = "20-30 miles"
    case miles30to40 = "30-40 miles"
    case miles40plus = "40+ miles"
}

// MARK: - User
struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var email: String
    var firstName: String
    var lastName: String
    var birthdate: Date
    var country: String
    var gender: Gender
    var measurementSystem: MeasurementSystem
    var height: Height
    var weight: Weight
    var averageMileage: AverageMileage
    var runningGoals: Set<RunGoal>
    var profileImage: String?
    var stats: UserStats?
    var hasActiveSubscription: Bool
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - User Stats
struct UserStats: Codable, Equatable {
    var totalRuns: Int
    var currentStreak: Int
    var longestStreak: Int
    var totalDistance: Double
    var averagePace: String
    var achievements: [UUID]
}
