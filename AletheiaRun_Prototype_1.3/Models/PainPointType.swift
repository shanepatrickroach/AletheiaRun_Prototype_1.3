// Models/PainPointType.swift

import Foundation
import SwiftUI

// MARK: - Pain Point Side
enum PainPointSide: String, Codable, CaseIterable {
    case left = "Left"
    case right = "Right"
    case both = "Both"

    var icon: String {
        switch self {
        case .left: return "l.square.fill"
        case .right: return "r.square.fill"
        case .both: return "lr.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .left: return .infoBlue
        case .right: return .warningYellow
        case .both: return .errorRed
        }
    }
}

// MARK: - Pain Point Selection
/// Combines pain point type with side selection
struct PainPointSelection: Identifiable, Hashable, Codable {
    let id: UUID
    let type: PainPointType
    let side: PainPointSide

    init(id: UUID = UUID(), type: PainPointType, side: PainPointSide) {
        self.id = id
        self.type = type
        self.side = side
    }

    var displayText: String {
        "\(side.rawValue) \(type.displayName)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PainPointSelection, rhs: PainPointSelection) -> Bool {
        lhs.id == rhs.id
    }
}

/// Comprehensive pain point types for runners with medical information
enum PainPointType: String, CaseIterable, Identifiable, Hashable, Codable {
    case patelloFemoral = "patelloFemoral"
    case patellaTendonitis = "patellaTendonitis"
    case itBand = "itBand"
    case hipBursitis = "hipBursitis"
    case lowBack = "lowBack"
    case achilles = "achilles"
    case plantarFasciitis = "plantarFasciitis"
    case anteriorShinSplints = "anteriorShinSplints"
    case posteriorShinSplints = "posteriorShinSplints"
    case stressFracture = "stressFracture"
    case hamstring = "hamstring"

    var id: String { rawValue }

    // MARK: - Display Properties

    // Add this to the PainPointType enum

    var needsSideSelection: Bool {
        switch self {
        case .lowBack, .stressFracture:
            return false  // These don't need left/right
        default:
            return true  // All others need side selection
        }
    }

    var displayName: String {
        switch self {
        case .patelloFemoral: return "Patello-Femoral Pain"
        case .patellaTendonitis: return "Patella Tendonitis"
        case .itBand: return "IT Band Syndrome"
        case .hipBursitis: return "Hip Bursitis"
        case .lowBack: return "Low Back Pain"
        case .achilles: return "Achilles Tendinitis"
        case .plantarFasciitis: return "Plantar Fasciitis"
        case .anteriorShinSplints: return "Anterior Shin Splints"
        case .posteriorShinSplints: return "Posterior Shin Splints"
        case .stressFracture: return "Stress Fracture"
        case .hamstring: return "Hamstring Injury"
        }
    }

    var shortDescription: String {
        switch self {
        case .patelloFemoral: return "Front of knee, around kneecap"
        case .patellaTendonitis: return "On the knee"
        case .itBand: return "Outside of knee"
        case .hipBursitis: return "Outside of hip"
        case .lowBack: return "Lower back region"
        case .achilles: return "Back of ankle, above heel"
        case .plantarFasciitis: return "Bottom of heel"
        case .anteriorShinSplints: return "Outside of shin"
        case .posteriorShinSplints: return "Inside of shin"
        case .stressFracture: return "Bone stress injury"
        case .hamstring: return "Back of thigh"
        }
    }

