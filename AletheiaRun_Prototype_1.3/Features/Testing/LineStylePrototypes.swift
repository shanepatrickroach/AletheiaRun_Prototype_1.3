// Features/RunDetail/DualColorLinePrototypes.swift

import SwiftUI

/// Demonstrates different techniques for combining metric color + leg side color in line charts
/// This allows you to show both "what metric" (mobility/stability) and "which side" (left/right)
struct DualColorLinePrototypes: View {
    let snapshots: [RunSnapshot]
    @State private var selectedStyle: DualColorStyle = .gradientBlend
    
    enum DualColorStyle: String, CaseIterable {
        case gradientBlend = "Gradient Blend"
        case stripedPattern = "Striped Pattern"
        case coloredDots = "Colored Dots on Line"
        case dualStroke = "Dual Stroke (Outline)"
        case segmentedGradient = "Segmented Gradient"
        case coloredShadow = "Colored Shadow/Glow"
        case alternatingSegments = "Alternating Segments"
        case thickThin = "Thick (Metric) + Thin (Side)"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Style selector
                    styleSelector
                    
                    // Hip Mobility Example
                    mobilityExample
                    
                    // Hip Stability Example
                    stabilityExample
                    
                    // Description
                    styleDescription
                    
                    // Color key
                    colorKeyDisplay
                }
                .padding(Spacing.m)
            }
        }
    }
    
    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Dual Color Line Styles")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    ForEach(DualColorStyle.allCases, id: \.self) { style in
                        Button(action: {
                            withAnimation {
                                selectedStyle = style
                            }
                        }) {
                            Text(style.rawValue)
                                .font(.bodySmall)
                                .foregroundColor(selectedStyle == style ? .backgroundBlack : .textPrimary)
                                .padding(.horizontal, Spacing.m)
                                .padding(.vertical, Spacing.s)
                                .background(selectedStyle == style ? Color.primaryOrange : Color.cardBackground)
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
    
    private var mobilityExample: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "figure.flexibility")
                    .foregroundColor(.hipMobilityColor)
                Text("Hip Mobility")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            // Legend for this metric
            HStack(spacing: Spacing.xl) {
                HStack(spacing: Spacing.xs) {
                    DualColorLegendItem(
                        metricColor: .hipMobilityColor,
                        sideColor: .leftSide,
                        style: selectedStyle
                    )
                    Text("Left")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: Spacing.xs) {
                    DualColorLegendItem(
                        metricColor: .hipMobilityColor,
                        sideColor: .rightSide,
                        style: selectedStyle
                    )
                    Text("Right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Chart
            dualColorChartView(metricType: .mobility)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    private var stabilityExample: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "figure.stand")
                    .foregroundColor(.hipStabilityColor)
                Text("Hip Stability")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            // Legend for this metric
            HStack(spacing: Spacing.xl) {
                HStack(spacing: Spacing.xs) {
                    DualColorLegendItem(
                        metricColor: .hipStabilityColor,
                        sideColor: .leftSide,
                        style: selectedStyle
                    )
                    Text("Left")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: Spacing.xs) {
                    DualColorLegendItem(
                        metricColor: .hipStabilityColor,
                        sideColor: .rightSide,
                        style: selectedStyle
                    )
                    Text("Right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Chart
            dualColorChartView(metricType: .stability)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    @ViewBuilder
    private func dualColorChartView(metricType: HipMetricType) -> some View {
        switch selectedStyle {
        case .gradientBlend:
            GradientBlendChart(snapshots: snapshots, metricType: metricType)
        case .stripedPattern:
            StripedPatternChart(snapshots: snapshots, metricType: metricType)
        case .coloredDots:
            ColoredDotsChart(snapshots: snapshots, metricType: metricType)
        case .dualStroke:
            DualStrokeChart(snapshots: snapshots, metricType: metricType)
        case .segmentedGradient:
            SegmentedGradientChart(snapshots: snapshots, metricType: metricType)
        case .coloredShadow:
            ColoredShadowChart(snapshots: snapshots, metricType: metricType)
        case .alternatingSegments:
            AlternatingSegmentsChart(snapshots: snapshots, metricType: metricType)
        case .thickThin:
            ThickThinDualChart(snapshots: snapshots, metricType: metricType)
        }
    }
    
    private var styleDescription: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("How It Works")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(currentDescription)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Color Meaning:")
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.xs)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("• Metric Color (Green/Blue) = What type of measurement")
                Text("• Side Color (Cyan/Magenta) = Which leg")
                Text("• Combined = Full context at a glance")
            }
            .font(.caption)
            .foregroundColor(.textSecondary)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    private var colorKeyDisplay: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Color Key")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            // Metric colors
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Metric Types:")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                HStack(spacing: Spacing.xl) {
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.hipMobilityColor)
                            .frame(width: 12, height: 12)
                        Text("Mobility")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.hipStabilityColor)
                            .frame(width: 12, height: 12)
                        Text("Stability")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Side colors
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Leg Side:")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                HStack(spacing: Spacing.xl) {
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.leftSide)
                            .frame(width: 12, height: 12)
                        Text("Left")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color.rightSide)
                            .frame(width: 12, height: 12)
                        Text("Right")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    private var currentDescription: String {
        switch selectedStyle {
        case .gradientBlend:
            return "Lines use a gradient that blends the metric color (green for mobility, blue for stability) with the side color (cyan for left, magenta for right). Creates smooth, professional-looking lines."
        case .stripedPattern:
            return "Lines alternate between metric color and side color in a striped pattern. Think of a barber pole effect - both colors are clearly visible."
        case .coloredDots:
            return "Solid line in metric color, with dots/markers at data points in the side color. Clean and data-focused."
        case .dualStroke:
            return "Line has two strokes - thick inner stroke in metric color, thin outer outline in side color. Creates a bordered effect."
        case .segmentedGradient:
            return "Each line segment between points has its own gradient from metric color to side color. Dynamic and modern."
        case .coloredShadow:
            return "Solid line in metric color with a glowing shadow/halo in the side color. Adds depth and visual hierarchy."
        case .alternatingSegments:
            return "Each segment between data points alternates between metric color and side color. Creates a clear pattern."
        case .thickThin:
            return "Thick line in metric color with a thin parallel line in side color running alongside. Both colors fully visible."
        }
    }
}

