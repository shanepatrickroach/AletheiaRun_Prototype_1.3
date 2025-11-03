//
//  HipMetricsVisualizationPrototypes.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/30/25.
//


// Features/RunDetail/HipMetricsVisualizationPrototypes.swift

import SwiftUI

/// Prototype file showing different ways to visualize left vs right hip metrics over time
/// This is for testing and deciding which approach works best

// MARK: - Main Prototype View
struct HipMetricsVisualizationPrototypes: View {
    let snapshots: [RunSnapshot]
    @State private var selectedPrototype: PrototypeOption = .dualLineChart
    
    enum PrototypeOption: String, CaseIterable {
        case dualLineChart = "Dual Line Chart"
        case stackedArea = "Stacked Area"
        case mirroredBars = "Mirrored Bars"
        case overlayedBars = "Overlayed Bars"
        case dualYAxis = "Dual Y-Axis"
        case groupedBars = "Grouped Bars"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Prototype selector
                    prototypeSelector
                    
                    // Current prototype display
                    currentPrototypeView
                    
                    // Description
                    prototypeDescription
                }
                .padding(Spacing.m)
            }
        }
    }
    
    private var prototypeSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Visualization Prototypes")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    ForEach(PrototypeOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selectedPrototype = option
                            }
                        }) {
                            Text(option.rawValue)
                                .font(.bodySmall)
                                .foregroundColor(selectedPrototype == option ? .backgroundBlack : .textPrimary)
                                .padding(.horizontal, Spacing.m)
                                .padding(.vertical, Spacing.s)
                                .background(selectedPrototype == option ? Color.primaryOrange : Color.cardBackground)
                                .cornerRadius(CornerRadius.small)
                        }
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    @ViewBuilder
    private var currentPrototypeView: some View {
        switch selectedPrototype {
        case .dualLineChart:
            Prototype1_DualLineChart(snapshots: snapshots)
        case .stackedArea:
            Prototype2_StackedArea(snapshots: snapshots)
        case .mirroredBars:
            Prototype3_MirroredBars(snapshots: snapshots)
        case .overlayedBars:
            Prototype4_OverlayedBars(snapshots: snapshots)
        case .dualYAxis:
            Prototype5_DualYAxis(snapshots: snapshots)
        case .groupedBars:
            Prototype6_GroupedBars(snapshots: snapshots)
        }
    }
    
    private var prototypeDescription: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("About This Visualization")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(currentDescription)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    private var currentDescription: String {
        switch selectedPrototype {
        case .dualLineChart:
            return "Two separate line charts stacked vertically - one for mobility, one for stability. Each shows left (cyan) and right (magenta) lines. Clear separation makes it easy to compare metrics independently."
        case .stackedArea:
            return "Area charts showing left and right metrics overlapping with transparency. Good for seeing overall trends and where one side dominates."
        case .mirroredBars:
            return "Bars grow from center outward - left bars go left (cyan), right bars go right (magenta). Symmetry is immediately visible. Great for spotting imbalances."
        case .overlayedBars:
            return "Bars placed side-by-side for each snapshot. Left and right are adjacent, making direct comparison easy at each point in time."
        case .dualYAxis:
            return "Single chart with two Y-axes - left side for mobility, right side for stability. Both left/right legs shown as lines with different styles (solid/dashed)."
        case .groupedBars:
            return "Traditional grouped bar chart with clusters for each snapshot. Within each cluster, bars are grouped by metric type and colored by side."
        }
    }
}

