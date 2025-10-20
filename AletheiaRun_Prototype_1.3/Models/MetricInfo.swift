// Models/MetricInfo.swift

import Foundation
import SwiftUI

/// Comprehensive information about a specific running metric
struct MetricInfo {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let unit: String
    let optimalRange: ClosedRange<Int>
    let description: String
    let whyItMatters: [String]
    let howToOptimize: [String]
    let relatedMetrics: [String]
    let videoPlaceholderTitle: String
    
    /// Get color based on metric value
    func colorForValue(_ value: Int) -> Color {
        if value >= optimalRange.upperBound - 5 {
            return .successGreen
        } else if value >= optimalRange.lowerBound {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
    
    /// Get status text for a value
    func statusForValue(_ value: Int) -> String {
        if value >= optimalRange.upperBound - 5 {
            return "Excellent"
        } else if value >= optimalRange.lowerBound + 5 {
            return "Good"
        } else if value >= optimalRange.lowerBound {
            return "Fair"
        } else {
            return "Needs Improvement"
        }
    }
}

// MARK: - Metric Type Enum
enum MetricType: String, CaseIterable {
    case efficiency = "Efficiency"
    case sway = "Sway"
    case endurance = "Endurance"
    case warmup = "Warmup"
    case impact = "Impact"
    case braking = "Braking"
    case variation = "Variation"
    
    var info: MetricInfo {
        switch self {
        case .efficiency:
            return MetricInfo(
                id: "efficiency",
                name: "Efficiency",
                icon: "bolt.fill",
                color: .primaryOrange,
                unit: "score",
                optimalRange: 80...100,
                description: "Efficiency measures how economically you use energy while running. A higher score means you're getting more forward motion for the same amount of effort.",
                whyItMatters: [
                    "Better efficiency means you can run longer distances without fatigue",
                    "Reduces wasted energy and improves performance",
                    "Directly correlates with running economy and race times",
                    "Helps prevent early fatigue in long runs"
                ],
                howToOptimize: [
                    "Focus on a midfoot strike rather than heel striking",
                    "Maintain an upright posture with slight forward lean",
                    "Increase your cadence (steps per minute) to 170-180",
                    "Work on core strength to maintain form during fatigue",
                    "Practice running drills: high knees, butt kicks, A-skips"
                ],
                relatedMetrics: ["Sway", "Braking", "Impact"],
                videoPlaceholderTitle: "How to Improve Running Efficiency"
            )
            
        case .sway:
            return MetricInfo(
                id: "sway",
                name: "Sway",
                icon: "arrow.left.and.right",
                color: .infoBlue,
                unit: "score",
                optimalRange: 75...100,
                description: "Sway measures lateral (side-to-side) movement while running. Lower sway means your energy is directed forward rather than being wasted on unnecessary side movement.",
                whyItMatters: [
                    "Excessive sway wastes energy that should propel you forward",
                    "Can lead to IT band syndrome and hip pain",
                    "Reduces running efficiency and increases fatigue",
                    "Often indicates weak hip stabilizers or core muscles"
                ],
                howToOptimize: [
                    "Strengthen hip abductors with side leg raises and clamshells",
                    "Practice single-leg balance exercises",
                    "Focus on keeping hips level and stable while running",
                    "Strengthen your core with planks and anti-rotation exercises",
                    "Use a mirror or video to check your hip stability"
                ],
                relatedMetrics: ["Efficiency", "Hip Stability"],
                videoPlaceholderTitle: "Exercises to Reduce Lateral Sway"
            )
            
        case .endurance:
            return MetricInfo(
                id: "endurance",
                name: "Endurance",
                icon: "figure.run.circle.fill",
                color: .successGreen,
                unit: "score",
                optimalRange: 75...100,
                description: "Endurance measures how well you maintain your running form and efficiency over the duration of your run. High endurance means consistent performance from start to finish.",
                whyItMatters: [
                    "Good endurance prevents form breakdown that leads to injury",
                    "Allows you to maintain pace throughout long runs",
                    "Indicates proper conditioning and training adaptation",
                    "Essential for race-day performance"
                ],
                howToOptimize: [
                    "Build your aerobic base with easy, longer runs",
                    "Include tempo runs to improve lactate threshold",
                    "Practice progressive runs (start easy, finish faster)",
                    "Ensure adequate recovery between hard workouts",
                    "Focus on nutrition and hydration during long runs"
                ],
                relatedMetrics: ["Efficiency", "Variation"],
                videoPlaceholderTitle: "Building Running Endurance"
            )
            
        case .warmup:
            return MetricInfo(
                id: "warmup",
                name: "Warmup",
                icon: "flame.fill",
                color: .warningYellow,
                unit: "score",
                optimalRange: 75...100,
                description: "Warmup quality measures how prepared your body is at the start of your run. A good warmup gradually increases heart rate, blood flow, and muscle temperature.",
                whyItMatters: [
                    "Proper warmup reduces injury risk significantly",
                    "Improves performance by preparing muscles and joints",
                    "Helps you find your optimal pace more quickly",
                    "Prevents the 'heavy legs' feeling early in runs"
                ],
                howToOptimize: [
                    "Start every run with 5-10 minutes of easy jogging",
                    "Include dynamic stretches: leg swings, lunges, high knees",
                    "Gradually increase pace over the first mile",
                    "For hard workouts, include 3-4 strides before starting",
                    "Warm up longer in cold weather or early morning runs"
                ],
                relatedMetrics: ["Efficiency", "Endurance"],
                videoPlaceholderTitle: "The Perfect Running Warmup Routine"
            )
            
        case .impact:
            return MetricInfo(
                id: "impact",
                name: "Impact",
                icon: "arrow.down.circle.fill",
                color: .errorRed,
                unit: "score",
                optimalRange: 80...100,
                description: "Impact measures the ground reaction forces when your foot strikes the ground. Lower impact forces reduce stress on joints and decrease injury risk.",
                whyItMatters: [
                    "High impact forces are linked to stress fractures and joint pain",
                    "Cumulative impact stress can lead to overuse injuries",
                    "Lower impact improves running economy",
                    "Especially important for older runners and those with joint issues"
                ],
                howToOptimize: [
                    "Focus on landing with a midfoot strike",
                    "Increase your cadence to reduce overstriding",
                    "Work on glute and hamstring strength",
                    "Practice running 'quietly' - minimize noise",
                    "Consider softer running surfaces when possible"
                ],
                relatedMetrics: ["Braking", "Efficiency", "Launching"],
                videoPlaceholderTitle: "Reducing Ground Impact Forces"
            )
            
        case .braking:
            return MetricInfo(
                id: "braking",
                name: "Braking",
                icon: "hand.raised.fill",
                color: .errorRed,
                unit: "score",
                optimalRange: 80...100,
                description: "Braking measures the deceleration forces that occur when your foot lands ahead of your center of mass. Less braking means more efficient forward momentum.",
                whyItMatters: [
                    "Excessive braking wastes energy and slows you down",
                    "Creates unnecessary stress on knees and shins",
                    "Often caused by overstriding (landing heel-first too far forward)",
                    "Major factor in running economy and speed"
                ],
                howToOptimize: [
                    "Shorten your stride and increase cadence",
                    "Focus on landing with your foot under your hips",
                    "Lean slightly forward from the ankles",
                    "Work on calf strength for better push-off",
                    "Practice running downhill to feel proper landing position"
                ],
                relatedMetrics: ["Impact", "Efficiency", "Cadence"],
                videoPlaceholderTitle: "Eliminating Braking Forces"
            )
            
        case .variation:
            return MetricInfo(
                id: "variation",
                name: "Variation",
                icon: "waveform.path.ecg",
                color: .infoBlue,
                unit: "score",
                optimalRange: 80...100,
                description: "Variation measures the consistency of your stride pattern. Lower variation means more consistent, efficient movement with each step.",
                whyItMatters: [
                    "Consistent stride pattern indicates good form and conditioning",
                    "High variation can signal fatigue or muscle imbalances",
                    "Affects running efficiency and injury risk",
                    "Important indicator of overall running economy"
                ],
                howToOptimize: [
                    "Focus on maintaining rhythm throughout your run",
                    "Use a metronome or music at 170-180 BPM",
                    "Strengthen weak or asymmetric muscles",
                    "Practice tempo runs at consistent paces",
                    "Ensure adequate recovery to prevent fatigue-induced variation"
                ],
                relatedMetrics: ["Efficiency", "Endurance", "Symmetry"],
                videoPlaceholderTitle: "Achieving Consistent Stride Patterns"
            )
        }
    }
}