// MARK: - Chart Implementations

// MARK: - 1. Gradient Blend (Recommended) ⭐
struct GradientBlendChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left line - Gradient from metric color to cyan
                for index in 0..<leftValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (leftValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (leftValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    context.stroke(
                        segmentPath,
                        with: .linearGradient(
                            Gradient(colors: [metricColor, Color.leftSide]),
                            startPoint: CGPoint(x: x1, y: y1),
                            endPoint: CGPoint(x: x2, y: y2)
                        ),
                        lineWidth: 3
                    )
                }
                
                // Right line - Gradient from metric color to magenta
                for index in 0..<rightValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (rightValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (rightValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    context.stroke(
                        segmentPath,
                        with: .linearGradient(
                            Gradient(colors: [metricColor, Color.rightSide]),
                            startPoint: CGPoint(x: x1, y: y1),
                            endPoint: CGPoint(x: x2, y: y2)
                        ),
                        lineWidth: 3
                    )
                }
            }
        }
        .frame(height: 200)
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

// MARK: - 2. Striped Pattern (Barber Pole Effect)
struct StripedPatternChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left line - Striped pattern (metric color + cyan)
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
                
                // Draw alternating dashes with different colors
                context.stroke(
                    leftPath,
                    with: .color(metricColor),
                    style: StrokeStyle(lineWidth: 4, dash: [8, 8])
                )
                context.stroke(
                    leftPath,
                    with: .color(.leftSide),
                    style: StrokeStyle(lineWidth: 4, dash: [8, 8], dashPhase: 8)
                )
                
                // Right line - Striped pattern (metric color + magenta)
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
                
                context.stroke(
                    rightPath,
                    with: .color(metricColor),
                    style: StrokeStyle(lineWidth: 4, dash: [8, 8])
                )
                context.stroke(
                    rightPath,
                    with: .color(.rightSide),
                    style: StrokeStyle(lineWidth: 4, dash: [8, 8], dashPhase: 8)
                )
            }
        }
        .frame(height: 200)
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