// MARK: - Prototype 1: Dual Line Chart (Recommended for Clarity)
struct Prototype1_DualLineChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Hip Mobility Chart
            VStack(alignment: .leading, spacing: Spacing.m) {
                // Header
                HStack {
                    Image(systemName: "figure.flexibility")
                        .foregroundColor(.hipMobilityColor)
                    Text("Hip Mobility Over Time")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                // Legend
                HStack(spacing: Spacing.xl) {
                    ProtoLegendItem(color: .leftSide, label: "Left", shape: .line)
                    ProtoLegendItem(color: .rightSide, label: "Right", shape: .line)
                }
                
                // Chart
                DualLineChartView(
                    snapshots: snapshots,
                    metricType: .mobility,
                    height: 200
                )
                
                // Stats
                MetricStatsRow(
                    leftAvg: calculateAverage(\.injuryMetrics.leftLeg.hipMobility),
                    rightAvg: calculateAverage(\.injuryMetrics.rightLeg.hipMobility),
                    metricName: "Mobility"
                )
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            
            // Hip Stability Chart
            VStack(alignment: .leading, spacing: Spacing.m) {
                // Header
                HStack {
                    Image(systemName: "figure.stand")
                        .foregroundColor(.hipStabilityColor)
                    Text("Hip Stability Over Time")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                // Legend
                HStack(spacing: Spacing.xl) {
                    ProtoLegendItem(color: .leftSide, label: "Left", shape: .line)
                    ProtoLegendItem(color: .rightSide, label: "Right", shape: .line)
                }
                
                // Chart
                DualLineChartView(
                    snapshots: snapshots,
                    metricType: .stability,
                    height: 200
                )
                
                // Stats
                MetricStatsRow(
                    leftAvg: calculateAverage(\.injuryMetrics.leftLeg.hipStability),
                    rightAvg: calculateAverage(\.injuryMetrics.rightLeg.hipStability),
                    metricName: "Stability"
                )
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
    
    private func calculateAverage(_ keyPath: KeyPath<RunSnapshot, Int>) -> Int {
        guard !snapshots.isEmpty else { return 0 }
        let sum = snapshots.reduce(0) { $0 + $1[keyPath: keyPath] }
        return sum / snapshots.count
    }
}

// MARK: - Prototype 2: Stacked Area Chart
struct Prototype2_StackedArea: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            chartSection(title: "Hip Mobility", metricType: .mobility)
            chartSection(title: "Hip Stability", metricType: .stability)
        }
    }
    
    private func chartSection(title: String, metricType: HipMetricType) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.xl) {
                ProtoLegendItem(color: .leftSide, label: "Left", shape: .area)
                ProtoLegendItem(color: .rightSide, label: "Right", shape: .area)
            }
            
            StackedAreaChartView(
                snapshots: snapshots,
                metricType: metricType,
                height: 200
            )
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Prototype 3: Mirrored Bars (Good for Symmetry)
struct Prototype3_MirroredBars: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            chartSection(title: "Hip Mobility", metricType: .mobility)
            chartSection(title: "Hip Stability", metricType: .stability)
        }
    }
    
    private func chartSection(title: String, metricType: HipMetricType) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.xl) {
                HStack(spacing: Spacing.xs) {
                    Rectangle()
                        .fill(Color.leftSide)
                        .frame(width: 12, height: 4)
                    Text("Left")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                HStack(spacing: Spacing.xs) {
                    Rectangle()
                        .fill(Color.rightSide)
                        .frame(width: 12, height: 4)
                    Text("Right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            MirroredBarChartView(
                snapshots: snapshots,
                metricType: metricType,
                height: 200
            )
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Prototype 4: Overlayed Bars
struct Prototype4_OverlayedBars: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            chartSection(title: "Hip Mobility", metricType: .mobility)
            chartSection(title: "Hip Stability", metricType: .stability)
        }
    }
    
    private func chartSection(title: String, metricType: HipMetricType) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.xl) {
                ProtoLegendItem(color: .leftSide, label: "Left", shape: .bar)
                ProtoLegendItem(color: .rightSide, label: "Right", shape: .bar)
            }
            
            OverlayedBarChartView(
                snapshots: snapshots,
                metricType: metricType,
                height: 200
            )
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Prototype 5: Dual Y-Axis (Advanced)
struct Prototype5_DualYAxis: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Hip Metrics - Dual Axis")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            // Complex legend
            VStack(alignment: .leading, spacing: Spacing.s) {
                HStack(spacing: Spacing.xl) {
                    HStack(spacing: Spacing.xs) {
                        DashedLine(color: .leftSide, length: 20)
                        Text("Left")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    HStack(spacing: Spacing.xs) {
                        DashedLine(color: .rightSide, length: 20)
                        Text("Right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                HStack(spacing: Spacing.xl) {
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.hipMobilityColor)
                            .frame(width: 8, height: 8)
                        Text("Mobility (Left)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.hipStabilityColor)
                            .frame(width: 8, height: 8)
                        Text("Stability (Right)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            DualYAxisChartView(
                snapshots: snapshots,
                height: 250
            )
            
            Text("Mobility scale on left, Stability scale on right")
                .font(.caption)
                .foregroundColor(.textTertiary)
                .italic()
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Prototype 6: Grouped Bars (Traditional)
struct Prototype6_GroupedBars: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Hip Metrics - Grouped View")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            // Legend
            HStack(spacing: Spacing.m) {
                HStack(spacing: Spacing.xs) {
                    Rectangle()
                        .fill(Color.leftSide)
                        .frame(width: 12, height: 12)
                    Text("Left")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                HStack(spacing: Spacing.xs) {
                    Rectangle()
                        .fill(Color.rightSide)
                        .frame(width: 12, height: 12)
                    Text("Right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            GroupedBarChartView(
                snapshots: snapshots,
                height: 300
            )
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Supporting Enums
enum HipMetricType {
    case mobility, stability
}

enum LegendShape {
    case line, area, bar
}

// MARK: - Chart Implementations

// MARK: - Dual Line Chart View
struct DualLineChartView: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double(getValue($0, leg: .left)) }
                let rightValues = snapshots.map { Double(getValue($0, leg: .right)) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Draw left line (cyan)
                var leftPath = Path()
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    if index == 0 {
                        leftPath.move(to: CGPoint(x: x, y: y))
                    } else {
                        leftPath.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                context.stroke(leftPath, with: .color(.leftSide), lineWidth: 2.5)
                
                // Draw right line (magenta)
                var rightPath = Path()
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    if index == 0 {
                        rightPath.move(to: CGPoint(x: x, y: y))
                    } else {
                        rightPath.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                context.stroke(rightPath, with: .color(.rightSide), lineWidth: 2.5)
                
                // Draw dots
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6)),
                        with: .color(.leftSide)
                    )
                }
                
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6)),
                        with: .color(.rightSide)
                    )
                }
                
                // Draw grid lines
                for i in 0...4 {
                    let y = size.height * CGFloat(i) / 4
                    var gridPath = Path()
                    gridPath.move(to: CGPoint(x: 0, y: y))
                    gridPath.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(
                        gridPath,
                        with: .color(.cardBorder),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                    )
                }
            }
        }
        .frame(height: height)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
    
    private func getValue(_ snapshot: RunSnapshot, leg: LegSide) -> Int {
        switch (metricType, leg) {
        case (.mobility, .left): return snapshot.injuryMetrics.leftLeg.hipMobility
        case (.mobility, .right): return snapshot.injuryMetrics.rightLeg.hipMobility
        case (.stability, .left): return snapshot.injuryMetrics.leftLeg.hipStability
        case (.stability, .right): return snapshot.injuryMetrics.rightLeg.hipStability
        }
    }
}

