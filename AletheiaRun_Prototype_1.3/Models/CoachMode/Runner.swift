//
//  Runner.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import Foundation

// MARK: - Runner Model
/// Represents an athlete that a coach is working with
struct Runner: Identifiable, Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var profileImageName: String? // Placeholder for profile image
    var dateAdded: Date
    var notes: String
    
    // Stats
    var totalRuns: Int
    var totalDistance: Double // in miles
    var averageEfficiency: Int // 0-100
    var currentStreak: Int // days
    
    // Computed Properties
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let first = firstName.prefix(1)
        let last = lastName.prefix(1)
        return "\(first)\(last)".uppercased()
    }
    
    var formattedTotalDistance: String {
        String(format: "%.1f mi", totalDistance)
    }
    
    init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        email: String,
        profileImageName: String? = nil,
        dateAdded: Date = Date(),
        notes: String = "",
        totalRuns: Int = 0,
        totalDistance: Double = 0,
        averageEfficiency: Int = 0,
        currentStreak: Int = 0
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImageName = profileImageName
        self.dateAdded = dateAdded
        self.notes = notes
        self.totalRuns = totalRuns
        self.totalDistance = totalDistance
        self.averageEfficiency = averageEfficiency
        self.currentStreak = currentStreak
    }
    
    // MARK: - Sample Data
    static let sampleRunners: [Runner] = [
        Runner(
            firstName: "Sarah",
            lastName: "Johnson",
            email: "sarah.j@email.com",
            dateAdded: Date().addingTimeInterval(-2592000), // 30 days ago
            notes: "Marathon training - targeting sub 3:30",
            totalRuns: 45,
            totalDistance: 234.5,
            averageEfficiency: 82,
            currentStreak: 12
        ),
        Runner(
            firstName: "Michael",
            lastName: "Chen",
            email: "mchen@email.com",
            dateAdded: Date().addingTimeInterval(-5184000), // 60 days ago
            notes: "Recovering from knee injury, focus on form",
            totalRuns: 28,
            totalDistance: 156.8,
            averageEfficiency: 75,
            currentStreak: 5
        ),
        Runner(
            firstName: "Emily",
            lastName: "Rodriguez",
            email: "emily.r@email.com",
            dateAdded: Date().addingTimeInterval(-7776000), // 90 days ago
            notes: "Track athlete - working on sprint mechanics",
            totalRuns: 62,
            totalDistance: 187.3,
            averageEfficiency: 88,
            currentStreak: 18
        ),
        Runner(
            firstName: "James",
            lastName: "Williams",
            email: "jwilliams@email.com",
            dateAdded: Date().addingTimeInterval(-1296000), // 15 days ago
            notes: "New runner - building base mileage",
            totalRuns: 15,
            totalDistance: 52.4,
            averageEfficiency: 68,
            currentStreak: 3
        ),
        Runner(
            firstName: "Lisa",
            lastName: "Thompson",
            email: "lisa.t@email.com",
            dateAdded: Date().addingTimeInterval(-10368000), // 120 days ago
            notes: "Ultra training - emphasis on endurance",
            totalRuns: 78,
            totalDistance: 412.6,
            averageEfficiency: 79,
            currentStreak: 21
        )
    ]
}

// MARK: - Runner with Runs
/// Associates a runner with their run data
struct RunnerWithRuns: Identifiable {
    let runner: Runner
    var runs: [Run]
    
    var id: UUID { runner.id }
    
    // Computed stats from runs
    var recentRuns: [Run] {
        Array(runs.prefix(5))
    }
    
    var lastRunDate: Date? {
        runs.first?.date
    }
    
    var averagePace: String {
        guard !runs.isEmpty else { return "0:00" }
        let totalPace = runs.reduce(0.0) { result, run in
            result + (run.duration / 60 / run.distance)
        }
        let avgPace = totalPace / Double(runs.count)
        let minutes = Int(avgPace)
        let seconds = Int((avgPace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}