// MARK: - 3. Colored Dots on Line ⭐
struct ColoredDotsChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left line in metric color
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
                context.stroke(leftPath, with: .color(metricColor), lineWidth: 2)
                
                // Dots in cyan (side color)
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                        with: .color(.leftSide)
                    )
                }
                
                // Right line in metric color
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
                context.stroke(rightPath, with: .color(metricColor), lineWidth: 2)
                
                // Dots in magenta (side color)
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                        with: .color(.rightSide)
                    )
                }
            }
        }
        .frame(height: 200)
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

// MARK: - 4. Dual Stroke (Outline) ⭐
struct DualStrokeChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left line
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
                
                // Outer stroke (side color - cyan)
                context.stroke(leftPath, with: .color(.leftSide), lineWidth: 5)
                // Inner stroke (metric color)
                context.stroke(leftPath, with: .color(metricColor), lineWidth: 3)
                
                // Right line
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
                
                // Outer stroke (side color - magenta)
                context.stroke(rightPath, with: .color(.rightSide), lineWidth: 5)
                // Inner stroke (metric color)
                context.stroke(rightPath, with: .color(metricColor), lineWidth: 3)
            }
        }
        .frame(height: 200)
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

// MARK: - 5. Segmented Gradient
struct SegmentedGradientChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left segments - each segment alternates gradient direction
                for index in 0..<leftValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (leftValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (leftValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    // Alternate gradient direction
                    let colors = index % 2 == 0 ?
                        [metricColor, Color.leftSide] :
                        [Color.leftSide, metricColor]
                    
                    context.stroke(
                        segmentPath,
                        with: .linearGradient(
                            Gradient(colors: colors),
                            startPoint: CGPoint(x: x1, y: y1),
                            endPoint: CGPoint(x: x2, y: y2)
                        ),
                        lineWidth: 3
                    )
                }
                
                // Right segments
                for index in 0..<rightValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (rightValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (rightValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    // Alternate gradient direction
                    let colors = index % 2 == 0 ?
                        [metricColor, Color.rightSide] :
                        [Color.rightSide, metricColor]
                    
                    context.stroke(
                        segmentPath,
                        with: .linearGradient(
                            Gradient(colors: colors),
                            startPoint: CGPoint(x: x1, y: y1),
                            endPoint: CGPoint(x: x2, y: y2)
                        ),
                        lineWidth: 3
                    )
                }
            }
        }
        .frame(height: 200)
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

// MARK: - 6. Colored Shadow/Glow
struct ColoredShadowChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left line
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
                
                // Glow/shadow in side color (cyan)
                context.stroke(leftPath, with: .color(.leftSide.opacity(0.4)), lineWidth: 10)
                // Main line in metric color
                context.stroke(leftPath, with: .color(metricColor), lineWidth: 3)
                
                // Right line
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
                
                // Glow/shadow in side color (magenta)
                context.stroke(rightPath, with: .color(.rightSide.opacity(0.4)), lineWidth: 10)
                // Main line in metric color
                context.stroke(rightPath, with: .color(metricColor), lineWidth: 3)
            }
        }
        .frame(height: 200)
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

// MARK: - 7. Alternating Segments
struct AlternatingSegmentsChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                
                // Left segments - alternate colors
                for index in 0..<leftValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (leftValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (leftValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    let color = index % 2 == 0 ? metricColor : Color.leftSide
                    context.stroke(segmentPath, with: .color(color), lineWidth: 3)
                }
                
                // Right segments - alternate colors
                for index in 0..<rightValues.count - 1 {
                    let x1 = CGFloat(index) * xStep
                    let normalizedValue1 = (rightValues[index] - minValue) / valueRange
                    let y1 = size.height - (CGFloat(normalizedValue1) * size.height)
                    
                    let x2 = CGFloat(index + 1) * xStep
                    let normalizedValue2 = (rightValues[index + 1] - minValue) / valueRange
                    let y2 = size.height - (CGFloat(normalizedValue2) * size.height)
                    
                    var segmentPath = Path()
                    segmentPath.move(to: CGPoint(x: x1, y: y1))
                    segmentPath.addLine(to: CGPoint(x: x2, y: y2))
                    
                    let color = index % 2 == 0 ? metricColor : Color.rightSide
                    context.stroke(segmentPath, with: .color(color), lineWidth: 3)
                }
            }
        }
        .frame(height: 200)
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