// MARK: - Stacked Area Chart View
struct StackedAreaChartView: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double(getValue($0, leg: .left)) }
                let rightValues = snapshots.map { Double(getValue($0, leg: .right)) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Draw left area (cyan)
                var leftPath = Path()
                leftPath.move(to: CGPoint(x: 0, y: size.height))
                
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    leftPath.addLine(to: CGPoint(x: x, y: y))
                }
                
                leftPath.addLine(to: CGPoint(x: size.width, y: size.height))
                leftPath.closeSubpath()
                
                context.fill(leftPath, with: .color(.leftSide.opacity(0.3)))
                
                // Draw right area (magenta)
                var rightPath = Path()
                rightPath.move(to: CGPoint(x: 0, y: size.height))
                
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    rightPath.addLine(to: CGPoint(x: x, y: y))
                }
                
                rightPath.addLine(to: CGPoint(x: size.width, y: size.height))
                rightPath.closeSubpath()
                
                context.fill(rightPath, with: .color(.rightSide.opacity(0.3)))
            }
        }
        .frame(height: height)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
    
    private func getValue(_ snapshot: RunSnapshot, leg: LegSide) -> Int {
        switch (metricType, leg) {
        case (.mobility, .left): return snapshot.injuryMetrics.leftLeg.hipMobility
        case (.mobility, .right): return snapshot.injuryMetrics.rightLeg.hipMobility
        case (.stability, .left): return snapshot.injuryMetrics.leftLeg.hipStability
        case (.stability, .right): return snapshot.injuryMetrics.rightLeg.hipStability
        }
    }
}