    var fullDescription: String {
        switch self {
        case .patelloFemoral:
            return
                "Patellofemoral pain syndrome typically causes pain at the front of the knee, around or under the kneecap (patella). This pain often worsens with activities like running, squatting, or climbing stairs. It's one of the most common running injuries."

        case .patellaTendonitis:
            return
                "Patellofemoral pain syndrome typically causes pain at the front of the knee, around or under the kneecap (patella). This pain often worsens with activities like running, squatting, or climbing stairs. It's one of the most common running injuries."
        case .itBand:
            return
                "Iliotibial band syndrome typically causes pain on the outside of the knee, which may also radiate up the thigh to the hip. The pain often worsens during activities like running or cycling and may be accompanied by a clicking sensation. Pain is on the outside of the knee rather than the center of the knee like with patella pains."

        case .hipBursitis:
            return
                "Trochanteric bursitis pain is typically felt on the outside of the hip and may radiate down the upper thigh. It can also cause discomfort when lying on the affected side, standing up from a seated position, or climbing stairs. This condition involves inflammation of the bursa at the hip joint."

        case .lowBack:
            return
                "Low back pain during or after running can be caused by poor running form, weak core muscles, or biomechanical issues. The pain is typically felt in the lumbar region of the spine and may worsen with prolonged running or poor posture."

        case .achilles:
            return
                "Achilles tendinitis pain is typically located at the back of the lower leg, above the heel, and may also be felt at the point where the Achilles tendon attaches to the heel bone. Symptoms can include stiffness, tenderness, and swelling in this area, especially after activity."

        case .plantarFasciitis:
            return
                "Plantar fasciitis pain is typically located at the bottom of the heel and may also affect the arch of the foot. The pain is often sharp or stabbing, especially with the first steps in the morning or after sitting for a long time. It's caused by inflammation of the plantar fascia."

        case .anteriorShinSplints:
            return
                "Tibialis Anterior overuse causes pain on the outside (lateral side) of the shin. This is commonly referred to as 'shin splints' and results from overuse of the muscles in the front of the lower leg. Pain typically occurs during or after running."

        case .posteriorShinSplints:
            return
                "Tibialis Posterior overuse causes pain on the inside (medial side) of the shin. This is commonly referred to as 'shin splints' and results from overuse of the muscles on the inner part of the lower leg. This is more common than anterior shin splints."

        case .stressFracture:
            return
                "A stress fracture is a small crack in a bone caused by repetitive stress. In runners, this typically occurs in the feet, tibia, fibula, femur, or hip. The main cause from a running form perspective is poor shock absorption. Pain is usually localized and worsens with activity."

        case .hamstring:
            return
                "Hamstring injuries involve pain in the back of the thigh and can range from mild strains to more severe tears. These injuries often occur during high-speed running or when rapidly changing direction. Pain may be felt anywhere along the back of the thigh from the hip to the knee."
        }
    }

    // MARK: - Visual Properties

    var color: Color {
        switch self {
        case .patelloFemoral: return Color(hex: "FF6B6B")
        case .patellaTendonitis: return Color(hex: "FF6B6B")
        case .itBand: return Color(hex: "FFB84D")
        case .hipBursitis: return Color(hex: "A78BFA")
        case .lowBack: return Color(hex: "F87171")
        case .achilles: return Color(hex: "60A5FA")
        case .plantarFasciitis: return Color(hex: "34D399")
        case .anteriorShinSplints: return Color(hex: "FBBF24")
        case .posteriorShinSplints: return Color(hex: "FB923C")
        case .stressFracture: return Color(hex: "EF4444")
        case .hamstring: return Color(hex: "8B5CF6")
        }
    }

    var bodyIcon: String {
        switch self {
        case .patelloFemoral: return "figure.walk"
        case .patellaTendonitis: return "figure.walk"
        case .itBand: return "figure.walk"
        case .hipBursitis: return "figure.stand"
        case .lowBack: return "figure.stand.line.dotted.figure.stand"
        case .achilles: return "figure.walk.motion"
        case .plantarFasciitis: return "shoe.fill"
        case .anteriorShinSplints: return "figure.run"
        case .posteriorShinSplints: return "figure.run"
        case .stressFracture: return "cross.case.fill"
        case .hamstring: return "figure.strengthtraining.traditional"
        }
    }

    var locationLabel: String {
        switch self {
        case .patelloFemoral: return "Front of knee"
        case .patellaTendonitis: return "Front of knee"
        case .itBand: return "Outside knee"
        case .hipBursitis: return "Outside hip"
        case .lowBack: return "Lower back"
        case .achilles: return "Back of ankle"
        case .plantarFasciitis: return "Bottom heel"
        case .anteriorShinSplints: return "Outside shin"
        case .posteriorShinSplints: return "Inside shin"
        case .stressFracture: return "Bone stress"
        case .hamstring: return "Back of thigh"
        }
    }

    // MARK: - Medical Information

