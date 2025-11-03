

import SwiftUI


// MARK: - Multi-Metric Line Chart with Alternating Dots
struct MultiMetricLineChart: View {
    let dataPoints: [DataPoint]
    let enabledMetrics: Set<MetricType>
    let period: TimePeriod
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid lines
                gridLines(size: geometry.size)
                
                // Lines and dots for each metric
                ForEach(Array(enabledMetrics), id: \.self) { metric in
                    metricLineWithDots(
                        metric: metric,
                        size: geometry.size
                    )
                }
                
                // Y-axis labels
                yAxisLabels(size: geometry.size)
                
                // X-axis labels
                xAxisLabels(size: geometry.size)
            }
        }
    }
    
    // MARK: - Grid Lines
    private func gridLines(size: CGSize) -> some View {
        Canvas { context, size in
            let chartHeight = size.height - 40
            let chartWidth = size.width - 50
            
            // Horizontal grid lines
            for i in 0...4 {
                let y = CGFloat(i) * (chartHeight / 4) + 10
                var path = Path()
                path.move(to: CGPoint(x: 40, y: y))
                path.addLine(to: CGPoint(x: 40 + chartWidth, y: y))
                
                context.stroke(
                    path,
                    with: .color(.cardBorder),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                )
            }
        }
    }
    
    // MARK: - Metric Line with Alternating Dots
    @ViewBuilder
    private func metricLineWithDots(metric: MetricType, size: CGSize) -> some View {
        Canvas { context, size in
            guard dataPoints.count > 1 else { return }
            
            let values = dataPoints.map { Double($0.valueFor(metric: metric)) }
            
            guard let minValue = values.min(),
                  let maxValue = values.max(),
                  maxValue > minValue else { return }
            
            let chartHeight = size.height - 40
            let chartWidth = size.width - 50
            let xStep = chartWidth / CGFloat(dataPoints.count - 1)
            let valueRange = maxValue - minValue
            
            // Draw line
            var path = Path()
            for (index, value) in values.enumerated() {
                let x = 40 + CGFloat(index) * xStep
                let normalizedValue = (value - minValue) / valueRange
                let y = 10 + chartHeight - (CGFloat(normalizedValue) * chartHeight)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            // Stroke the line
            context.stroke(
                path,
                with: .color(metric.info.color),
                lineWidth: 2.5
            )
            
            // Draw alternating dots for left/right hip metrics
            if isHipMetric(metric) {
                drawAlternatingDots(
                    context: context,
                    values: values,
                    minValue: minValue,
                    maxValue: maxValue,
                    metric: metric,
                    chartHeight: chartHeight,
                    chartWidth: chartWidth,
                    xStep: xStep,
                    valueRange: valueRange
                )
            } else {
                // Draw regular dots for non-hip metrics
                drawRegularDots(
                    context: context,
                    values: values,
                    minValue: minValue,
                    maxValue: maxValue,
                    metric: metric,
                    chartHeight: chartHeight,
                    chartWidth: chartWidth,
                    xStep: xStep,
                    valueRange: valueRange
                )
            }
        }
    }
    
    // MARK: - Draw Alternating Dots (for hip metrics)
    private func drawAlternatingDots(
        context: GraphicsContext,
        values: [Double],
        minValue: Double,
        maxValue: Double,
        metric: MetricType,
        chartHeight: CGFloat,
        chartWidth: CGFloat,
        xStep: CGFloat,
        valueRange: Double
    ) {
        // Determine base metric color and side color
        let baseColor: Color = {
            switch metric {
            case .hipMobilityLeft, .hipStabilityLeft:
                return .leftSide
            case .hipMobilityRight, .hipStabilityRight:
                return .rightSide
            default:
                return metric.info.color
            }
        }()
        
       
        // For mobility metrics, use green tint
        // For stability metrics, use blue tint
        let metricTypeColor: Color = {
            switch metric {
            case .hipMobilityLeft, .hipMobilityRight:
                return .hipMobilityColor
            case .hipStabilityLeft, .hipStabilityRight:
                return .hipStabilityColor
            default:
                return baseColor
            }
        }()
        
        for (index, value) in values.enumerated() {
            let x = 40 + CGFloat(index) * xStep
            let normalizedValue = (value - minValue) / valueRange
            let y = 10 + chartHeight - (CGFloat(normalizedValue) * chartHeight)
            
            // Alternate between side color and metric type color
            let dotColor = index % 2 == 0 ? baseColor : metricTypeColor
            
            // Draw dot
            context.fill(
                Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                with: .color(dotColor)
            )
        }
    }
    
    // MARK: - Draw Regular Dots (for non-hip metrics)
    private func drawRegularDots(
        context: GraphicsContext,
        values: [Double],
        minValue: Double,
        maxValue: Double,
        metric: MetricType,
        chartHeight: CGFloat,
        chartWidth: CGFloat,
        xStep: CGFloat,
        valueRange: Double
    ) {
        for (index, value) in values.enumerated() {
            let x = 40 + CGFloat(index) * xStep
            let normalizedValue = (value - minValue) / valueRange
            let y = 10 + chartHeight - (CGFloat(normalizedValue) * chartHeight)
            
            // Draw single color dot
            context.fill(
                Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6)),
                with: .color(metric.info.color)
            )
        }
    }
    
    // MARK: - Helper to check if metric is hip-related
    private func isHipMetric(_ metric: MetricType) -> Bool {
        switch metric {
        case .hipMobilityLeft, .hipMobilityRight, .hipStabilityLeft, .hipStabilityRight:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Y-Axis Labels
    private func yAxisLabels(size: CGSize) -> some View {
        ZStack {
            ForEach(0...4, id: \.self) { i in
                Text("\(100 - (i * 25))")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                    .position(
                        x: 20,
                        y: 10 + CGFloat(i) * ((size.height - 40) / 4)
                    )
            }
        }
    }
    
    // MARK: - X-Axis Labels
    private func xAxisLabels(size: CGSize) -> some View {
        let chartWidth = size.width - 50
        let step = max(1, dataPoints.count / 5)
        
        return ZStack {
            ForEach(Array(stride(from: 0, to: dataPoints.count, by: step)), id: \.self) { index in
                if index < dataPoints.count {
                    Text(formatDate(dataPoints[index].date))
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .position(
                            x: 40 + (CGFloat(index) * chartWidth / CGFloat(dataPoints.count - 1)),
                            y: size.height - 15
                        )
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}
