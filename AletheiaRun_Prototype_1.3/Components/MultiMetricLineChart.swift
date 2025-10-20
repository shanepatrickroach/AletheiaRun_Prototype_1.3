// Core/Components/MultiMetricLineChart.swift

import SwiftUI

/// Line chart that displays multiple metrics simultaneously
struct MultiMetricLineChart: View {
    let dataPoints: [DataPoint]
    let enabledMetrics: Set<MetricType>
    let period: TimePeriod
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid lines and labels
                gridLines
                
                // Y-axis labels
                yAxisLabels
                
                // Chart lines for each enabled metric
                ForEach(Array(enabledMetrics), id: \.self) { metric in
                    MetricLine(
                        dataPoints: dataPoints,
                        metric: metric,
                        width: geometry.size.width - 50,
                        height: geometry.size.height - 30
                    )
                    .offset(x: 45, y: 0)
                }
                
                // Data point markers
                ForEach(Array(enabledMetrics), id: \.self) { metric in
                    MetricPoints(
                        dataPoints: dataPoints,
                        metric: metric,
                        width: geometry.size.width - 50,
                        height: geometry.size.height - 30
                    )
                    .offset(x: 45, y: 0)
                }
                
                // X-axis labels
                xAxisLabels(width: geometry.size.width - 50)
                    .offset(x: 45, y: geometry.size.height - 20)
            }
        }
    }
    
    // MARK: - Grid Lines
    private var gridLines: some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { i in
                HStack {
                    Spacer()
                        .frame(width: 40)
                    
                    Rectangle()
                        .fill(Color.cardBorder.opacity(0.3))
                        .frame(height: 1)
                }
                
                if i < 4 {
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Y-Axis Labels
    private var yAxisLabels: some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { i in
                Text("\(100 - i * 20)")
                    .font(.system(size: 10))
                    .foregroundColor(.textTertiary)
                    .frame(width: 35, alignment: .trailing)
                
                if i < 4 {
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - X-Axis Labels
    private func xAxisLabels(width: CGFloat) -> some View {
        HStack {
            Text(startDate)
                .font(.system(size: 10))
                .foregroundColor(.textTertiary)
            
            Spacer()
            
            Text("Now")
                .font(.system(size: 10))
                .foregroundColor(.textTertiary)
        }
        .frame(width: width)
    }
    
    private var startDate: String {
        guard let firstPoint = dataPoints.first else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: firstPoint.date)
    }
}

// MARK: - Metric Line
struct MetricLine: View {
    let dataPoints: [DataPoint]
    let metric: MetricType
    let width: CGFloat
    let height: CGFloat
    
    private var metricInfo: MetricInfo {
        metric.info
    }
    
    var body: some View {
        Path { path in
            let values = dataPoints.map { Double($0.valueFor(metric: metric