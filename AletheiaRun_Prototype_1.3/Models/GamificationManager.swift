// Models/GamificationManager.swift (NEW FILE)

import Foundation
import SwiftUI
import Combine

class GamificationManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var challenges: [Challenge] = []
    @Published var recentlyUnlockedAchievement: Achievement?
    @Published var showAchievementUnlock: Bool = false
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Data Loading
    func loadSampleData() {
        achievements = Achievement.sampleAchievements
        challenges = Challenge.sampleChallenges
    }
    
    // MARK: - Achievements
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    var achievementProgress: Double {
        let unlocked = Double(unlockedAchievements.count)
        let total = Double(achievements.count)
        return total > 0 ? (unlocked / total) * 100 : 0
    }
    
    func achievements(for category: AchievementCategory) -> [Achievement] {
        achievements.filter { $0.category == category }
    }
    
    func achievements(for tier: AchievementTier) -> [Achievement] {
        achievements.filter { $0.tier == tier }
    }
    
    func updateAchievementProgress(id: UUID, progress: Double) {
        guard let index = achievements.firstIndex(where: { $0.id == id }) else { return }
        
        achievements[index].progress = progress
        
        // Check if achievement should be unlocked
        if !achievements[index].isUnlocked && achievements[index].isComplete {
            unlockAchievement(id: id)
        }
    }
    
    func unlockAchievement(id: UUID) {
        guard let index = achievements.firstIndex(where: { $0.id == id }) else { return }
        
        achievements[index].isUnlocked = true
        achievements[index].unlockedDate = Date()
        
        // Show unlock animation
        recentlyUnlockedAchievement = achievements[index]
        showAchievementUnlock = true
        
        print("🏆 Achievement Unlocked: \(achievements[index].name)")
    }
    
    // MARK: - Challenges
    
    var activeChallenges: [Challenge] {
        challenges.filter { $0.isActive }.sorted { $0.daysRemaining < $1.daysRemaining }
    }
    
    var completedChallenges: [Challenge] {
        challenges.filter { $0.isCompleted }.sorted { ($0.completedDate ?? Date()) > ($1.completedDate ?? Date()) }
    }
    
    var expiredChallenges: [Challenge] {
        challenges.filter { $0.isExpired }
    }
    
    func updateChallengeProgress(id: UUID, progress: Double) {
        guard let index = challenges.firstIndex(where: { $0.id == id }) else { return }
        
        challenges[index].progress = progress
        
        // Check if challenge should be completed
        if !challenges[index].isCompleted && challenges[index].progress >= challenges[index].requirement {
            completeChallenge(id: id)
        }
    }
    
    func completeChallenge(id: UUID) {
        guard let index = challenges.firstIndex(where: { $0.id == id }) else { return }
        
        challenges[index].isCompleted = true
        challenges[index].completedDate = Date()
        
        print("✅ Challenge Completed: \(challenges[index].name)")
        
        // Award reward (implement reward logic here)
    }
    
    // MARK: - Statistics
    
    var totalAchievements: Int {
        achievements.count
    }
    
    var totalUnlockedAchievements: Int {
        unlockedAchievements.count
    }
    
    var totalActiveChallenges: Int {
        activeChallenges.count
    }
    
    var totalCompletedChallenges: Int {
        completedChallenges.count
    }
    
    // MARK: - Tier Distribution
    
    func achievementCount(for tier: AchievementTier) -> Int {
        achievements(for: tier).filter { $0.isUnlocked }.count
    }
    
    var bronzeCount: Int { achievementCount(for: .bronze) }
    var silverCount: Int { achievementCount(for: .silver) }
    var goldCount: Int { achievementCount(for: .gold) }
    var platinumCount: Int { achievementCount(for: .platinum) }
}
