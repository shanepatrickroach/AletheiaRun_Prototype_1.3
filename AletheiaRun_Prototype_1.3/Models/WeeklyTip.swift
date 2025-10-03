//
//  WeeklyTip.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Models/Tip.swift

import Foundation

struct WeeklyTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: TipCategory
    let icon: String
    
    enum TipCategory: String {
        case form = "Running Form"
        case injury = "Injury Prevention"
        case training = "Training"
        case nutrition = "Nutrition"
        case recovery = "Recovery"
        case metrics = "Metrics"
        
        var color: String {
            switch self {
            case .form: return "primaryOrange"
            case .injury: return "errorRed"
            case .training: return "infoBlue"
            case .nutrition: return "successGreen"
            case .recovery: return "warningYellow"
            case .metrics: return "primaryLight"
            }
        }
    }
}

// MARK: - Sample Tips
extension WeeklyTip {
    static let sampleTips = [
        WeeklyTip(
            title: "Listen to Your Sway",
            description: "Excessive lateral movement wastes energy. Focus on running in a straight line and engaging your core to minimize side-to-side motion.",
            category: .form,
            icon: "figure.run"
        ),
        WeeklyTip(
            title: "The 10% Rule",
            description: "Increase your weekly mileage by no more than 10% to reduce injury risk. Your body needs time to adapt to increased stress.",
            category: .injury,
            icon: "chart.line.uptrend.xyaxis"
        ),
        WeeklyTip(
            title: "Cadence Matters",
            description: "Aim for 170-180 steps per minute to reduce impact forces. Higher cadence means less time on the ground and lower injury risk.",
            category: .metrics,
            icon: "metronome"
        ),
        WeeklyTip(
            title: "Recovery Is Training",
            description: "Your body gets stronger during rest, not during the workout. Schedule at least one full rest day per week.",
            category: .recovery,
            icon: "moon.stars.fill"
        ),
        WeeklyTip(
            title: "Fuel Before Long Runs",
            description: "Eat a carb-rich snack 30-60 minutes before runs longer than 60 minutes. Your muscles need glycogen for sustained energy.",
            category: .nutrition,
            icon: "leaf.fill"
        )
    ]
    
    static var currentTip: WeeklyTip {
        // Rotate tips based on week of year
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        let index = weekOfYear % sampleTips.count
        return sampleTips[index]
    }
}