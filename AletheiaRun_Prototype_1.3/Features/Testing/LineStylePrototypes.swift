// Features/RunDetail/LineStylePrototypes.swift

import SwiftUI

/// Comprehensive demonstration of different line styles for distinguishing left vs right metrics
struct LineStylePrototypes: View {
    let snapshots: [RunSnapshot]
    @State private var selectedStyle: LineStyleOption = .solidVsDashed
    
    enum LineStyleOption: String, CaseIterable {
        case solidVsDashed = "Solid vs Dashed"
        case solidVsDotted = "Solid vs Dotted"
        case thickVsThin = "Thick vs Thin"
        case differentDashPatterns = "Different Dash Patterns"
        case colorWithPattern = "Color + Pattern"
        case shapeMarkers = "Line with Markers"
        case gradientLines = "Gradient Lines"
        case shadowedLines = "Lines with Shadow"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Style selector
                    styleSelector
                    
                    // Current style display
                    currentStyleView
                    
                    // Description
                    styleDescription
                    
                    // Legend showing the pattern
                    legendDisplay
                }
                .padding(Spacing.m)
            }
        }
    }
    
    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Line Style Options")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    ForEach(LineStyleOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selectedStyle = option
                            }
                        }) {
                            Text(option.rawValue)
                                .font(.bodySmall)
                                .foregroundColor(selectedStyle == option ? .backgroundBlack : .textPrimary)
                                .padding(.horizontal, Spacing.m)
                                .padding(.vertical, Spacing.s)
                                .background(selectedStyle == option ? Color.primaryOrange : Color.cardBackground)
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
    private var currentStyleView: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Hip Mobility Over Time")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            switch selectedStyle {
            case .solidVsDashed:
                SolidVsDashedChart(snapshots: snapshots)
            case .solidVsDotted:
                SolidVsDottedChart(snapshots: snapshots)
            case .thickVsThin:
                ThickVsThinChart(snapshots: snapshots)
            case .differentDashPatterns:
                DifferentDashPatternsChart(snapshots: snapshots)
            case .colorWithPattern:
                ColorWithPatternChart(snapshots: snapshots)
            case .shapeMarkers:
                LineWithMarkersChart(snapshots: snapshots)
            case .gradientLines:
                GradientLinesChart(snapshots: snapshots)
            case .shadowedLines:
                ShadowedLinesChart(snapshots: snapshots)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    private var styleDescription: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("About This Style")
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
    
    private var legendDisplay: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Legend")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.xl) {
                legendItemForCurrentStyle(side: .left)
                legendItemForCurrentStyle(side: .right)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    @ViewBuilder
    private func legendItemForCurrentStyle(side: LegSide) -> some View {
        HStack(spacing: Spacing.s) {
            switch selectedStyle {
            case .solidVsDashed:
                if side == .left {
                    SolidLineShape(color: .leftSide, width: 30)
                } else {
                    DashedLineShape(color: .rightSide, width: 30, pattern: [10, 5])
                }
            case .solidVsDotted:
                if side == .left {
                    SolidLineShape(color: .leftSide, width: 30)
                } else {
                    DashedLineShape(color: .rightSide, width: 30, pattern: [2, 4])
                }
            case .thickVsThin:
                if side == .left {
                    SolidLineShape(color: .leftSide, width: 30, thickness: 4)
                } else {
                    SolidLineShape(color: .rightSide, width: 30, thickness: 1.5)
                }
            case .differentDashPatterns:
                if side == .left {
                    DashedLineShape(color: .leftSide, width: 30, pattern: [10, 5])
                } else {
                    DashedLineShape(color: .rightSide, width: 30, pattern: [4, 4])
                }
            case .colorWithPattern:
                if side == .left {
                    DashedLineShape(color: .leftSide, width: 30, pattern: [8, 4])
                } else {
                    DashedLineShape(color: .rightSide, width: 30, pattern: [4, 2, 2, 2])
                }
            case .shapeMarkers:
                HStack(spacing: 4) {
                    SolidLineShape(color: side == .left ? .leftSide : .rightSide, width: 20)
                    if side == .left {
                        Circle()
                            .fill(Color.leftSide)
                            .frame(width: 6, height: 6)
                    } else {
                        Rectangle()
                            .fill(Color.rightSide)
                            .frame(width: 6, height: 6)
                    }
                }
            case .gradientLines:
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: side == .left ? 
                                [Color.leftSide.opacity(0.3), Color.leftSide] :
                                [Color.rightSide.opacity(0.3), Color.rightSide],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 30, height: 3)
            case .shadowedLines:
                SolidLineShape(
                    color: side == .left ? .leftSide : .rightSide,
                    width: 30
                )
            }
            
            Text(side == .left ? "Left" : "Right")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
    
    private var currentDescription: String {
        switch selectedStyle {
        case .solidVsDashed:
            return "Classic approach: solid line for left (cyan), dashed line for right (magenta). Highly distinguishable even in black and white."
        case .solidVsDotted:
            return "Solid line for left, dotted line for right. More subtle than dashed, good for dense data."
        case .thickVsThin:
            return "Both solid lines but different thickness. Left is thicker (4pt), right is thinner (1.5pt). Works well when color alone isn't enough."
        case .differentDashPatterns:
            return "Both dashed but with different patterns. Left has long dashes, right has short equal dashes. Great for accessibility."
        case .colorWithPattern:
            return "Combines color difference with pattern difference. Left is long dash, right is dot-dash pattern. Maximum distinguishability."
        case .shapeMarkers:
            return "Solid lines with different marker shapes at data points. Left uses circles, right uses squares. Very clear at each data point."
        case .gradientLines:
            return "Lines with gradient from light to dark. Creates visual depth and makes each line unique even beyond color."
        case .shadowedLines:
            return "Lines with subtle shadows or glow effects. Left has blue glow, right has magenta glow. Adds visual hierarchy."
        }
    }
}

// MARK: - Chart Implementations

// MARK: - 1. Solid vs Dashed (Most Common) ⭐
struct SolidVsDashedChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line - SOLID
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
                
                // Right line - DASHED
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
                    with: .color(.rightSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [10, 5])
                )
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 2. Solid vs Dotted
struct SolidVsDottedChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line - SOLID
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
                
                // Right line - DOTTED (very short dashes)
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
                    with: .color(.rightSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [2, 4])
                )
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 3. Thick vs Thin
struct ThickVsThinChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line - THICK
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
                context.stroke(leftPath, with: .color(.leftSide), lineWidth: 4)
                
                // Right line - THIN
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
                context.stroke(rightPath, with: .color(.rightSide), lineWidth: 1.5)
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 4. Different Dash Patterns ⭐
struct DifferentDashPatternsChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line - LONG DASHES
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
                context.stroke(
                    leftPath,
                    with: .color(.leftSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [10, 5])
                )
                
                // Right line - SHORT EQUAL DASHES
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
                    with: .color(.rightSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [4, 4])
                )
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 5. Color + Pattern (Maximum Distinction)
struct ColorWithPatternChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line - CYAN + LONG DASH
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
                context.stroke(
                    leftPath,
                    with: .color(.leftSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [8, 4])
                )
                
                // Right line - MAGENTA + DOT-DASH
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
                    with: .color(.rightSide),
                    style: StrokeStyle(lineWidth: 2.5, dash: [4, 2, 2, 2])
                )
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 6. Lines with Shape Markers ⭐
struct LineWithMarkersChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Left line with CIRCLE markers
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
                context.stroke(leftPath, with: .color(.leftSide), lineWidth: 2)
                
                // Draw circle markers for left
                for (index, value) in leftValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                        with: .color(.leftSide)
                    )
                }
                
                // Right line with SQUARE markers
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
                context.stroke(rightPath, with: .color(.rightSide), lineWidth: 2)
                
                // Draw square markers for right
                for (index, value) in rightValues.enumerated() {
                    let x = CGFloat(index) * xStep
                    let normalizedValue = (value - minValue) / valueRange
                    let y = size.height - (CGFloat(normalizedValue) * size.height)
                    
                    context.fill(
                        Path(rect: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                        with: .color(.rightSide)
                    )
                }
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - 7. Gradient Lines
struct GradientLinesChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard snapshots.count > 1 else { return }
                
                let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                
                guard let minValue = (leftValues + rightValues).min(),
                      let maxValue = (leftValues + rightValues).max(),
                      maxValue > minValue else { return }
                
                let valueRange = maxValue - minValue
                let xStep = size.width / CGFloat(snapshots.count - 1)
                
                // Draw segments with gradient for left
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
                            Gradient(colors: [Color.leftSide.opacity(0.4), Color.leftSide]),
                            startPoint: CGPoint(x: x1, y: y1),
                            endPoint: CGPoint(x: x2, y: y2)
                        ),
                        lineWidth: 3
                    )
                }
                
                // Draw segments with gradient for right
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
                            Gradient(colors: [Color.rightSide.opacity(0.4), Color.rightSide]),
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
}