// MARK: - 8. Thick + Thin Parallel Lines
struct ThickThinDualChart: View {
    let snapshots: [RunSnapshot]
    let metricType: HipMetricType
    
    private var metricColor: Color {
        metricType == .mobility ? .hipMobilityColor : .hipStabilityColor
    }
    
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
                let offset: CGFloat = 2  // Offset for parallel line
                
                // Left - thick metric line
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
                context.stroke(leftPath, with: .color(metricColor), lineWidth: 4)
                
                // Left - thin side line (parallel, offset)
                var leftSidePath = Path()
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height) + offset
                    
                    if index == 0 {
                        leftSidePath.move(to: CGPoint(x: x, y: y))
                    } else {
                        leftSidePath.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                context.stroke(leftSidePath, with: .color(.leftSide), lineWidth: 1.5)
                
                // Right - thick metric line
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
                context.stroke(rightPath, with: .color(metricColor), lineWidth: 4)
                
                // Right - thin side line (parallel, offset)
                var rightSidePath = Path()
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height) + offset
                    
                    if index == 0 {
                        rightSidePath.move(to: CGPoint(x: x, y: y))
                    } else {
                        rightSidePath.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                context.stroke(rightSidePath, with: .color(.rightSide), lineWidth: 1.5)
            }
        }
        .frame(height: 200)
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

// MARK: - Legend Component
struct DualColorLegendItem: View {
    let metricColor: Color
    let sideColor: Color
    let style: DualColorLinePrototypes.DualColorStyle
    
    var body: some View {
        Group {
            switch style {
            case .gradientBlend:
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [metricColor, sideColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 30, height: 3)
                    
            case .stripedPattern:
                HStack(spacing: 0) {
                    Rectangle().fill(metricColor).frame(width: 6, height: 4)
                    Rectangle().fill(sideColor).frame(width: 6, height: 4)
                    Rectangle().fill(metricColor).frame(width: 6, height: 4)
                    Rectangle().fill(sideColor).frame(width: 6, height: 4)
                    Rectangle().fill(metricColor).frame(width: 6, height: 4)
                }
                
            case .coloredDots:
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(metricColor)
                        .frame(width: 20, height: 3)
                    Circle()
                        .fill(sideColor)
                        .frame(width: 6, height: 6)
                }
                
            case .dualStroke:
                ZStack {
                    Rectangle()
                        .fill(sideColor)
                        .frame(width: 30, height: 5)
                    Rectangle()
                        .fill(metricColor)
                        .frame(width: 30, height: 3)
                }
                
            case .segmentedGradient:
                HStack(spacing: 2) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [metricColor, sideColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 13, height: 3)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [sideColor, metricColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 13, height: 3)
                }
                
            case .coloredShadow:
                ZStack {
                    Rectangle()
                        .fill(sideColor.opacity(0.4))
                        .frame(width: 30, height: 8)
                        .blur(radius: 2)
                    Rectangle()
                        .fill(metricColor)
                        .frame(width: 30, height: 3)
                }
                
            case .alternatingSegments:
                HStack(spacing: 0) {
                    Rectangle().fill(metricColor).frame(width: 10, height: 3)
                    Rectangle().fill(sideColor).frame(width: 10, height: 3)
                    Rectangle().fill(metricColor).frame(width: 10, height: 3)
                }
                
            case .thickThin:
                VStack(spacing: 1) {
                    Rectangle()
                        .fill(metricColor)
                        .frame(width: 30, height: 4)
                    Rectangle()
                        .fill(sideColor)
                        .frame(width: 30, height: 1.5)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("All Dual Color Styles") {
    NavigationStack {
        DualColorLinePrototypes(
            snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
        )
    }
}

#Preview("Gradient Blend") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        VStack(spacing: Spacing.xl) {
            GradientBlendChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10),
                metricType: .mobility
            )
            .padding(Spacing.m)
        }
    }
}

#Preview("Colored Dots") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        VStack(spacing: Spacing.xl) {
            ColoredDotsChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10),
                metricType: .stability
            )
            .padding(Spacing.m)
        }
    }
}

#Preview("Dual Stroke") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        VStack(spacing: Spacing.xl) {
            DualStrokeChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10),
                metricType: .mobility
            )
            .padding(Spacing.m)
        }
    }
}
