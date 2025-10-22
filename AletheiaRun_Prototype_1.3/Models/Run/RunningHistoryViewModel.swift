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
        Double(dataPoints.count) * 5.0
    }
    
    var totalTimeFormatted: String {
        let totalMinutes = dataPoints.count * 45
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var averagePaceFormatted: String {
        "8:24"
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
        
        // Generate sample points based on period
        let numberOfPoints = min(daysBack / 2, 60)  // Max 60 data points
        
        for i in 0..<numberOfPoints {
            let dayOffset = -(daysBack * i / numberOfPoints)
            let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
            
            // Add slight upward trend for realism
            let trendFactor = Double(i) / Double(numberOfPoints) * 5.0
            
            let point = DataPoint(
                date: date,
                efficiency: Int.random(in: 70...85) + Int(trendFactor),
                braking: Int.random(in: 70...85) + Int(trendFactor),
                
                
                
                impact: Int.random(in: 75...88) + Int(trendFactor),
                sway: Int.random(in: 65...80) + Int(trendFactor),
                
                variation: Int.random(in: 73...85) + Int(trendFactor),
                warmup: Int.random(in: 68...80) + Int(trendFactor),
                endurance: Int.random(in: 72...85) + Int(trendFactor)
            )
            points.append(point)
        }
        
        dataPoints = points.reversed()
    }
    
    private func calculateTrend(for values: [Int]) -> Trend {
        guard values.count >= 2 else { return .stable }
        
        let firstHalf = values.prefix(values.count / 2)
        let secondHalf = values.suffix(values.count / 2)
        
        guard !firstHalf.isEmpty, !secondHalf.isEmpty else { return .stable }
        
        let firstAvg = firstHalf.reduce(0, +) / firstHalf.count
        let secondAvg = secondHalf.reduce(0, +) / secondHalf.count
        
        guard firstAvg != 0 else { return .stable }
        
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
        
        // Check each metric for trends
        for metric in MetricType.allCases {
            let stats = statsForMetric(metric)
            
            // Check for improving trend
            if case .improving(let percent) = stats.trend {
                if percent > 5 {
                    insights.append(Insight(
                        icon: "arrow.up.circle.fill",
                        title: "\(metric.info.name) Improving",
                        message: "Your \(metric.rawValue.lowercased()) has improved by \(percent)% over this period!",
                        color: .successGreen
                    ))
                }
            }
            
            // Check for declining trend
            if case .declining(let percent) = stats.trend {
                if percent > 5 {
                    insights.append(Insight(
                        icon: "exclamationmark.triangle.fill",
                        title: "\(metric.info.name) Declining",
                        message: "Your \(metric.rawValue.lowercased()) has decreased by \(percent)%. Consider reviewing your training.",
                        color: .warningYellow
                    ))
                }
            }
        }
        
        // Check for high consistency
        let consistencyStats = MetricType.allCases.map { statsForMetric($0).consistency }
        if !consistencyStats.isEmpty {
            let avgConsistency = consistencyStats.reduce(0, +) / consistencyStats.count
            if avgConsistency >= 75 {
                insights.append(Insight(
                    icon: "checkmark.seal.fill",
                    title: "Excellent Consistency",
                    message: "Your metrics are very consistent, showing strong form stability.",
                    color: .infoBlue
                ))
            }
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
