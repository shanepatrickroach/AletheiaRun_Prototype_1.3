//
//  Exercise.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//


//
//  Exercise.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import Foundation
import SwiftUI

// MARK: - Exercise Model
/// Represents a recommended exercise for improving running metrics
struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let targetMetric: ExerciseMetric
    let level: ExerciseLevel
    let duration: String // e.g., "10 minutes", "3 sets of 10"
    let description: String
    let instructions: [String]
    let benefits: [String]
    let equipmentNeeded: [String]
    let videoThumbnail: String // Placeholder for video thumbnail
    let difficultyRating: Int // 1-5 stars
    
    var isCompleted: Bool = false
    var lastCompletedDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        targetMetric: ExerciseMetric,
        level: ExerciseLevel,
        duration: String,
        description: String,
        instructions: [String],
        benefits: [String],
        equipmentNeeded: [String] = [],
        videoThumbnail: String = "figure.run",
        difficultyRating: Int,
        isCompleted: Bool = false,
        lastCompletedDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.targetMetric = targetMetric
        self.level = level
        self.duration = duration
        self.description = description
        self.instructions = instructions
        self.benefits = benefits
        self.equipmentNeeded = equipmentNeeded
        self.videoThumbnail = videoThumbnail
        self.difficultyRating = difficultyRating
        self.isCompleted = isCompleted
        self.lastCompletedDate = lastCompletedDate
    }
}

// MARK: - Exercise Metric
enum ExerciseMetric: String, CaseIterable, Codable {
    case impact = "Impact"
    case braking = "Braking"
    case sway = "Sway"
    case cadence = "Cadence"
    case flightTime = "Flight Time"
    case contactTime = "Contact Time"
    case hipMobility = "Hip Mobility"
    case hipStability = "Hip Stability"
    
    var icon: String {
        switch self {
        case .impact: return "arrow.down.circle.fill"
        case .braking: return "hand.raised.fill"
        case .sway: return "arrow.left.and.right"
        case .cadence: return "metronome.fill"
        case .flightTime: return "airplane.circle.fill"
        case .contactTime: return "timer"
        case .hipMobility: return "figure.walk.motion"
        case .hipStability: return "figure.stand"
        }
    }
    
    var color: Color {
        switch self {
        case .impact: return .warningYellow
        case .braking: return .errorRed
        case .sway: return .infoBlue
        case .cadence: return .primaryOrange
        case .flightTime: return .infoBlue
        case .contactTime: return .errorRed
        case .hipMobility: return .primaryOrange
        case .hipStability: return .successGreen
        }
    }
}

// MARK: - Exercise Level
enum ExerciseLevel: String, CaseIterable, Codable {
    case foundational = "Foundational"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var title: String { rawValue }
    
    var scoreRange: ClosedRange<Int> {
        switch self {
        case .foundational: return 0...33
        case .intermediate: return 34...66
        case .advanced: return 67...100
        }
    }
    
    var color: Color {
        switch self {
        case .foundational: return .errorRed
        case .intermediate: return .warningYellow
        case .advanced: return .successGreen
        }
    }
    
    var icon: String {
        switch self {
        case .foundational: return "1.circle.fill"
        case .intermediate: return "2.circle.fill"
        case .advanced: return "3.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .foundational:
            return "Building the basics - focus on form and foundation"
        case .intermediate:
            return "Progressing skills - increasing difficulty and complexity"
        case .advanced:
            return "Elite performance - maximizing efficiency and power"
        }
    }
    
    static func forScore(_ score: Int) -> ExerciseLevel {
        if score <= 33 { return .foundational }
        if score <= 66 { return .intermediate }
        return .advanced
    }
}

// MARK: - Training Plan
struct TrainingPlan: Identifiable {
    let id: UUID
    let generatedDate: Date
    let exercises: [Exercise]
    let targetedMetrics: [ExerciseMetric: Int] // Metric -> Current Score
    let painPoints: [PainPoint]
    
    var completionRate: Double {
        guard !exercises.isEmpty else { return 0 }
        let completed = exercises.filter { $0.isCompleted }.count
        return Double(completed) / Double(exercises.count)
    }
    
    var totalExercises: Int {
        exercises.count
    }
    
    var completedExercises: Int {
        exercises.filter { $0.isCompleted }.count
    }
    
    init(
        id: UUID = UUID(),
        generatedDate: Date = Date(),
        exercises: [Exercise],
        targetedMetrics: [ExerciseMetric: Int],
        painPoints: [PainPoint] = []
    ) {
        self.id = id
        self.generatedDate = generatedDate
        self.exercises = exercises
        self.targetedMetrics = targetedMetrics
        self.painPoints = painPoints
    }
}