    var commonCauses: [String] {
        switch self {
        case .patelloFemoral:
            return [
                "Overuse or sudden increase in mileage",
                "Weak quadriceps or hip muscles",
                "Poor running form or biomechanics",
                "Flat feet or high arches",
                "Tight hamstrings or IT band",
            ]
        case .patellaTendonitis:
            return [
                "Overuse or sudden increase in mileage",
                "Weak quadriceps or hip muscles",
                "Poor running form or biomechanics",
                "Flat feet or high arches",
                "Tight hamstrings or IT band",
            ]

        case .itBand:
            return [
                "Overuse or sudden increase in training",
                "Weak hip abductor muscles",
                "Running on cambered surfaces",
                "Excessive downhill running",
                "Inadequate stretching",
            ]

        case .hipBursitis:
            return [
                "Repetitive friction from running",
                "Sudden increase in activity",
                "Muscle imbalances around the hip",
                "Running on uneven terrain",
                "Previous hip injury",
            ]

        case .lowBack:
            return [
                "Weak core muscles",
                "Poor running posture",
                "Overstriding",
                "Muscle imbalances",
                "Previous back injury",
            ]

        case .achilles:
            return [
                "Sudden increase in training intensity",
                "Tight calf muscles",
                "Improper footwear",
                "Overpronation",
                "Hill running without proper preparation",
            ]

        case .plantarFasciitis:
            return [
                "Overuse or sudden increase in mileage",
                "Tight calf muscles",
                "High arches or flat feet",
                "Improper footwear",
                "Running on hard surfaces",
            ]

        case .anteriorShinSplints:
            return [
                "Sudden increase in running volume",
                "Running on hard surfaces",
                "Improper footwear",
                "Overpronation",
                "Weak anterior tibialis muscles",
            ]

        case .posteriorShinSplints:
            return [
                "Sudden increase in training",
                "Running on hard or uneven surfaces",
                "Overpronation",
                "Worn-out running shoes",
                "Tight calf muscles",
            ]

        case .stressFracture:
            return [
                "Rapid increase in training volume",
                "Poor shock absorption",
                "Inadequate recovery time",
                "Nutritional deficiencies (calcium, vitamin D)",
                "Hormonal imbalances",
            ]

        case .hamstring:
            return [
                "Muscle fatigue or overuse",
                "Inadequate warm-up",
                "Muscle imbalances",
                "Previous hamstring injury",
                "Sudden acceleration or deceleration",
            ]
        }
    }

