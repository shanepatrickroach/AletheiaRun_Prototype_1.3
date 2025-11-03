

import SwiftUI


// MARK: - Running History ViewModel (Update)
class RunningHistoryViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .month
    @Published var enabledMetrics: Set<MetricType> = [.efficiency, .braking]
    @Published var dataPoints: [DataPoint] = []
    @Published var insights: [Insight] = []
    
    // Computed properties
    var totalRuns: Int {
        dataPoints.count
    }
    
    var totalDistance: Double {
        Double(dataPoints.count) * 3.5 // Placeholder
    }
    
    var totalTimeFormatted: String {
        let hours = dataPoints.count * 30 / 60
        return "\(hours)h"
    }
    
    var averagePaceFormatted: String {
        "8:30"
    }
    
    func loadData() {
        // Generate sample data
        generateSampleData()
        generateInsights()
    }
    
    func toggleMetric(_ metric: MetricType) {
        if enabledMetrics.contains(metric) {
            enabledMetrics.remove(metric)
        } else {
            enabledMetrics.insert(metric)
        }
    }
    
    func averageForMetric(_ metric: MetricType) -> Int {
        guard !dataPoints.isEmpty else { return 0 }
        let sum = dataPoints.reduce(0) { $0 + $1.valueFor(metric: metric) }
        return sum / dataPoints.count
    }
    
    func statsForMetric(_ metric: MetricType) -> MetricStats {
        let values = dataPoints.map { $0.valueFor(metric: metric) }
        guard !values.isEmpty else {
            return MetricStats(
                average: 0,
                best: 0,
                worst: 0,
                range: 0,
                consistency: 0,
                trend: .stable
            )
        }
        
        let average = values.reduce(0, +) / values.count
        let best = values.max() ?? 0
        let worst = values.min() ?? 0
        let range = best - worst
        
        // Calculate consistency (inverse of standard deviation)
        let variance = values.reduce(0.0) { sum, value in
            let diff = Double(value - average)
            return sum + (diff * diff)
        } / Double(values.count)
        let stdDev = sqrt(variance)
        let consistency = max(0, min(100, Int(100 - (stdDev * 2))))
        
        // Calculate trend (simple: compare first half vs second half)
        let midpoint = values.count / 2
        let firstHalf = values.prefix(midpoint)
        let secondHalf = values.suffix(values.count - midpoint)
        let firstAvg = firstHalf.reduce(0, +) / max(1, firstHalf.count)
        let secondAvg = secondHalf.reduce(0, +) / max(1, secondHalf.count)
        let change = secondAvg - firstAvg
        
        let trend: Trend
        if abs(change) < 3 {
            trend = .stable
        } else if change > 0 {
            trend = .improving(abs(change))
        } else {
            trend = .declining(abs(change))
        }
        
        return MetricStats(
            average: average,
            best: best,
            worst: worst,
            range: range,
            consistency: consistency,
            trend: trend
        )
    }
    
    private func generateSampleData() {
        let calendar = Calendar.current
        let daysBack = selectedPeriod.daysBack ?? 365
        
        dataPoints = (0..<daysBack).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else {
                return nil
            }
            
            // Generate left and right leg data with slight asymmetry
            let leftMobility = Int.random(in: 70...90)
            let rightMobility = Int.random(in: max(60, leftMobility - 10)...min(100, leftMobility + 10))
            
            let leftStability = Int.random(in: 70...90)
            let rightStability = Int.random(in: max(60, leftStability - 10)...min(100, leftStability + 10))
            
            return DataPoint(
                date: date,
                efficiency: Int.random(in: 70...90),
                braking: Int.random(in: 65...85),
                impact: Int.random(in: 70...88),
                sway: Int.random(in: 72...90),
                variation: Int.random(in: 68...85),
                warmup: Int.random(in: 65...88),
                endurance: Int.random(in: 70...87),
                hipMobilityLeft: leftMobility,
                hipMobilityRight: rightMobility,
                hipStabilityLeft: leftStability,
                hipStabilityRight: rightStability,
                portraitSymmetry: Int.random(in: 75...95),
                overallScore: Int.random(in: 70...90)
            )
        }.reversed()
    }
    
    private func generateInsights() {
        insights = [
            Insight(
                icon: "arrow.up.right.circle.fill",
                title: "Great Progress!",
                message: "Your efficiency has improved by 8% this month",
                color: .successGreen
            ),
            Insight(
                icon: "exclamationmark.triangle.fill",
                title: "Asymmetry Detected",
                message: "Left hip mobility is 12% lower than right. Consider targeted exercises.",
                color: .warningYellow
            ),
            Insight(
                icon: "flame.fill",
                title: "Consistency Streak",
                message: "You've maintained good warmup scores for 14 days",
                color: .primaryOrange
            )
        ]
    }
}