// MARK: - Sample Exercise Library
extension Exercise {
    static let sampleLibrary: [Exercise] = [
        // MARK: Impact Exercises
        Exercise(
            name: "Quiet Feet Drill",
            targetMetric: .impact,
            level: .foundational,
            duration: "3 sets of 30 seconds",
            description: "Focus on landing softly with each step, minimizing ground contact noise.",
            instructions: [
                "Run in place at a comfortable pace",
                "Focus on landing as quietly as possible",
                "Keep knees slightly bent on landing",
                "Land on midfoot, not heel",
                "Maintain upright posture"
            ],
            benefits: [
                "Reduces ground impact forces",
                "Improves landing mechanics",
                "Decreases injury risk"
            ],
            equipmentNeeded: [],
            difficultyRating: 2
        ),
        
        Exercise(
            name: "Single-Leg Hops",
            targetMetric: .impact,
            level: .intermediate,
            duration: "3 sets of 10 per leg",
            description: "Controlled hopping on one leg to build landing strength and control.",
            instructions: [
                "Stand on one leg with slight knee bend",
                "Hop forward 6-12 inches",
                "Land softly on midfoot",
                "Stabilize before next hop",
                "Switch legs after completing set"
            ],
            benefits: [
                "Strengthens landing muscles",
                "Improves single-leg stability",
                "Reduces impact through better control"
            ],
            equipmentNeeded: [],
            difficultyRating: 3
        ),
        
        Exercise(
            name: "Depth Drops",
            targetMetric: .impact,
            level: .advanced,
            duration: "3 sets of 8 reps",
            description: "Step off a box and land with minimal ground contact time.",
            instructions: [
                "Stand on 12-18 inch box",
                "Step off (don't jump)",
                "Land on both feet simultaneously",
                "Absorb impact with bent knees",
                "Immediately jump vertically"
            ],
            benefits: [
                "Develops reactive strength",
                "Improves eccentric control",
                "Maximizes landing efficiency"
            ],
            equipmentNeeded: ["Box or step (12-18 inches)"],
            difficultyRating: 5
        ),
        
        // MARK: Braking Exercises
        Exercise(
            name: "Cadence Drills",
            targetMetric: .braking,
            level: .foundational,
            duration: "5 minutes",
            description: "Increase step rate to reduce overstriding and braking forces.",
            instructions: [
                "Use metronome set to 170-180 BPM",
                "Match your steps to the beat",
                "Take shorter, quicker steps",
                "Land with foot under hips",
                "Maintain relaxed upper body"
            ],
            benefits: [
                "Reduces overstriding",
                "Decreases braking forces",
                "Improves running economy"
            ],
            equipmentNeeded: ["Metronome or app"],
            difficultyRating: 1
        ),
        
        Exercise(
            name: "Wall Lean Drills",
            targetMetric: .braking,
            level: .intermediate,
            duration: "3 sets of 20 seconds",
            description: "Practice proper forward lean to reduce heel striking.",
            instructions: [
                "Lean against wall at arm's length",
                "Keep body straight from ankles up",
                "Run in place maintaining lean",
                "Focus on lifting knees, not pushing back",
                "Gradually move away from wall"
            ],
            benefits: [
                "Teaches proper forward lean",
                "Reduces heel striking",
                "Promotes midfoot landing"
            ],
            equipmentNeeded: ["Wall"],
            difficultyRating: 2
        ),
        
        // MARK: Sway Exercises
        Exercise(
            name: "Single-Leg Balance",
            targetMetric: .sway,
            level: .foundational,
            duration: "3 sets of 30 seconds per leg",
            description: "Stand on one leg to improve hip stability and reduce lateral movement.",
            instructions: [
                "Stand on one leg",
                "Keep hips level",
                "Engage core muscles",
                "Hold for 30 seconds",
                "Switch legs"
            ],
            benefits: [
                "Strengthens hip stabilizers",
                "Reduces lateral sway",
                "Improves balance"
            ],
            equipmentNeeded: [],
            difficultyRating: 1
        ),
        
        Exercise(
            name: "Lateral Band Walks",
            targetMetric: .sway,
            level: .intermediate,
            duration: "3 sets of 10 steps each direction",
            description: "Strengthen hip abductors to minimize side-to-side movement.",
            instructions: [
                "Place resistance band around ankles",
                "Assume quarter squat position",
                "Step sideways maintaining tension",
                "Keep hips level throughout",
                "Return in opposite direction"
            ],
            benefits: [
                "Strengthens glute medius",
                "Reduces hip drop",
                "Improves lateral stability"
            ],
            equipmentNeeded: ["Resistance band"],
            difficultyRating: 3
        ),
        
        // MARK: Hip Mobility Exercises
        Exercise(
            name: "90/90 Hip Stretch",
            targetMetric: .hipMobility,
            level: .foundational,
            duration: "2 minutes per side",
            description: "Improve hip internal and external rotation range of motion.",
            instructions: [
                "Sit with front leg at 90 degrees",
                "Back leg also at 90 degrees",
                "Keep back straight",
                "Lean forward over front leg",
                "Hold stretch, then switch sides"
            ],
            benefits: [
                "Increases hip mobility",
                "Improves stride length",
                "Reduces hip tightness"
            ],
            equipmentNeeded: ["Yoga mat"],
            difficultyRating: 2
        ),
        
        Exercise(
            name: "Walking Hip Openers",
            targetMetric: .hipMobility,
            level: .intermediate,
            duration: "2 sets of 10 per leg",
            description: "Dynamic hip mobility exercise to increase range of motion.",
            instructions: [
                "Stand on one leg",
                "Lift other knee to hip height",
                "Rotate knee outward",
                "Step forward into lunge",
                "Repeat on opposite leg"
            ],
            benefits: [
                "Dynamic hip mobility",
                "Prepares hips for running",
                "Increases flexibility"
            ],
            equipmentNeeded: [],
            difficultyRating: 2
        ),
        
        // MARK: Hip Stability Exercises
        Exercise(
            name: "Clamshells",
            targetMetric: .hipStability,
            level: .foundational,
            duration: "3 sets of 15 per side",
            description: "Strengthen glute medius and improve hip stability.",
            instructions: [
                "Lie on side with knees bent",
                "Keep feet together",
                "Lift top knee while keeping feet touching",
                "Lower with control",
                "Complete all reps, then switch sides"
            ],
            benefits: [
                "Strengthens glute medius",
                "Improves hip stability",
                "Reduces knee valgus"
            ],
            equipmentNeeded: ["Yoga mat", "Optional: resistance band"],
            difficultyRating: 1
        ),
        
        Exercise(
            name: "Single-Leg Deadlifts",
            targetMetric: .hipStability,
            level: .intermediate,
            duration: "3 sets of 10 per leg",
            description: "Build hip stability and posterior chain strength.",
            instructions: [
                "Stand on one leg",
                "Hinge at hips, reaching toward ground",
                "Keep back flat",
                "Other leg extends behind",
                "Return to standing"
            ],
            benefits: [
                "Strengthens glutes and hamstrings",
                "Improves balance",
                "Develops hip control"
            ],
            equipmentNeeded: ["Optional: dumbbell"],
            difficultyRating: 3
        ),
        
        Exercise(
            name: "Copenhagen Planks",
            targetMetric: .hipStability,
            level: .advanced,
            duration: "3 sets of 20 seconds per side",
            description: "Advanced hip abductor strengthening exercise.",
            instructions: [
                "Place top leg on bench in side plank",
                "Bottom leg hangs below",
                "Lift bottom leg to meet top leg",
                "Hold plank position",
                "Switch sides"
            ],
            benefits: [
                "Elite hip abductor strength",
                "Prevents IT band issues",
                "Maximizes lateral stability"
            ],
            equipmentNeeded: ["Bench or elevated surface"],
            difficultyRating: 5
        ),
        
        // MARK: Cadence Exercises
        Exercise(
            name: "Quick Feet Drill",
            targetMetric: .cadence,
            level: .foundational,
            duration: "5 x 30 seconds",
            description: "Increase step frequency with high-speed foot movements.",
            instructions: [
                "Run in place as fast as possible",
                "Keep steps light and quick",
                "Minimal ground contact time",
                "Stay on balls of feet",
                "Maintain for 30 seconds"
            ],
            benefits: [
                "Increases step rate",
                "Improves foot speed",
                "Enhances neuromuscular coordination"
            ],
            equipmentNeeded: [],
            difficultyRating: 2
        ),
        
        // MARK: Flight Time Exercises
        Exercise(
            name: "Bounding",
            targetMetric: .flightTime,
            level: .intermediate,
            duration: "4 sets of 30 meters",
            description: "Exaggerated running to maximize air time and forward drive.",
            instructions: [
                "Take long, powerful strides",
                "Drive knee high on each step",
                "Maximize time in air",
                "Land softly on midfoot",
                "Focus on forward momentum"
            ],
            benefits: [
                "Increases power output",
                "Improves stride length",
                "Develops explosive strength"
            ],
            equipmentNeeded: ["Open space"],
            difficultyRating: 4
        ),
        
        // MARK: Contact Time Exercises
        Exercise(
            name: "Jump Rope",
            targetMetric: .contactTime,
            level: .foundational,
            duration: "3 sets of 1 minute",
            description: "Develop quick ground contact and foot speed.",
            instructions: [
                "Jump rope at steady pace",
                "Stay on balls of feet",
                "Minimize ground contact time",
                "Keep jumps low and quick",
                "Maintain rhythm"
            ],
            benefits: [
                "Reduces contact time",
                "Improves calf strength",
                "Enhances coordination"
            ],
            equipmentNeeded: ["Jump rope"],
            difficultyRating: 2
        )
    ]
}