// Models/Achievement.swift (COMPLETE VERSION)

import Foundation
import SwiftUI

// MARK: - Achievement
struct Achievement: Identifiable, Codable, Equatable {
    let id: UUID
    let category: AchievementCategory
    let name: String
    let description: String
    let icon: String
    let tier: AchievementTier
    let requirement: Double
    var progress: Double
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    var progressPercentage: Double {
        min((progress / requirement) * 100, 100)
    }
    
    var isComplete: Bool {
        progress >= requirement
    }
    
    init(
        id: UUID = UUID(),
        category: AchievementCategory,
        name: String,
        description: String,
        icon: String,
        tier: AchievementTier,
        requirement: Double,
        progress: Double = 0,
        isUnlocked: Bool = false,
        unlockedDate: Date? = nil
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.description = description
        self.icon = icon
        self.tier = tier
        self.requirement = requirement
        self.progress = progress
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
}

// MARK: - Achievement Category
enum AchievementCategory: String, Codable, CaseIterable {
    case distance = "Distance"
    case performance = "Performance"
    case portrait = "Force Portrait"
    case consistency = "Consistency"
    case injuryPrevention = "Injury Prevention"
    case pocketCoach = "Pocket Coach"
    
    var icon: String {
        switch self {
        case .distance: return "figure.run"
        case .performance: return "bolt.fill"
        case .portrait: return "waveform.path.ecg"
        case .consistency: return "calendar"
        case .injuryPrevention: return "heart.circle.fill"
        case .pocketCoach: return "person.badge.shield.checkmark"
        }
    }
    
    var color: Color {
        switch self {
        case .distance: return .primaryOrange
        case .performance: return .errorRed
        case .portrait: return .infoBlue
        case .consistency: return .successGreen
        case .injuryPrevention: return .warningYellow
        case .pocketCoach: return Color(hex: "#9333EA") // Purple
        }
    }
}

// MARK: - Achievement Tier
enum AchievementTier: String, Codable, CaseIterable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    
    var color: Color {
        switch self {
        case .bronze: return Color(hex: "#CD7F32")
        case .silver: return Color(hex: "#C0C0C0")
        case .gold: return Color(hex: "#FFD700")
        case .platinum: return Color(hex: "#E5E4E2")
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .bronze: return 0
        case .silver: return 1
        case .gold: return 2
        case .platinum: return 3
        }
    }
}

// MARK: - Sample Achievements
extension Achievement {
    static var sampleAchievements: [Achievement] {
        [
            // Distance Achievements
            Achievement(
                category: .distance,
                name: "First Steps",
                description: "Complete your first run",
                icon: "figure.walk",
                tier: .bronze,
                requirement: 1,
                progress: 1,
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-60*60*24*30)
            ),
            Achievement(
                category: .distance,
                name: "Quarter Century",
                description: "Run 25 total miles",
                icon: "figure.run",
                tier: .bronze,
                requirement: 25,
                progress: 25,
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-60*60*24*25)
            ),
            Achievement(
                category: .distance,
                name: "Half Century",
                description: "Run 50 total miles",
                icon: "figure.run",
                tier: .silver,
                requirement: 50,
                progress: 50,
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-60*60*24*20)
            ),
            Achievement(
                category: .distance,
                name: "Century Runner",
                description: "Run 100 total miles",
                icon: "figure.run",
                tier: .gold,
                requirement: 100,
                progress: 87,
                isUnlocked: false
            ),
            Achievement(
                category: .distance,
                name: "Marathon Master",
                description: "Run 250 total miles",
                icon: "figure.run",
                tier: .platinum,
                requirement: 250,
                progress: 87,
                isUnlocked: false
            ),
            
            // Performance Achievements
            Achievement(
                category: .performance,
                name: "Efficiency Master",
                description: "Achieve 90%+ efficiency score",
                icon: "bolt.fill",
                tier: .gold,
                requirement: 90,
                progress: 85,
                isUnlocked: false
            ),
            Achievement(
                category: .performance,
                name: "Smooth Operator",
                description: "Keep sway under 10%",
                icon: "arrow.left.and.right",
                tier: .silver,
                requirement: 10,
                progress: 12,
                isUnlocked: false
            ),
            Achievement(
                category: .performance,
                name: "Light Feet",
                description: "Reduce impact to under 20%",
                icon: "arrow.down.circle",
                tier: .gold,
                requirement: 20,
                progress: 23,
                isUnlocked: false
            ),
            
            // Force Portrait Achievements
            Achievement(
                category: .portrait,
                name: "First Portrait",
                description: "Generate your first Force Portrait",
                icon: "waveform.path.ecg",
                tier: .bronze,
                requirement: 1,
                progress: 1,
                isUnlocked: true,
                unlockedDate: Date().addingTimeInterval(-60*60*24*30)
            ),
            Achievement(
                category: .portrait,
                name: "Perfect Picture",
                description: "Achieve a perfect Force Portrait score",
                icon: "star.fill",
                tier: .platinum,
                requirement: 100,
                progress: 85,
                isUnlocked: false
            ),
            Achievement(
                category: .portrait,
                name: "Portrait Collector",
                description: "Generate 50 Force Portraits",
                icon: "square.grid.3x3.fill",
                tier: .gold,
                requirement: 50,
                progress: 32,
                isUnlocked: false
            ),
            
            // Consistency Achievements
            Achievement(
                category: .consistency,
                name: "Week Warrior",
                description: "Run 7 days in a row",
                icon: "calendar",
                tier: .bronze,
                requirement: 7,
                progress: 5,
                isUnlocked: false
            ),
            Achievement(
                category: .consistency,
                name: "Month Maniac",
                description: "Run 25 days in a row",
                icon: "calendar.badge.clock",
                tier: .silver,
                requirement: 25,
                progress: 5,
                isUnlocked: false
            ),
            Achievement(
                category: .consistency,
                name: "Century Streak",
                description: "Run 100 days in a row",
                icon: "flame.fill",
                tier: .platinum,
                requirement: 100,
                progress: 5,
                isUnlocked: false
            ),
            
            // Injury Prevention Achievements
            Achievement(
                category: .injuryPrevention,
                name: "Hip Hero",
                description: "Maintain balanced hip metrics for 10 runs",
                icon: "heart.circle.fill",
                tier: .silver,
                requirement: 10,
                progress: 7,
                isUnlocked: false
            ),
            Achievement(
                category: .injuryPrevention,
                name: "Steel Hips",
                description: "Perfect hip balance for 50 runs",
                icon: "shield.fill",
                tier: .platinum,
                requirement: 50,
                progress: 7,
                isUnlocked: false
            ),
            
            // Pocket Coach Achievements
            Achievement(
                category: .pocketCoach,
                name: "Tip Follower",
                description: "Complete 5 recommended exercises",
                icon: "checkmark.circle.fill",
                tier: .bronze,
                requirement: 5,
                progress: 3,
                isUnlocked: false
            ),
            Achievement(
                category: .pocketCoach,
                name: "Dedicated Trainee",
                description: "Complete 25 recommended exercises",
                icon: "star.circle.fill",
                tier: .gold,
                requirement: 25,
                progress: 3,
                isUnlocked: false
            ),
        ]
    }
}