// MARK: - Mirrored Bar Chart View
struct MirroredBarChartView: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard !snapshots.isEmpty else { return }
                
                let centerY = size.height / 2
                let barWidth = size.width / CGFloat(snapshots.count) * 0.8
                let spacing = size.width / CGFloat(snapshots.count) * 0.2
                
                for (index, snapshot) in snapshots.enumerated() {
                    let leftValue = Double(getValue(snapshot, leg: .left))
                    let rightValue = Double(getValue(snapshot, leg: .right))
                    
                    let x = CGFloat(index) * (barWidth + spacing) + spacing / 2
                    
                    // Left bar (grows upward)
                    let leftHeight = (leftValue / 100.0) * (centerY - 10)
                    let leftRect = CGRect(
                        x: x,
                        y: centerY - leftHeight,
                        width: barWidth,
                        height: leftHeight
                    )
                    context.fill(Path(roundedRect: leftRect, cornerRadius: 2), with: .color(.leftSide))
                    
                    // Right bar (grows downward)
                    let rightHeight = (rightValue / 100.0) * (centerY - 10)
                    let rightRect = CGRect(
                        x: x,
                        y: centerY,
                        width: barWidth,
                        height: rightHeight
                    )
                    context.fill(Path(roundedRect: rightRect, cornerRadius: 2), with: .color(.rightSide))
                }
                
                // Draw center line
                var centerLine = Path()
                centerLine.move(to: CGPoint(x: 0, y: centerY))
                centerLine.addLine(to: CGPoint(x: size.width, y: centerY))
                context.stroke(centerLine, with: .color(.cardBorder), lineWidth: 2)
            }
        }
        .frame(height: height)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
    
    private func getValue(_ snapshot: RunSnapshot, leg: LegSide) -> Int {
        switch (metricType, leg) {
        case (.mobility, .left): return snapshot.injuryMetrics.leftLeg.hipMobility
        case (.mobility, .right): return snapshot.injuryMetrics.rightLeg.hipMobility
        case (.stability, .left): return snapshot.injuryMetrics.leftLeg.hipStability
        case (.stability, .right): return snapshot.injuryMetrics.rightLeg.hipStability
        }
    }
}

