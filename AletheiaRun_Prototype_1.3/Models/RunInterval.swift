import Foundation

// MARK: - Run Interval Model
/// Represents a segment of a run with its own Force Portrait and metrics
/// Each run is broken into intervals (e.g., every 0.5 miles or 5 minutes)
struct RunInterval: Identifiable {
    let id: UUID
    let intervalNumber: Int // 1, 2, 3, etc.
    let distance: Double // Distance covered in this interval (miles)
    let duration: TimeInterval // Time for this interval (seconds)
    let timestamp: Date // When this interval occurred
    
    // Performance metrics for this interval
    let performanceMetrics: PerformanceMetrics
    
    // Injury diagnostic metrics for this interval
    let injuryMetrics: InjuryMetrics
    
    // Computed Properties
    var pace: Double {
        guard distance > 0 else { return 0 }
        return (duration / 60) / distance // min/mile
    }
    
    var formattedPace: String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var formattedDistance: String {
        String(format: "%.2f mi", distance)
    }
}

// MARK: - Performance Metrics
/// The 7 core performance metrics (0-100 scale)
struct PerformanceMetrics: Codable {
    let efficiency: Int      // Energy economy
    let sway: Int           // Lateral movement
    let braking: Int        // Deceleration forces
    let endurance: Int      // Sustained performance
    let warmup: Int         // Initial readiness
    let impact: Int         // Ground contact force
    let variation: Int      // Stride consistency
    
    /// Overall score is the average of all metrics
    var overallScore: Int {
        (efficiency + sway + braking + endurance + warmup + impact + variation) / 7
    }
    
    /// Get all metrics as an array for easy iteration
    var allMetrics: [(name: String, value: Int, description: String)] {
        [
            ("Efficiency", efficiency, "Energy economy during running"),
            ("Sway", sway, "Lateral movement control"),
            ("Braking", braking, "Deceleration force management"),
            ("Endurance", endurance, "Sustained performance ability"),
            ("Warmup", warmup, "Initial movement readiness"),
            ("Impact", impact, "Ground contact force"),
            ("Variation", variation, "Stride-to-stride consistency")
        ]
    }
}

// MARK: - Injury Metrics
/// Diagnostic metrics related to injury prevention
struct InjuryMetrics: Codable {
    let hipMobility: Int        // Hip range of motion (0-100)
    let hipStability: Int       // Hip joint stability (0-100)
    let portraitSymmetry: Int   // Left/right balance (0-100)
    
    /// Overall injury risk score (higher is better)
    var overallScore: Int {
        (hipMobility + hipStability + portraitSymmetry) / 3
    }
    
    /// Risk level based on overall score
    var riskLevel: RiskLevel {
        let score = overallScore
        if score >= 80 { return .low }
        else if score >= 60 { return .moderate }
        else { return .high }
    }
    
    /// Get all metrics as an array for easy iteration
    var allMetrics: [(name: String, value: Int, description: String)] {
        [
            ("Hip Mobility", hipMobility, "Range of motion in hip joints"),
            ("Hip Stability", hipStability, "Strength and control of hip joints"),
            ("Portrait Symmetry", portraitSymmetry, "Balance between left and right sides")
        ]
    }
}

// MARK: - Risk Level Enum
enum RiskLevel {
    case low
    case moderate
    case high
    
    var title: String {
        switch self {
        case .low: return "Low Risk"
        case .moderate: return "Moderate Risk"
        case .high: return "High Risk"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "successGreen"
        case .moderate: return "warningYellow"
        case .high: return "errorRed"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "checkmark.shield.fill"
        case .moderate: return "exclamationmark.shield.fill"
        case .high: return "xmark.shield.fill"
        }
    }
}

// MARK: - Sample Data Extension
extension RunInterval {
    /// Generate sample intervals for testing
    static func generateSampleIntervals(count: Int = 6) -> [RunInterval] {
        var intervals: [RunInterval] = []
        let baseDate = Date()
        
        for i in 0..<count {
            let interval = RunInterval(
                id: UUID(),
                intervalNumber: i + 1,
                distance: 0.5, // Half mile intervals
                duration: TimeInterval.random(in: 180...300), // 3-5 minutes
                timestamp: baseDate.addingTimeInterval(TimeInterval(i * 300)),
                performanceMetrics: PerformanceMetrics(
                    efficiency: Int.random(in: 65...95),
                    sway: Int.random(in: 65...95),
                    braking: Int.random(in: 65...95),
                    endurance: Int.random(in: 65...95),
                    warmup: Int.random(in: 65...95),
                    impact: Int.random(in: 65...95),
                    variation: Int.random(in: 65...95)
                ),
                injuryMetrics: InjuryMetrics(
                    hipMobility: Int.random(in: 60...95),
                    hipStability: Int.random(in: 60...95),
                    portraitSymmetry: Int.random(in: 60...95)
                )
            )
            intervals.append(interval)
        }
        
        return intervals
    }
}