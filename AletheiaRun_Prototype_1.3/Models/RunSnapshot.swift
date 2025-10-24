// Models/RunSnapshot.swift

import Foundation
import SwiftUI

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
        (efficiency + sway + braking + endurance + warmup + impact + variation)
            / 7
    }

    var allMetrics: [(name: String, value: Int, description: String)] {
        [
            ("Efficiency", efficiency, "Energy economy during running"),
            ("Sway", sway, "Lateral movement and stability"),
            ("Braking", braking, "Deceleration forces"),
            ("Endurance", endurance, "Sustained performance capability"),
            ("Warmup", warmup, "Initial readiness quality"),
            ("Impact", impact, "Ground contact force"),
            ("Variation", variation, "Stride consistency"),
        ]
    }
}

// MARK: - Injury Metrics
struct InjuryMetrics: Codable {
    let leftLeg: LegInjuryMetrics
    let rightLeg: LegInjuryMetrics

    // Overall averages across both legs
    var hipMobility: Int {
        (leftLeg.hipMobility + rightLeg.hipMobility) / 2
    }

    var hipStability: Int {
        (leftLeg.hipStability + rightLeg.hipStability) / 2
    }

    var portraitSymmetry: Int {
        // Calculate symmetry based on differences between legs
        let mobilityDiff = abs(leftLeg.hipMobility - rightLeg.hipMobility)
        let stabilityDiff = abs(leftLeg.hipStability - rightLeg.hipStability)

        // Lower difference = higher symmetry score
        let avgDifference = (mobilityDiff + stabilityDiff) / 2
        return max(0, 100 - (avgDifference * 2))
    }

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
            (
                "Portrait Symmetry", portraitSymmetry,
                "Balance between left and right sides"
            ),
        ]
    }

    // New: Get metrics for specific leg
    func metricsForLeg(_ leg: LegSide) -> [(
        name: String, value: Int, description: String
    )] {
        let legMetrics = leg == .left ? leftLeg : rightLeg
        return [
            (
                "Hip Mobility", legMetrics.hipMobility,
                "Range of motion in hip joint"
            ),
            (
                "Hip Stability", legMetrics.hipStability,
                "Ability to control hip movement"
            ),
        ]
    }

    init(leftLeg: LegInjuryMetrics, rightLeg: LegInjuryMetrics) {
        self.leftLeg = leftLeg
        self.rightLeg = rightLeg
    }

    // Convenience init for backward compatibility
    init(hipMobility: Int, hipStability: Int, portraitSymmetry: Int) {
        // Split evenly between legs with slight variation
        self.leftLeg = LegInjuryMetrics(
            hipMobility: hipMobility,
            hipStability: hipStability
        )
        self.rightLeg = LegInjuryMetrics(
            hipMobility: hipMobility,
            hipStability: hipStability
        )
    }
}

// MARK: - Leg Injury Metrics
struct LegInjuryMetrics: Codable {
    let hipMobility: Int  // 0-100
    let hipStability: Int  // 0-100

    var overallScore: Int {
        (hipMobility + hipStability) / 2
    }
}

// MARK: - Leg Side Enum
enum LegSide: String, CaseIterable {
    case left = "Left"
    case right = "Right"

    var icon: String {
        switch self {
        case .left: return "l.square.fill"
        case .right: return "r.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .left: return .infoBlue
        case .right: return .successGreen
        }
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
                    leftLeg: LegInjuryMetrics(
                        hipMobility: Int.random(in: 60...90),
                        hipStability: Int.random(in: 65...90)
                    ),
                    rightLeg: LegInjuryMetrics(
                        hipMobility: Int.random(in: 60...90),
                        hipStability: Int.random(in: 65...90)
                    )
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
                leftLeg: LegInjuryMetrics(
                    hipMobility: 75,
                    hipStability: 82
                ),
                rightLeg: LegInjuryMetrics(
                    hipMobility: 70,
                    hipStability: 78
                )
            )
        )
    }
}
