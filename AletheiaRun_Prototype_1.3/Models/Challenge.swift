//
//  Challenge.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Models/Challenge.swift (NEW FILE)

import Foundation
import SwiftUI

// MARK: - Challenge
struct Challenge: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ChallengeType
    let name: String
    let description: String
    let icon: String
    let requirement: Double
    var progress: Double
    let startDate: Date
    let endDate: Date
    let reward: ChallengeReward
    var isCompleted: Bool
    var completedDate: Date?
    
    var progressPercentage: Double {
        min((progress / requirement) * 100, 100)
    }
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
    
    var isActive: Bool {
        Date() >= startDate && Date() <= endDate && !isCompleted
    }
    
    var isExpired: Bool {
        Date() > endDate && !isCompleted
    }
    
    var statusText: String {
        if isCompleted { return "Completed" }
        if isExpired { return "Expired" }
        if daysRemaining == 0 { return "Last day!" }
        if daysRemaining == 1 { return "1 day left" }
        return "\(daysRemaining) days left"
    }
    
    init(
        id: UUID = UUID(),
        type: ChallengeType,
        name: String,
        description: String,
        icon: String,
        requirement: Double,
        progress: Double = 0,
        startDate: Date,
        endDate: Date,
        reward: ChallengeReward,
        isCompleted: Bool = false,
        completedDate: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.progress = progress
        self.startDate = startDate
        self.endDate = endDate
        self.reward = reward
        self.isCompleted = isCompleted
        self.completedDate = completedDate
    }
}

// MARK: - Challenge Type
enum ChallengeType: String, Codable, CaseIterable {
    case distance = "Distance"
    case efficiency = "Efficiency"
    case consistency = "Consistency"
    case improvement = "Improvement"
    
    var color: Color {
        switch self {
        case .distance: return .primaryOrange
        case .efficiency: return .successGreen
        case .consistency: return .infoBlue
        case .improvement: return .warningYellow
        }
    }
}

// MARK: - Challenge Reward
struct ChallengeReward: Codable, Equatable {
    let type: RewardType
    let amount: Int
    
    var description: String {
        switch type {
        case .badge:
            return "Exclusive badge"
        case .achievement:
            return "Special achievement"
        case .title:
            return "Custom title"
        }
    }
    
    enum RewardType: String, Codable {
        case badge = "Badge"
        case achievement = "Achievement"
        case title = "Title"
    }
}

// MARK: - Sample Challenges
extension Challenge {
    static var sampleChallenges: [Challenge] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            // Active Challenges
            Challenge(
                type: .distance,
                name: "Week Distance Challenge",
                description: "Run 20 miles this week",
                icon: "figure.run",
                requirement: 20,
                progress: 12.5,
                startDate: calendar.startOfDay(for: calendar.date(byAdding: .day, value: -3, to: now)!),
                endDate: calendar.date(byAdding: .day, value: 4, to: now)!,
                reward: ChallengeReward(type: .badge, amount: 1)
            ),
            Challenge(
                type: .efficiency,
                name: "Efficiency Master",
                description: "Maintain 85%+ efficiency for 5 runs",
                icon: "bolt.fill",
                requirement: 5,
                progress: 3,
                startDate: calendar.startOfDay(for: calendar.date(byAdding: .day, value: -5, to: now)!),
                endDate: calendar.date(byAdding: .day, value: 9, to: now)!,
                reward: ChallengeReward(type: .achievement, amount: 1)
            ),
            Challenge(
                type: .consistency,
                name: "Streak Starter",
                description: "Run 5 days in a row",
                icon: "flame.fill",
                requirement: 5,
                progress: 3,
                startDate: calendar.startOfDay(for: calendar.date(byAdding: .day, value: -3, to: now)!),
                endDate: calendar.date(byAdding: .day, value: 4, to: now)!,
                reward: ChallengeReward(type: .title, amount: 1)
            ),
            Challenge(
                type: .improvement,
                name: "Pace Progress",
                description: "Improve your average pace by 15 seconds",
                icon: "speedometer",
                requirement: 15,
                progress: 8,
                startDate: calendar.startOfDay(for: calendar.date(byAdding: .day, value: -10, to: now)!),
                endDate: calendar.date(byAdding: .day, value: 20, to: now)!,
                reward: ChallengeReward(type: .badge, amount: 1)
            ),
            
            // Completed Challenges
            Challenge(
                type: .distance,
                name: "First 10 Miles",
                description: "Complete 10 miles total",
                icon: "figure.run",
                requirement: 10,
                progress: 10,
                startDate: calendar.date(byAdding: .day, value: -30, to: now)!,
                endDate: calendar.date(byAdding: .day, value: -7, to: now)!,
                reward: ChallengeReward(type: .badge, amount: 1),
                isCompleted: true,
                completedDate: calendar.date(byAdding: .day, value: -8, to: now)
            ),
            Challenge(
                type: .consistency,
                name: "Weekend Warrior",
                description: "Run both Saturday and Sunday",
                icon: "calendar.badge.clock",
                requirement: 2,
                progress: 2,
                startDate: calendar.date(byAdding: .day, value: -14, to: now)!,
                endDate: calendar.date(byAdding: .day, value: -7, to: now)!,
                reward: ChallengeReward(type: .title, amount: 1),
                isCompleted: true,
                completedDate: calendar.date(byAdding: .day, value: -7, to: now)
            ),
        ]
    }
}