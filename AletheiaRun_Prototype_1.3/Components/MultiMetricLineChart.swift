//
//  MultiMetricLineChart.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/20/25.
//

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
            let values = dataPoints.map {
                Double(
                    $0.valueFor(
                        metric: metric
                    ))
            }
            guard !values.isEmpty else { return }

            let stepX = width / CGFloat(max(values.count - 1, 1))

            // Start path
            let firstY = height - (CGFloat(values[0]) / 100.0 * height)
            path.move(to: CGPoint(x: 0, y: firstY))

            // Draw line through all points
            for (index, value) in values.enumerated() {
                let x = CGFloat(index) * stepX
                let y = height - (CGFloat(value) / 100.0 * height)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(metricInfo.color, lineWidth: 2.5)
    }
}

// MARK: - Metric Points
struct MetricPoints: View {
    let dataPoints: [DataPoint]
    let metric: MetricType
    let width: CGFloat
    let height: CGFloat

    private var metricInfo: MetricInfo {
        metric.info
    }

    var body: some View {
        ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, point in
            let values = dataPoints.map { Double($0.valueFor(metric: metric)) }
            let stepX = width / CGFloat(max(values.count - 1, 1))
            let value = Double(point.valueFor(metric: metric))

            let x = CGFloat(index) * stepX
            let y = height - (CGFloat(value) / 100.0 * height)

            Circle()
                .fill(metricInfo.color)
                .frame(width: 6, height: 6)
                .position(x: x, y: y)
        }
    }
}

#Preview {
    MultiMetricLineChart(
        dataPoints: [
            DataPoint(
                date: Date().addingTimeInterval(-7 * 24 * 60 * 60),
                efficiency: 75, braking: 70, impact: 80, sway: 72, variation: 85,
                warmup: 78, endurance: 76, hipMobility: 80, hipStability: 80, portraitSymmetry: 60, overallScore: 60),
            DataPoint(
                date: Date().addingTimeInterval(-5 * 24 * 60 * 60),
                efficiency: 78, braking: 73, impact: 82, sway: 75, variation: 87,
                warmup: 80, endurance: 78, hipMobility: 80, hipStability: 80, portraitSymmetry: 60, overallScore: 60),
            DataPoint(
                date: Date().addingTimeInterval(-3 * 24 * 60 * 60),
                efficiency: 82, braking: 76, impact: 85, sway: 78, variation: 89,
                warmup: 82, endurance: 80, hipMobility: 80, hipStability: 80, portraitSymmetry: 60, overallScore: 60),
            DataPoint(
                date: Date(), efficiency: 85, braking: 80, impact: 88,
                sway: 82, variation: 92, warmup: 85, endurance: 83, hipMobility: 80, hipStability: 80, portraitSymmetry: 60, overallScore: 60),
        ],
        enabledMetrics: [.efficiency, .sway, .endurance],
        period: .week
    )
    .frame(height: 300)
    .padding()
    .background(Color.backgroundBlack)
}
