// Features/Profile/RunningHistoryViewModel.swift

import SwiftUI

class RunningHistoryViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .month
    @Published var enabledMetrics: Set<MetricType> = [.efficiency, .sway]
    @Published var dataPoints: [DataPoint] = []
    
    // Computed properties
    var totalRuns: Int {
        dataPoints.count
    }
    
    var totalDistance: Double {
        // Assuming average of 5 miles per run
        Double(dataPoints.count) * 5.0
    }
    
    var totalTimeFormatted: String {
        let totalMinutes = dataPoints.count * 45  // Assuming 45 min per run
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var averagePaceFormatted: String {
        "8:24"  // Placeholder
    }
    
    var insights: [Insight] {
        generateInsights()
    }
    
    // MARK: - Public Methods
    func loadData() {
        generateDataPoints()
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
        let sum = dataPoints.map { $0.valueFor(metric: metric) }.reduce(0, +)
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
        
        // Calculate consistency (lower range = more consistent)
        let consistency = max(0, 100 - range)
        
        // Calculate trend
        let trend = calculateTrend(for: values)
        
        return MetricStats(
            average: average,
            best: best,
            worst: worst,
            range: range,
            consistency: consistency,
            trend: trend
        )
    }
    
    // MARK: - Private Methods
    private func generateDataPoints() {
        let daysBack = selectedPeriod.daysBack ?? 365
        let calendar = Calendar.current
        var points: [DataPoint] = []
        
        for i in 0..<min(daysBack, 60) {  // Max 60 data points
            if i % (daysBack / 30) == 0 {  // Sample evenly
                let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                let point = DataPoint(
                    date: date,
                    efficiency: Int.random(in: 70...90),
                    sway: Int.random(in: 65...85),
                    endurance: Int.random(in: 72...88),
                    warmup: Int.random(in: 68...82),
                    impact: Int.random(in: 75...92),
                    braking: Int.random(in: 70...88),
                    variation: Int.random(in: 73...87)
                )
                points.append(point)
            }
        }
        
        dataPoints = points.reversed()
    }
    
    private func calculateTrend(for values: [Int]) -> Trend {
        guard values.count >= 2 else { return .stable }
        
        let firstHalf = values.prefix(values.count / 2)
        let secondHalf = values.suffix(values.count / 2)
        
        let firstAvg = firstHalf.reduce(0, +) / firstHalf.count
        let secondAvg = secondHalf.reduce(0, +) / secondHalf.count
        
        let percentChange = Int(Double(secondAvg - firstAvg) / Double(firstAvg) * 100)
        
        if percentChange > 3 {
            return .improving(percentChange)
        } else if percentChange < -3 {
            return .declining(abs(percentChange))
        } else {
            return .stable
        }
    }
    
    private func generateInsights() -> [Insight] {
        var insights: [Insight] = []
        
        // Check for improving metrics
        for metric in MetricType.allCases {
            let stats = statsForMetric(metric)
            if case .improving(let percent) = stats.trend, percent > 5 {
                insights.append(Insight(
                    icon: "arrow.up.circle.fill",
                    title: "\(metric.info.name) Improving",
                    message: "Your \(metric.rawValue.lowercased()) has improved by \(percent)% over this period!",
                    color: .successGreen
                ))
            }
        }
        
        // Check for declining metrics
        for metric in MetricType.allCases {
            let stats = statsForMetric(metric)
            if case .declining(let percent) = stats.trend, percent > 5 {
                insights.append(Insight(
                    icon: "exclamationmark.triangle.fill",
                    title: "\(metric.info.name) Declining",
                    message: "Your \(metric.rawValue.lowercased()) has decreased by \(percent)%. Consider reviewing your training.",
                    color: .warningYellow
                ))
            }
        }
        
        // Check for high consistency
        let consistencyStats = MetricType.allCases.map { statsForMetric($0).consistency }
        let avgConsistency = consistencyStats.reduce(0, +) / consistencyStats.count
        if avgConsistency >= 75 {
            insights.append(Insight(
                icon: "checkmark.seal.fill",
                title: "Excellent Consistency",
                message: "Your metrics are very consistent, showing strong form stability.",
                color: .infoBlue
            ))
        }
        
        // Default insight if no others
        if insights.isEmpty {
            insights.append(Insight(
                icon: "chart.line.uptrend.xyaxis",
                title: "Keep Training",
                message: "Continue your current training to see improvements in your metrics.",
                color: .primaryOrange
            ))
        }
        
        return insights
    }
}