    var treatments: [Treatment] {
        switch self {
        case .patelloFemoral:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest and reduce running intensity",
                    color: .warningYellow),
                Treatment(
                    icon: "snowflake",
                    text: "Ice after running to reduce inflammation",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Strengthen quadriceps and hip muscles",
                    color: .successGreen),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Stretch hamstrings and IT band",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Consider physical therapy for persistent pain",
                    color: .errorRed),
            ]
        case.patellaTendonitis:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest and reduce running intensity",
                    color: .warningYellow),
                Treatment(
                    icon: "snowflake",
                    text: "Ice after running to reduce inflammation",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Strengthen quadriceps and hip muscles",
                    color: .successGreen),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Stretch hamstrings and IT band",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Consider physical therapy for persistent pain",
                    color: .errorRed),
            ]
        case .itBand:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Reduce mileage and avoid hills",
                    color: .warningYellow),
                Treatment(
                    icon: "figure.roll.runningpace",
                    text: "Foam roll the IT band and outer thigh",
                    color: .successGreen),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Strengthen hip abductor muscles",
                    color: .primaryOrange),
                Treatment(
                    icon: "figure.walk",
                    text: "Modify running form to reduce impact",
                    color: .infoBlue),
                Treatment(
                    icon: "stethoscope",
                    text: "Seek professional help if pain persists",
                    color: .errorRed),
            ]

        case .hipBursitis:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest and avoid aggravating activities",
                    color: .warningYellow),
                Treatment(
                    icon: "snowflake", text: "Apply ice to reduce inflammation",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Strengthen hip and glute muscles",
                    color: .successGreen),
                Treatment(
                    icon: "bed.double.fill",
                    text: "Avoid lying on the affected side",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Consult a doctor for persistent symptoms",
                    color: .errorRed),
            ]

        case .lowBack:
            return [
                Treatment(
                    icon: "figure.core.training",
                    text: "Strengthen core muscles", color: .successGreen),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Stretch hip flexors and hamstrings",
                    color: .primaryOrange),
                Treatment(
                    icon: "figure.walk",
                    text: "Focus on proper running posture", color: .infoBlue),
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Reduce training intensity if needed",
                    color: .warningYellow),
                Treatment(
                    icon: "stethoscope",
                    text: "See a healthcare provider for severe pain",
                    color: .errorRed),
            ]

        case .achilles:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest and reduce running volume",
                    color: .warningYellow),
                Treatment(
                    icon: "snowflake", text: "Ice after activity",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Stretch and strengthen calf muscles",
                    color: .successGreen),
                Treatment(
                    icon: "shoe.fill", text: "Check running shoe support",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Seek treatment for persistent pain", color: .errorRed
                ),
            ]

        case .plantarFasciitis:
            return [
                Treatment(
                    icon: "snowflake", text: "Ice the bottom of your foot",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Stretch calves and plantar fascia",
                    color: .successGreen),
                Treatment(
                    icon: "circle.grid.cross.fill",
                    text: "Roll foot on a frozen water bottle",
                    color: .primaryOrange),
                Treatment(
                    icon: "shoe.fill",
                    text: "Ensure proper arch support in shoes",
                    color: .warningYellow),
                Treatment(
                    icon: "stethoscope",
                    text: "Consider orthotics if pain continues",
                    color: .errorRed),
            ]

        case .anteriorShinSplints, .posteriorShinSplints:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest and reduce impact activities",
                    color: .warningYellow),
                Treatment(
                    icon: "snowflake", text: "Ice after running",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Strengthen shin and calf muscles",
                    color: .successGreen),
                Treatment(
                    icon: "shoe.fill", text: "Replace worn-out running shoes",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Seek medical evaluation if severe", color: .errorRed),
            ]

        case .stressFracture:
            return [
                Treatment(
                    icon: "exclamationmark.triangle.fill",
                    text: "STOP running immediately", color: .errorRed),
                Treatment(
                    icon: "stethoscope",
                    text: "See a doctor for proper diagnosis", color: .errorRed),
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Complete rest from impact activities",
                    color: .warningYellow),
                Treatment(
                    icon: "pill.fill",
                    text: "Ensure adequate calcium and vitamin D",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.walk",
                    text: "Follow medical advice for return to running",
                    color: .successGreen),
            ]

        case .hamstring:
            return [
                Treatment(
                    icon: "pause.circle.fill",
                    text: "Rest immediately after injury", color: .warningYellow
                ),
                Treatment(
                    icon: "snowflake", text: "Ice in the first 48 hours",
                    color: .infoBlue),
                Treatment(
                    icon: "figure.flexibility",
                    text: "Gentle stretching after initial healing",
                    color: .successGreen),
                Treatment(
                    icon: "figure.strengthtraining.traditional",
                    text: "Progressive strengthening exercises",
                    color: .primaryOrange),
                Treatment(
                    icon: "stethoscope",
                    text: "Physical therapy for severe strains",
                    color: .errorRed),
            ]
        }
    }

    var relatedMetrics: [String] {
        switch self {
        case .patelloFemoral:
            return ["Impact", "Braking", "Efficiency"]
        case .patellaTendonitis:
            return ["Impact", "Braking", "Efficiency"]
        case .itBand:
            return ["Sway", "Hip Stability", "Impact"]
        case .hipBursitis:
            return ["Sway", "Hip Stability", "Variation"]
        case .lowBack:
            return ["Efficiency", "Sway", "Endurance"]
        case .achilles:
            return ["Impact", "Braking", "Launching"]
        case .plantarFasciitis:
            return ["Impact", "Braking", "Efficiency"]
        case .anteriorShinSplints, .posteriorShinSplints:
            return ["Impact", "Braking", "Cadence"]
        case .stressFracture:
            return ["Impact", "Braking", "Variation"]
        case .hamstring:
            return ["Warmup", "Efficiency", "Endurance"]
        }
    }
}

// MARK: - Treatment Model
struct Treatment: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
}
