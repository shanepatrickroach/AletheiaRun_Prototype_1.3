//
//  Run.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//

import Foundation
import SwiftUI

struct Run: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mode: RunMode
    let terrain: TerrainType
    let distance: Double  // in miles
    let duration: TimeInterval  // in seconds

    let metrics: RunMetrics
    let gaitCycleMetrics: GaitCycleMetrics

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
        gaitCycleMetrics: GaitCycleMetrics = GaitCycleMetrics(),
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
        self.gaitCycleMetrics = gaitCycleMetrics
        self.perspectives = perspectives
        self.isLiked = isLiked

    }
}

struct GaitCycleMetrics: Codable {
    // Left leg gait cycle
    let leftLeg: LegGaitCycle
    
    // Right leg gait cycle
    let rightLeg: LegGaitCycle
    
    // Overall timing metrics (averaged between legs)
    let contactTime: Double  // milliseconds on ground
    let flightTime: Double   // milliseconds in air
    let cadence: Int         // steps per minute
    
    init(
        leftLeg: LegGaitCycle = LegGaitCycle(),
        rightLeg: LegGaitCycle = LegGaitCycle(),
        contactTime: Double = 250.0,
        flightTime: Double = 100.0,
        cadence: Int = 170
    ) {
        self.leftLeg = leftLeg
        self.rightLeg = rightLeg
        self.contactTime = contactTime
        self.flightTime = flightTime
        self.cadence = cadence
    }
    
    /// Average of left and right leg metrics
    var averageCycle: LegGaitCycle {
        LegGaitCycle(
            landing: (leftLeg.landing + rightLeg.landing) / 2,
            stabilizing: (leftLeg.stabilizing + rightLeg.stabilizing) / 2,
            launching: (leftLeg.launching + rightLeg.launching) / 2,
            flying: (leftLeg.flying + rightLeg.flying) / 2
        )
    }
    
    /// Symmetry score (0-100, higher is better)
    var symmetryScore: Int {
        let landingDiff = abs(leftLeg.landing - rightLeg.landing)
        let stabilizingDiff = abs(leftLeg.stabilizing - rightLeg.stabilizing)
        let launchingDiff = abs(leftLeg.launching - rightLeg.launching)
        let flyingDiff = abs(leftLeg.flying - rightLeg.flying)
        
        let totalDiff = landingDiff + stabilizingDiff + launchingDiff + flyingDiff
        return max(0, 100 - Int(totalDiff * 2))
    }
}

struct LegGaitCycle: Codable {
    let landing: Double      // % of time in landing phase
    let stabilizing: Double  // % of time in stabilizing phase
    let launching: Double    // % of time in launching phase
    let flying: Double       // % of time in flying phase
    
    init(
        landing: Double = 15.0,
        stabilizing: Double = 20.0,
        launching: Double = 15.0,
        flying: Double = 50.0
    ) {
        self.landing = landing
        self.stabilizing = stabilizing
        self.launching = launching
        self.flying = flying
    }
    
    /// Total contact time percentage (landing + stabilizing + launching)
    var contactPercentage: Double {
        landing + stabilizing + launching
    }
    
    /// Flight time percentage
    var flightPercentage: Double {
        flying
    }
    
    /// Validates that all phases add up to approximately 100%
    var isValid: Bool {
        let total = landing + stabilizing + launching + flying
        return abs(total - 100.0) < 0.1
    }
}

// MARK: - Gait Cycle Phase (NEW)
/// Defines the four phases of the gait cycle with their associated colors
enum GaitCyclePhase: String, CaseIterable, Identifiable {
    case landing = "Landing"
    case stabilizing = "Stabilizing"
    case launching = "Launching"
    case flying = "Flying"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .landing: return Color(hex: "EA1E1B")  // Red - Impact
        case .stabilizing: return Color(hex: "FDED27")  // Yellow - Support
        case .launching: return Color(hex: "4EE12A")  // Green - Propulsion
        case .flying: return Color(hex: "2854EE")  // Blue - Flight
        }
    }

    var icon: String {
        switch self {
        case .landing: return "landing"
        case .stabilizing: return "stabilizing"
        case .launching: return "launching"
        case .flying: return "flying"
        }
    }

    var description: String {
        switch self {
        case .landing:
            return "Initial contact with the ground, absorbing impact forces"
        case .stabilizing:
            return "Body weight transfers over the foot, maintaining balance"
        case .launching:
            return "Pushing off the ground to propel forward"
        case .flying:
            return "Both feet off the ground, body in flight"
        }
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
    let braking: Int  // 0-100
    let impact: Int  // 0-100
    let sway: Int  // 0-100
    let variation: Int  // 0-100
    let warmup: Int  // 0-100
    let endurance: Int  // 0-100
    
    
    var overallScore: Int {
        let scores = [
            efficiency, sway, endurance, warmup, impact, braking, variation,
        ]
        return scores.reduce(0, +) / scores.count
    }
    
    
}

//
//enum LegSide: String {
//    case right = "right"
//    case left = "left"
//}

// MARK: - Perspective Type (NEW)
enum PerspectiveType: String, Codable, CaseIterable, Identifiable {
    case top = "Top"
    case side = "Side"
    case rear = "Rear"
    
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .top: return "arrow.up.circle.fill"
        case .side: return "arrow.left.and.right.circle.fill"
        case .rear: return "arrow.down.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .top: return .infoBlue
        case .side: return .primaryOrange
        case .rear: return .successGreen
        }
    }
}

// MARK: - Run Mode
enum RunMode: String, CaseIterable, Codable {
    case run = "Run"
    case walk = "Walk"
    case sprint = "Sprint"
    case live = "Live"

    var icon: String {
        switch self {
        case .run: return "figure.run"
        case .walk: return "figure.walk"
        case .sprint: return "hare.fill"
        case .live: return "waveform.path.ecg"
        }
    }

    var description: String {
        switch self {
        case .run: return "Standard running session"
        case .walk: return "Walking or recovery"
        case .sprint: return "High intensity intervals"
        case .live: return "Real-time analysis"
        }
    }
    
    var isBetaFeature: Bool {
        switch self {
        case .run: return false
        case .walk: return false
        case .sprint: return true
        case .live: return true
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
