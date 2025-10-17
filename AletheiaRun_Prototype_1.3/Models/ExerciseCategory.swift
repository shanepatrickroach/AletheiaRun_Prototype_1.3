//
//  ExerciseCategory.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Models/Exercise.swift

import Foundation
//
//// MARK: - Exercise Category
//enum ExerciseCategory: String, CaseIterable {
//    case strength = "Strength"
//    case mobility = "Mobility"
//    case form = "Form"
//    case recovery = "Recovery"
//    case warmup = "Warm-up"
//    
//    var icon: String {
//        switch self {
//        case .strength: return "dumbbell.fill"
//        case .mobility: return "figure.flexibility"
//        case .form: return "figure.run"
//        case .recovery: return "bed.double.fill"
//        case .warmup: return "flame.fill"
//        }
//    }
//    
//    var color: String {
//        switch self {
//        case .strength: return "errorRed"
//        case .mobility: return "infoBlue"
//        case .form: return "primaryOrange"
//        case .recovery: return "successGreen"
//        case .warmup: return "warningYellow"
//        }
//    }
//}
//
//// MARK: - Exercise Difficulty
//enum ExerciseDifficulty: String {
//    case beginner = "Beginner"
//    case intermediate = "Intermediate"
//    case advanced = "Advanced"
//}
//
//// MARK: - Exercise Model
//struct Exercise: Identifiable {
//    let id = UUID()
//    let title: String
//    let category: ExerciseCategory
//    let difficulty: ExerciseDifficulty
//    let duration: String // "5 min" or "10 reps"
//    let description: String
//    let targetMetrics: [String] // ["Efficiency", "Impact"]
//    let videoURL: String? // Future: tutorial video
//    let instructions: [String]
//    
//    // Priority based on user's metrics
//    var priority: Int = 0
//}
//
//// MARK: - Sample Exercise Data
//extension Exercise {
//    static let sampleExercises = [
//        Exercise(
//            title: "Hip Flexor Stretch",
//            category: .mobility,
//            difficulty: .beginner,
//            duration: "5 min",
//            description: "Improve hip mobility to reduce sway and increase efficiency",
//            targetMetrics: ["Sway", "Efficiency"],
//            videoURL: nil,
//            instructions: [
//                "Kneel on your right knee with left foot forward",
//                "Push hips forward gently",
//                "Hold for 30 seconds each side",
//                "Repeat 3 times"
//            ],
//            priority: 95
//        ),
//        Exercise(
//            title: "Single Leg Balance",
//            category: .strength,
//            difficulty: .beginner,
//            duration: "3 min",
//            description: "Strengthen stabilizer muscles to reduce impact forces",
//            targetMetrics: ["Impact", "Stability"],
//            videoURL: nil,
//            instructions: [
//                "Stand on one leg",
//                "Maintain balance for 30 seconds",
//                "Switch legs",
//                "Repeat 3 times each side"
//            ],
//            priority: 88
//        ),
//        Exercise(
//            title: "Glute Activation",
//            category: .warmup,
//            difficulty: .beginner,
//            duration: "4 min",
//            description: "Wake up your glutes before running to improve form",
//            targetMetrics: ["Form", "Power"],
//            videoURL: nil,
//            instructions: [
//                "Lie on your back, knees bent",
//                "Lift hips off ground",
//                "Squeeze glutes at top",
//                "Lower slowly, repeat 15 times"
//            ],
//            priority: 82
//        ),
//        Exercise(
//            title: "Calf Raises",
//            category: .strength,
//            difficulty: .beginner,
//            duration: "3 min",
//            description: "Build calf strength for better push-off",
//            targetMetrics: ["Power", "Efficiency"],
//            videoURL: nil,
//            instructions: [
//                "Stand with feet hip-width apart",
//                "Rise up onto toes",
//                "Hold for 2 seconds",
//                "Lower slowly, repeat 20 times"
//            ],
//            priority: 75
//        ),
//        Exercise(
//            title: "Foam Roll IT Band",
//            category: .recovery,
//            difficulty: .beginner,
//            duration: "5 min",
//            description: "Release tension in IT band to prevent knee pain",
//            targetMetrics: ["Recovery", "Flexibility"],
//            videoURL: nil,
//            instructions: [
//                "Lie on side with foam roller under hip",
//                "Roll from hip to knee slowly",
//                "Pause on tender spots",
//                "2 minutes each side"
//            ],
//            priority: 70
//        )
//    ]
//}