// MARK: - Overlayed Bar Chart View
struct OverlayedBarChartView: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard !snapshots.isEmpty else { return }
                
                let groupWidth = size.width / CGFloat(snapshots.count)
                let barWidth = groupWidth * 0.35
                let spacing = groupWidth * 0.15
                
                for (index, snapshot) in snapshots.enumerated() {
                    let leftValue = Double(getValue(snapshot, leg: .left))
                    let rightValue = Double(getValue(snapshot, leg: .right))
                    
                    let groupX = CGFloat(index) * groupWidth
                    
                    // Left bar
                    let leftHeight = (leftValue / 100.0) * size.height
                    let leftRect = CGRect(
                        x: groupX + spacing,
                        y: size.height - leftHeight,
                        width: barWidth,
                        height: leftHeight
                    )
                    context.fill(Path(roundedRect: leftRect, cornerRadius: 2), with: .color(.leftSide))
                    
                    // Right bar
                    let rightHeight = (rightValue / 100.0) * size.height
                    let rightRect = CGRect(
                        x: groupX + spacing + barWidth + spacing / 2,
                        y: size.height - rightHeight,
                        width: barWidth,
                        height: rightHeight
                    )
                    context.fill(Path(roundedRect: rightRect, cornerRadius: 2), with: .color(.rightSide))
                }
            }
        }
        .frame(height: height)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
    
    private func getValue(_ snapshot: RunSnapshot, leg: LegSide) -> Int {
        switch (metricType, leg) {
        case (.mobility, .left): return snapshot.injuryMetrics.leftLeg.hipMobility
        case (.mobility, .right): return snapshot.injuryMetrics.rightLeg.hipMobility
        case (.stability, .left): return snapshot.injuryMetrics.leftLeg.hipStability
        case (.stability, .right): return snapshot.injuryMetrics.rightLeg.hipStability
        }
    }
}

// MARK: - Dual Y-Axis Chart View
struct DualYAxisChartView: View {
    let snapshots: [RunSnapshot]
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Mobility lines (left Y-axis, 0-100)
                drawLine(
                    context: context,
                    size: size,
                    values: snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) },
                    color: .leftSide,
                    style: .solid
                )
                
                drawLine(
                    context: context,
                    size: size,
                    values: snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) },
                    color: .rightSide,
                    style: .solid
                )
                
                // Stability lines (right Y-axis, 0-100) - slightly offset for visibility
                drawLine(
                    context: context,
                    size: size,
                    values: snapshots.map { Double($0.injuryMetrics.leftLeg.hipStability) },
                    color: .leftSide.opacity(0.6),
                    style: .dashed
                )
                
                drawLine(
                    context: context,
                    size: size,
                    values: snapshots.map { Double($0.injuryMetrics.rightLeg.hipStability) },
                    color: .rightSide.opacity(0.6),
                    style: .dashed
                )
            }
        }
        .frame(height: height)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
    
    private func drawLine(
        context: GraphicsContext,
        size: CGSize,
        values: [Double],
        color: Color,
        style: LineStyle
    ) {
        guard values.count > 1,
              let minValue = values.min(),
              let maxValue = values.max(),
              maxValue > minValue else { return }
        
        let valueRange = maxValue - minValue
        let xStep = size.width / CGFloat(values.count - 1)
        
        var path = Path()
        for (index, value) in values.enumerated() {
            let x = CGFloat(index) * xStep
            let normalizedValue = (value - minValue) / valueRange
            let y = size.height - (CGFloat(normalizedValue) * size.height)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        switch style {
        case .solid:
            context.stroke(path, with: .color(color), lineWidth: 2)
        case .dashed:
            context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
        }
    }
    
    enum LineStyle {
        case solid, dashed
    }
}

