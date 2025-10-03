// Models/RunGoal.swift (UPDATE THIS FILE)

import Foundation

enum RunGoal: String, CaseIterable, Codable, Hashable, Identifiable {
    case improvePerformance = "Improve Performance"
    case preventInjuries = "Prevent Injuries"
    case understandForm = "Understand My Form"
    case returnFromInjury = "Return from Injury"
    case coachOthers = "Coach Others"
    
    // Add this to make it Identifiable
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .improvePerformance:
            return "bolt.fill"
        case .preventInjuries:
            return "heart.circle.fill"
        case .understandForm:
            return "waveform.path.ecg"
        case .returnFromInjury:
            return "bandage.fill"
        case .coachOthers:
            return "person.2.fill"
        }
    }
    
    var description: String {
        switch self {
        case .improvePerformance:
            return "Run faster and more efficiently"
        case .preventInjuries:
            return "Stay healthy and run injury-free"
        case .understandForm:
            return "Analyze and improve running mechanics"
        case .returnFromInjury:
            return "Safely return to running after injury"
        case .coachOthers:
            return "Help others improve their running"
        }
    }
}
