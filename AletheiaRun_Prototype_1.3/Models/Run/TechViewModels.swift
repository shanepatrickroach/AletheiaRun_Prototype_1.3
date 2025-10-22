//
//  TechViewModels.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

//
//  TechViewModels.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import Foundation

// MARK: - Gait Phase
/// The four phases of the running gait cycle
enum GaitPhase: String, CaseIterable, Identifiable {
    case landing = "Landing"
    case stabilizing = "Stabilizing"
    case launching = "Launching"
    case flying = "Flying"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .landing:
            return "Initial foot contact with the ground"
        case .stabilizing:
            return "Body weight shifts over the supporting leg"
        case .launching:
            return "Push-off phase propelling forward"
        case .flying:
            return "Both feet off the ground, airborne"
        }
    }
    
    var icon: String {
        switch self {
        case .landing: return "arrow.down.circle"
        case .stabilizing: return "figure.stand"
        case .launching: return "arrow.up.circle"
        case .flying: return "figure.run"
        }
    }
}

// MARK: - Leg Selection
/// Filter for viewing specific leg data
enum LegSelection: String, CaseIterable, Identifiable {
    case both = "Both"
    case left = "Left"
    case right = "Right"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .both: return "figure.run"
        case .left: return "l.square.fill"
        case .right: return "r.square.fill"
        }
    }
}






// MARK: - Tech View Snapshot
/// Represents a single Force Portrait snapshot with all its metadata
/// This extends the interval data with specific snapshot information
struct TechViewSnapshot: Identifiable {
    let id: UUID
    let intervalNumber: Int // Which interval this snapshot belongs to
    let perspective: PerspectiveType
    let phase: GaitPhase
    let leg: LegSelection
    let timestamp: TimeInterval // Time in the run when captured
    let imageName: String // Will be replaced with actual image data from API
    
    init(
        id: UUID = UUID(),
        intervalNumber: Int,
        perspective: PerspectiveType,
        phase: GaitPhase,
        leg: LegSelection,
        timestamp: TimeInterval,
        imageName: String = "ForcePortrait" // Placeholder
    ) {
        self.id = id
        self.intervalNumber = intervalNumber
        self.perspective = perspective
        self.phase = phase
        self.leg = leg
        self.timestamp = timestamp
        self.imageName = imageName
    }
    
    // MARK: - Sample Data Generator
    /// Generates sample snapshots for all combinations across intervals
    static func generateSampleSnapshots(intervalCount: Int = 6) -> [TechViewSnapshot] {
        var snapshots: [TechViewSnapshot] = []
        var timestamp: TimeInterval = 0
        
        // For each interval
        for intervalNum in 1...intervalCount {
            // Generate snapshots for each perspective
            for perspective in PerspectiveType.allCases {
                // Generate for each phase
                for phase in GaitPhase.allCases {
                    // Generate for each leg
                    for leg in LegSelection.allCases {
                        let snapshot = TechViewSnapshot(
                            intervalNumber: intervalNum,
                            perspective: perspective,
                            phase: phase,
                            leg: leg,
                            timestamp: timestamp
                        )
                        snapshots.append(snapshot)
                        timestamp += 0.25 // Quarter second intervals
                    }
                }
            }
        }
        
        return snapshots
    }
}