// MARK: - 8. Lines with Shadow/Glow
struct ShadowedLinesChart: View {
    let snapshots: [RunSnapshot]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Left line with cyan glow
                Canvas { context, size in
                    guard snapshots.count > 1 else { return }
                    
                    let leftValues = snapshots.map { Double($0.injuryMetrics.leftLeg.hipMobility) }
                    
                    guard let minValue = leftValues.min(),
                          let maxValue = leftValues.max(),
                          maxValue > minValue else { return }
                    
                    let valueRange = maxValue - minValue
                    let xStep = size.width / CGFloat(snapshots.count - 1)
                    
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
                    
                    // Draw glow effect
                    context.stroke(leftPath, with: .color(.leftSide.opacity(0.3)), lineWidth: 8)
                    context.stroke(leftPath, with: .color(.leftSide), lineWidth: 2.5)
                }
                
                // Right line with magenta glow
                Canvas { context, size in
                    guard snapshots.count > 1 else { return }
                    
                    let rightValues = snapshots.map { Double($0.injuryMetrics.rightLeg.hipMobility) }
                    
                    guard let minValue = rightValues.min(),
                          let maxValue = rightValues.max(),
                          maxValue > minValue else { return }
                    
                    let valueRange = maxValue - minValue
                    let xStep = size.width / CGFloat(snapshots.count - 1)
                    
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
                    
                    // Draw glow effect
                    context.stroke(rightPath, with: .color(.rightSide.opacity(0.3)), lineWidth: 8)
                    context.stroke(rightPath, with: .color(.rightSide), lineWidth: 2.5)
                }
            }
        }
        .frame(height: 200)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Helper Components

struct SolidLineShape: View {
    let color: Color
    let width: CGFloat
    var thickness: CGFloat = 2.5
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: thickness)
    }
}

struct DashedLineShape: View {
    let color: Color
    let width: CGFloat
    let pattern: [CGFloat]
    var thickness: CGFloat = 2.5
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: thickness / 2))
                path.addLine(to: CGPoint(x: width, y: thickness / 2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: thickness, dash: pattern))
        }
        .frame(width: width, height: thickness * 2)
    }
}

// MARK: - Preview
#Preview("All Line Styles") {
    NavigationStack {
        LineStylePrototypes(
            snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
        )
    }
}

#Preview("Solid vs Dashed") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        VStack {
            SolidVsDashedChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
            )
            .padding(Spacing.m)
        }
    }
}

#Preview("Line with Markers") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        VStack {
            LineWithMarkersChart(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
            )
            .padding(Spacing.m)
        }
    }
}