// MARK: - Grouped Bar Chart View
struct GroupedBarChartView: View {
    let snapshots: [RunSnapshot]
    let height: CGFloat
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GeometryReader { geometry in
                Canvas { context, size in
                    guard !snapshots.isEmpty else { return }
                    
                    let groupWidth: CGFloat = 80
                    let barWidth: CGFloat = 15
                    let spacing: CGFloat = 5
                    
                    for (index, snapshot) in snapshots.enumerated() {
                        let groupX = CGFloat(index) * (groupWidth + 20)
                        
                        // Mobility - Left
                        let leftMobValue = Double(snapshot.injuryMetrics.leftLeg.hipMobility)
                        let leftMobHeight = (leftMobValue / 100.0) * size.height
                        context.fill(
                            Path(roundedRect: CGRect(
                                x: groupX,
                                y: size.height - leftMobHeight,
                                width: barWidth,
                                height: leftMobHeight
                            ), cornerRadius: 2),
                            with: .color(.leftSide)
                        )
                        
                        // Mobility - Right
                        let rightMobValue = Double(snapshot.injuryMetrics.rightLeg.hipMobility)
                        let rightMobHeight = (rightMobValue / 100.0) * size.height
                        context.fill(
                            Path(roundedRect: CGRect(
                                x: groupX + barWidth + spacing,
                                y: size.height - rightMobHeight,
                                width: barWidth,
                                height: rightMobHeight
                            ), cornerRadius: 2),
                            with: .color(.rightSide)
                        )
                        
                        // Stability - Left
                        let leftStabValue = Double(snapshot.injuryMetrics.leftLeg.hipStability)
                        let leftStabHeight = (leftStabValue / 100.0) * size.height
                        context.fill(
                            Path(roundedRect: CGRect(
                                x: groupX + (barWidth + spacing) * 2 + 10,
                                y: size.height - leftStabHeight,
                                width: barWidth,
                                height: leftStabHeight
                            ), cornerRadius: 2),
                            with: .color(.leftSide.opacity(0.6))
                        )
                        
                        // Stability - Right
                        let rightStabValue = Double(snapshot.injuryMetrics.rightLeg.hipStability)
                        let rightStabHeight = (rightStabValue / 100.0) * size.height
                        context.fill(
                            Path(roundedRect: CGRect(
                                x: groupX + (barWidth + spacing) * 3 + 10,
                                y: size.height - rightStabHeight,
                                width: barWidth,
                                height: rightStabHeight
                            ), cornerRadius: 2),
                            with: .color(.rightSide.opacity(0.6))
                        )
                        
                        // Snapshot label
                        let snapshotLabel = Text("\(index + 1)")
                            .font(.system(size: 10))
                            .foregroundColor(.textTertiary)
                        context.draw(snapshotLabel, at: CGPoint(x: groupX + 30, y: size.height + 10))
                    }
                }
            }
            .frame(width: CGFloat(snapshots.count) * 100, height: height)
        }
        .frame(height: height + 20)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Supporting Components

struct ProtoLegendItem: View {
    let color: Color
    let label: String
    let shape: LegendShape
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Group {
                switch shape {
                case .line:
                    Rectangle()
                        .fill(color)
                        .frame(width: 20, height: 3)
                case .area:
                    Rectangle()
                        .fill(color.opacity(0.5))
                        .frame(width: 16, height: 12)
                case .bar:
                    Rectangle()
                        .fill(color)
                        .frame(width: 12, height: 12)
                }
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

struct MetricStatsRow: View {
    let leftAvg: Int
    let rightAvg: Int
    let metricName: String
    
    private var asymmetry: Int {
        abs(leftAvg - rightAvg)
    }
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            VStack(spacing: 4) {
                Text("L")
                    .font(.caption)
                    .foregroundColor(.leftSide)
                Text("\(leftAvg)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(Color.leftSide.opacity(0.1))
            .cornerRadius(CornerRadius.small)
            
            VStack(spacing: 4) {
                Text("R")
                    .font(.caption)
                    .foregroundColor(.rightSide)
                Text("\(rightAvg)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(Color.rightSide.opacity(0.1))
            .cornerRadius(CornerRadius.small)
            
            VStack(spacing: 4) {
                Text("Δ")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                Text("\(asymmetry)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(asymmetry > 10 ? .errorRed : .textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(Color.cardBorder.opacity(0.3))
            .cornerRadius(CornerRadius.small)
        }
    }
}

struct DashedLine: View {
    let color: Color
    let length: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 2))
                path.addLine(to: CGPoint(x: length, y: 2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
        }
        .frame(width: length, height: 4)
    }
}

// MARK: - Preview
#Preview("All Prototypes") {
    NavigationStack {
        HipMetricsVisualizationPrototypes(
            snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
        )
    }
}

#Preview("Dual Line Chart") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            Prototype1_DualLineChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
            )
            .padding(Spacing.m)
        }
    }
}

#Preview("Mirrored Bars") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        ScrollView {
            Prototype3_MirroredBars(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
            )
            .padding(Spacing.m)
        }
    }
}
