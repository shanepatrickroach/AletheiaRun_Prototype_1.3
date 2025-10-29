//
//  MetricInfo.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/20/25.
//

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
    case braking = "Braking"
    case impact = "Impact"
    case sway = "Sway"
    case variation = "Variation"
    case warmup = "Warmup"
    case endurance = "Endurance"
    case hipMobility = "Hip Mobility"
    case hipStability = "Hip Stability"
    case portraitSymmetry = "Portrait Symmetry"
    case overallScore = "Overall Score"

    var info: MetricInfo {
        switch self {
        case .efficiency:
            return MetricInfo(
                id: "efficiency",
                name: "Efficiency",
                icon: "bolt.fill",
                color: .efficiencyColor,
                unit: "score",
                optimalRange: 80...100,
                description:
                    "Efficiency measures how economically you use energy while running. A higher score means you're getting more forward motion for the same amount of effort.",
                whyItMatters: [
                    "Better efficiency means you can run longer distances without fatigue",
                    "Reduces wasted energy and improves performance",
                    "Directly correlates with running economy and race times",
                    "Helps prevent early fatigue in long runs",
                ],
                howToOptimize: [
                    "Focus on a midfoot strike rather than heel striking",
                    "Maintain an upright posture with slight forward lean",
                    "Increase your cadence (steps per minute) to 170-180",
                    "Work on core strength to maintain form during fatigue",
                    "Practice running drills: high knees, butt kicks, A-skips",
                ],
                relatedMetrics: ["Sway", "Braking", "Impact"],
                videoPlaceholderTitle: "How to Improve Running Efficiency"
            )

        case .braking:
            return MetricInfo(
                id: "braking",
                name: "Braking",
                icon: "hand.raised.fill",
                color: .brakingColor,
                unit: "score",
                optimalRange: 80...100,
                description:
                    "Braking measures the deceleration forces that occur when your foot lands ahead of your center of mass. Less braking means more efficient forward momentum.",
                whyItMatters: [
                    "Excessive braking wastes energy and slows you down",
                    "Creates unnecessary stress on knees and shins",
                    "Often caused by overstriding (landing heel-first too far forward)",
                    "Major factor in running economy and speed",
                ],
                howToOptimize: [
                    "Shorten your stride and increase cadence",
                    "Focus on landing with your foot under your hips",
                    "Lean slightly forward from the ankles",
                    "Work on calf strength for better push-off",
                    "Practice running downhill to feel proper landing position",
                ],
                relatedMetrics: ["Impact", "Efficiency", "Cadence"],
                videoPlaceholderTitle: "Eliminating Braking Forces"
            )

        case .impact:
            return MetricInfo(
                id: "impact",
                name: "Impact",
                icon: "arrow.down.circle.fill",
                color: .impactColor,
                unit: "score",
                optimalRange: 80...100,
                description:
                    "Impact measures the ground reaction forces when your foot strikes the ground. Lower impact forces reduce stress on joints and decrease injury risk.",
                whyItMatters: [
                    "High impact forces are linked to stress fractures and joint pain",
                    "Cumulative impact stress can lead to overuse injuries",
                    "Lower impact improves running economy",
                    "Especially important for older runners and those with joint issues",
                ],
                howToOptimize: [
                    "Focus on landing with a midfoot strike",
                    "Increase your cadence to reduce overstriding",
                    "Work on glute and hamstring strength",
                    "Practice running 'quietly' - minimize noise",
                    "Consider softer running surfaces when possible",
                ],
                relatedMetrics: ["Braking", "Efficiency", "Launching"],
                videoPlaceholderTitle: "Reducing Ground Impact Forces"
            )

        case .sway:
            return MetricInfo(
                id: "sway",
                name: "Sway",
                icon: "arrow.left.and.right",
                color: .swayColor,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Sway measures lateral (side-to-side) movement while running. Lower sway means your energy is directed forward rather than being wasted on unnecessary side movement.",
                whyItMatters: [
                    "Excessive sway wastes energy that should propel you forward",
                    "Can lead to IT band syndrome and hip pain",
                    "Reduces running efficiency and increases fatigue",
                    "Often indicates weak hip stabilizers or core muscles",
                ],
                howToOptimize: [
                    "Strengthen hip abductors with side leg raises and clamshells",
                    "Practice single-leg balance exercises",
                    "Focus on keeping hips level and stable while running",
                    "Strengthen your core with planks and anti-rotation exercises",
                    "Use a mirror or video to check your hip stability",
                ],
                relatedMetrics: ["Efficiency", "Hip Stability"],
                videoPlaceholderTitle: "Exercises to Reduce Lateral Sway"
            )

        case .variation:
            return MetricInfo(
                id: "variation",
                name: "Variation",
                icon: "waveform.path.ecg",
                color: .variationColor,
                unit: "score",
                optimalRange: 80...100,
                description:
                    "Variation measures the consistency of your stride pattern. Lower variation means more consistent, efficient movement with each step.",
                whyItMatters: [
                    "Consistent stride pattern indicates good form and conditioning",
                    "High variation can signal fatigue or muscle imbalances",
                    "Affects running efficiency and injury risk",
                    "Important indicator of overall running economy",
                ],
                howToOptimize: [
                    "Focus on maintaining rhythm throughout your run",
                    "Use a metronome or music at 170-180 BPM",
                    "Strengthen weak or asymmetric muscles",
                    "Practice tempo runs at consistent paces",
                    "Ensure adequate recovery to prevent fatigue-induced variation",
                ],
                relatedMetrics: ["Efficiency", "Endurance", "Symmetry"],
                videoPlaceholderTitle: "Achieving Consistent Stride Patterns"
            )

        case .warmup:
            return MetricInfo(
                id: "warmup",
                name: "Warmup",
                icon: "flame.fill",
                color: .warmupColor,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Warmup quality measures how prepared your body is at the start of your run. A good warmup gradually increases heart rate, blood flow, and muscle temperature.",
                whyItMatters: [
                    "Proper warmup reduces injury risk significantly",
                    "Improves performance by preparing muscles and joints",
                    "Helps you find your optimal pace more quickly",
                    "Prevents the 'heavy legs' feeling early in runs",
                ],
                howToOptimize: [
                    "Start every run with 5-10 minutes of easy jogging",
                    "Include dynamic stretches: leg swings, lunges, high knees",
                    "Gradually increase pace over the first mile",
                    "For hard workouts, include 3-4 strides before starting",
                    "Warm up longer in cold weather or early morning runs",
                ],
                relatedMetrics: ["Efficiency", "Endurance"],
                videoPlaceholderTitle: "The Perfect Running Warmup Routine"
            )

        case .endurance:
            return MetricInfo(
                id: "endurance",
                name: "Endurance",
                icon: "figure.run.circle.fill",
                color: .enduranceColor,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Endurance measures how well you maintain your running form and efficiency over the duration of your run. High endurance means consistent performance from start to finish.",
                whyItMatters: [
                    "Good endurance prevents form breakdown that leads to injury",
                    "Allows you to maintain pace throughout long runs",
                    "Indicates proper conditioning and training adaptation",
                    "Essential for race-day performance",
                ],
                howToOptimize: [
                    "Build your aerobic base with easy, longer runs",
                    "Include tempo runs to improve lactate threshold",
                    "Practice progressive runs (start easy, finish faster)",
                    "Ensure adequate recovery between hard workouts",
                    "Focus on nutrition and hydration during long runs",
                ],
                relatedMetrics: ["Efficiency", "Variation"],
                videoPlaceholderTitle: "Building Running Endurance"
            )

        case .hipMobility:
            return MetricInfo(
                id: "hipMobility",
                name: "Hip Mobility",
                icon: "figure.walk.motion",
                color: .hipMobilityColor,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Hip Mobility measures the range of motion in your hip joints during running. Good hip mobility allows for longer, more efficient strides and reduces compensatory stress on other joints.",
                whyItMatters: [
                    "Limited hip mobility restricts stride length and efficiency",
                    "Poor hip mobility increases risk of lower back and knee pain",
                    "Affects your ability to maintain proper running posture",
                    "Critical for power generation during the push-off phase",
                    "Directly impacts injury risk in hips, IT band, and knees",
                ],
                howToOptimize: [
                    "Perform dynamic hip circles and leg swings before runs",
                    "Practice the 90/90 stretch for hip external and internal rotation",
                    "Include pigeon pose and couch stretch in your routine",
                    "Do hip flexor stretches daily, especially if you sit a lot",
                    "Try yoga poses: low lunge, lizard pose, and warrior sequences",
                    "Use a foam roller on hip flexors and glutes regularly",
                ],
                relatedMetrics: [
                    "Hip Stability", "Overall Symmetry", "Efficiency",
                ],
                videoPlaceholderTitle: "Hip Mobility Exercises for Runners"
            )

        case .hipStability:
            return MetricInfo(
                id: "hipStability",
                name: "Hip Stability",
                icon: "figure.stand",
                color: .hipStabilityColor,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Hip Stability measures your ability to control hip movement and prevent excessive drop or rotation during the stance phase of running. Strong, stable hips are essential for injury prevention.",
                whyItMatters: [
                    "Weak hip stability causes knee valgus (knee caving inward)",
                    "Primary factor in IT band syndrome and runner's knee",
                    "Unstable hips lead to compensatory movements and injuries",
                    "Affects your ability to maintain form when fatigued",
                    "Critical for preventing stress fractures and hip pain",
                ],
                howToOptimize: [
                    "Strengthen glute medius with side-lying leg raises",
                    "Practice single-leg balance exercises (30-60 seconds each leg)",
                    "Do clamshell exercises with resistance band",
                    "Include single-leg deadlifts and step-ups in strength training",
                    "Try lateral band walks to activate hip stabilizers",
                    "Focus on hip hikes and single-leg squats",
                ],
                relatedMetrics: ["Hip Mobility", "Sway", "Overall Symmetry"],
                videoPlaceholderTitle:
                    "Hip Stability Exercises for Injury Prevention"
            )

        case .portraitSymmetry:
            return MetricInfo(
                id: "portraitSymmetry",
                name: "Portrait Symmetry",
                icon: "arrow.left.and.right.circle.fill",
                color: .primaryOrange,
                unit: "score",
                optimalRange: 80...100,
                description:
                    "Overall Symmetry measures the balance between your left and right sides across all biomechanical metrics. Good symmetry indicates balanced muscle development and proper form on both sides.",
                whyItMatters: [
                    "Asymmetry increases injury risk significantly",
                    "Uneven loading causes overuse injuries on the stronger side",
                    "Indicates potential muscle imbalances or past injuries",
                    "Affects running efficiency and energy expenditure",
                    "Can reveal compensation patterns from old injuries",
                ],
                howToOptimize: [
                    "Identify and address muscle imbalances with strength testing",
                    "Focus extra attention on your weaker side during exercises",
                    "Include single-leg exercises to reveal and fix asymmetries",
                    "Work with a physical therapist if asymmetry persists",
                    "Check for leg length discrepancies or foot pronation differences",
                    "Monitor symmetry trends over time to track improvement",
                ],
                relatedMetrics: ["Hip Mobility", "Hip Stability", "Variation"],
                videoPlaceholderTitle: "Correcting Running Asymmetries"
            )

        case .overallScore:
            return MetricInfo(
                id: "overallScore",
                name: "Overall Score",
                icon: "star.fill",
                color: .primaryOrange,
                unit: "score",
                optimalRange: 75...100,
                description:
                    "Your Overall Score is a comprehensive assessment of your running biomechanics, combining all performance and injury prevention metrics. It represents your overall running health and form quality.",
                whyItMatters: [
                    "Provides a quick snapshot of your overall running health",
                    "Helps track long-term improvement and training effectiveness",
                    "Identifies whether form issues are widespread or isolated",
                    "Useful for comparing runs and tracking trends over time",
                    "Indicates when to focus on form work vs. volume training",
                ],
                howToOptimize: [
                    "Focus on improving your lowest-scoring individual metrics first",
                    "Maintain consistency in your training schedule",
                    "Balance strength training with running volume",
                    "Prioritize recovery to prevent form breakdown from fatigue",
                    "Work with a running coach for personalized form analysis",
                    "Review your Force Portrait regularly to identify patterns",
                ],
                relatedMetrics: ["All Metrics"],
                videoPlaceholderTitle:
                    "Understanding Your Overall Running Score"
            )

        }

    }
}
