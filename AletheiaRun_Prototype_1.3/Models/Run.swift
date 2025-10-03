//
//  Run.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//

import Foundation

struct Run: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mode: RunMode
    let terrain: TerrainType
    let distance: Double  // in miles
    let duration: TimeInterval // in seconds
    
    let metrics: RunMetrics

    // NEW: Perspectives recorded
    var perspectives: Set<PerspectiveType>  // Add this

    // NEW: Like/favorite
    var isLiked: Bool  // Add this

//    var pace: String {
//        let minutes = Int(duration / 60 / distance)
//        let seconds = Int(
//            (duration / distance).truncatingRemainder(dividingBy: 60))
//        return String(format: "%d:%02d", minutes, seconds)
//    }
//    
    

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        mode: RunMode,
        terrain: TerrainType,
        distance: Double,
        duration: TimeInterval,
        
        metrics: RunMetrics,
        perspectives: Set<PerspectiveType> = [.top, .side, .rear],  // Default all
        isLiked: Bool = false
        
    ) {
        self.id = id
        self.date = date
        self.mode = mode
        self.terrain = terrain
        self.distance = distance
        
        self.duration = duration
        self.metrics = metrics
        self.perspectives = perspectives
        self.isLiked = isLiked
    
    }
}

enum TerrainType: String, Codable, CaseIterable {
    case road = "Road"
    case trail = "Trail"
    case track = "Track"
    case treadmill = "Treadmill"

    var icon: String {
        switch self {
        case .road: return "road.lanes"
        case .trail: return "mountain.2.fill"
        case .track: return "oval"
        case .treadmill: return "figure.walk.treadmill"
        }
    }

    var description: String {
        switch self {
        case .road: return "Paved roads and sidewalks"
        case .trail: return "Off-road trails and paths"
        case .treadmill: return "Indoor treadmill"
        case .track: return "Running track"
        }
    }
}

struct RunMetrics: Codable {
    let efficiency: Int  // 0-100
    let sway: Int  // 0-100
    let endurance: Int  // 0-100
    let warmup: Int  // 0-100
    let impact: Int  // 0-100
    let braking: Int  // 0-100
    let variation: Int  // 0-100

    var overallScore: Int {
        let scores = [
            efficiency, sway, endurance, warmup, impact, braking, variation,
        ]
        return scores.reduce(0, +) / scores.count
    }
}

// MARK: - Perspective Type (NEW)
enum PerspectiveType: String, Codable, CaseIterable {
    case top = "Top"
    case side = "Side"
    case rear = "Rear"

    var icon: String {
        switch self {
        case .top: return "arrow.up.circle.fill"
        case .side: return "arrow.left.and.right.circle.fill"
        case .rear: return "arrow.down.circle.fill"
        }
    }

    //    var color: Color {
    //        switch self {
    //        case .top: return .infoBlue
    //        case .side: return .primaryOrange
    //        case .rear: return .successGreen
    //        }
    //    }
}

// MARK: - Run Mode
enum RunMode: String, CaseIterable, Codable {
    case run = "Run"
    case walk = "Walk"
    case sprint = "Sprint"
    case flexible = "Flexible"
    case live = "Live"

    var icon: String {
        switch self {
        case .run: return "figure.run"
        case .walk: return "figure.walk"
        case .sprint: return "hare.fill"
        case .flexible: return "figure.flexibility"
        case .live: return "waveform.path.ecg"
        }
    }

    var description: String {
        switch self {
        case .run: return "Standard running session"
        case .walk: return "Walking or recovery"
        case .sprint: return "High intensity intervals"
        case .flexible: return "Mixed pace workout"
        case .live: return "Real-time analysis"
        }
    }
}

// MARK: - Run Configuration
struct RunConfiguration {
    var mode: RunMode
    var terrain: TerrainType
    var sensorConnected: Bool
    var sensorBattery: Int?

    var isValid: Bool {
        return sensorConnected && (sensorBattery ?? 0) > 10
    }
}

// MARK: - Pain Point
enum PainPoint: String, CaseIterable {
    case knee = "Knee"
    case hip = "Hip"
    case ankle = "Ankle"
    case shin = "Shin"
    case foot = "Foot"
    case back = "Lower Back"
    case other = "Other"

    var icon: String {
        switch self {
        case .knee: return "figure.walk"
        case .hip: return "figure.flexibility"
        case .ankle: return "figure.run"
        case .shin: return "figure.run"
        case .foot: return "shoe.fill"
        case .back: return "figure.stand"
        case .other: return "bandage.fill"
        }
    }
}

// MARK: - Energy Level
enum EnergyLevel: Int, CaseIterable {
    case veryLow = 1
    case low = 2
    case moderate = 3
    case high = 4
    case veryHigh = 5

    var title: String {
        switch self {
        case .veryLow: return "Very Low"
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        }
    }

    var emoji: String {
        switch self {
        case .veryLow: return "😫"
        case .low: return "😔"
        case .moderate: return "😐"
        case .high: return "😊"
        case .veryHigh: return "🤩"
        }
    }
}

// MARK: - Post Run Survey
struct PostRunSurvey {
    var painPoints: Set<PainPoint> = []
    var painPointDetails: String = ""
    var energyLevel: EnergyLevel = .moderate
    var perceivedEffort: Int = 5  // 1-10 scale
    var notes: String = ""
    var wouldRecommendSettings: Bool = true
}
