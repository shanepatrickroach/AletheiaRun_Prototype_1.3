// Models/RunSnapshot.swift

import Foundation

/// Represents a snapshot of running data at a specific moment during a run
/// Previously called "RunInterval", now renamed for clarity
struct RunSnapshot: Identifiable, Codable {
    let id: UUID
    let snapshotNumber: Int  // Sequential number (1, 2, 3...)
    let distance: Double  // Cumulative distance at this snapshot
    let duration: TimeInterval  // Cumulative time at this snapshot
    let timestamp: Date  // When this snapshot was captured
    
    let performanceMetrics: PerformanceMetrics
    let injuryMetrics: InjuryMetrics
    let gaitCycleMetrics: GaitCycleMetrics  // NEW: Add gait cycle data
    
    // Computed properties
    var formattedDistance: String {
        String(format: "%.2f mi", distance)
    }
    
    var formattedPace: String {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    init(
        id: UUID = UUID(),
        snapshotNumber: Int,
        distance: Double,
        duration: TimeInterval,
        timestamp: Date,
        performanceMetrics: PerformanceMetrics,
        injuryMetrics: InjuryMetrics,
        gaitCycleMetrics: GaitCycleMetrics = GaitCycleMetrics()  // NEW
    ) {
        self.id = id
        self.snapshotNumber = snapshotNumber
        self.distance = distance
        self.duration = duration
        self.timestamp = timestamp
        self.performanceMetrics = performanceMetrics
        self.injuryMetrics = injuryMetrics
        self.gaitCycleMetrics = gaitCycleMetrics
    }
}

// MARK: - Performance Metrics
struct PerformanceMetrics: Codable {
    let efficiency: Int
    let braking: Int
    let impact: Int
    let sway: Int
    let variation: Int
    let warmup: Int
    let endurance: Int
    
    var overallScore: Int {
        (efficiency + sway + braking + endurance + warmup + impact + variation) / 7
    }
    
    var allMetrics: [(name: String, value: Int, description: String)] {
        [
            ("Efficiency", efficiency, "Energy economy during running"),
            ("Sway", sway, "Lateral movement and stability"),
            ("Braking", braking, "Deceleration forces"),
            ("Endurance", endurance, "Sustained performance capability"),
            ("Warmup", warmup, "Initial readiness quality"),
            ("Impact", impact, "Ground contact force"),
            ("Variation", variation, "Stride consistency")
        ]
    }
}

// MARK: - Injury Metrics
struct InjuryMetrics: Codable {
    let hipMobility: Int
    let hipStability: Int
    let portraitSymmetry: Int
    
    var riskLevel: RiskLevel {
        let average = (hipMobility + hipStability + portraitSymmetry) / 3
        if average >= 75 {
            return .low
        } else if average >= 50 {
            return .moderate
        } else {
            return .high
        }
    }
    
    var allMetrics: [(name: String, value: Int, description: String)] {
        [
            ("Hip Mobility", hipMobility, "Range of motion in hip joint"),
            ("Hip Stability", hipStability, "Ability to control hip movement"),
            ("Portrait Symmetry", portraitSymmetry, "Balance between left and right sides")
        ]
    }
}

// MARK: - Risk Level
enum RiskLevel: String, Codable {
    case low = "Low Risk"
    case moderate = "Moderate Risk"
    case high = "High Risk"
    
    var icon: String {
        switch self {
        case .low: return "checkmark.shield.fill"
        case .moderate: return "exclamationmark.shield.fill"
        case .high: return "xmark.shield.fill"
        }
    }
}

// MARK: - Sample Data Generation
extension RunSnapshot {
    static func generateSampleSnapshots(count: Int) -> [RunSnapshot] {
        var snapshots: [RunSnapshot] = []
        let baseDate = Date()
        
        for i in 0..<count {
            let snapshot = RunSnapshot(
                snapshotNumber: i + 1,
                distance: Double(i + 1) * 0.5,
                duration: Double(i + 1) * 240,
                timestamp: baseDate.addingTimeInterval(Double(i) * 240),
                performanceMetrics: PerformanceMetrics(
                    efficiency: Int.random(in: 70...90),
                    braking: Int.random(in: 65...85),
                    impact: Int.random(in: 70...88),
                    sway: Int.random(in: 75...90),
                    variation: Int.random(in: 70...85),
                    warmup: Int.random(in: 65...90),
                    endurance: Int.random(in: 68...85)
                ),
                injuryMetrics: InjuryMetrics(
                    hipMobility: Int.random(in: 60...85),
                    hipStability: Int.random(in: 65...90),
                    portraitSymmetry: Int.random(in: 70...90)
                ),
                gaitCycleMetrics: SampleData.randomGaitCycleMetrics()
            )
            snapshots.append(snapshot)
        }
        
        return snapshots
    }
    
    static var sample: RunSnapshot {
        RunSnapshot(
            snapshotNumber: 1,
            distance: 0.5,
            duration: 240,
            timestamp: Date(),
            performanceMetrics: PerformanceMetrics(
                efficiency: 85,
                braking: 55,
                impact: 72,
                sway: 78,
                variation: 80,
                warmup: 45,
                endurance: 68
            ),
            injuryMetrics: InjuryMetrics(
                hipMobility: 65,
                hipStability: 75,
                portraitSymmetry: 82
            )
        )
    }
}
