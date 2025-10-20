// Core/Components/GaitCycleDial.swift

import SwiftUI

/// A circular dial showing the gait cycle breakdown with colored segments
struct GaitCycleDial: View {
    let metrics: GaitCycleMetrics
    let size: CGFloat
    let showLabels: Bool
    
    init(
        metrics: GaitCycleMetrics,
        size: CGFloat = 200,
        showLabels: Bool = true
    ) {
        self.metrics = metrics
        self.size = size
        self.showLabels = showLabels
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.cardBorder, lineWidth: 2)
                .frame(width: size, height: size)
            
            // Gait cycle segments
            GaitCycleSegments(metrics: metrics, size: size)
            
            // Center content
            VStack(spacing: 4) {
                Text("Gait Cycle")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Text("\(metrics.cadence)")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Text("SPM")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Gait Cycle Segments
struct GaitCycleSegments: View {
    let metrics: GaitCycleMetrics
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Landing segment (starts at top, goes clockwise)
            SegmentShape(
                startAngle: .degrees(-90),
                endAngle: .degrees(-90 + (metrics.landing / 100 * 360))
            )
            .fill(GaitCyclePhase.landing.color)
            
            // Stabilizing segment
            SegmentShape(
                startAngle: .degrees(-90 + (metrics.landing / 100 * 360)),
                endAngle: .degrees(-90 + ((metrics.landing + metrics.stabilizing) / 100 * 360))
            )
            .fill(GaitCyclePhase.stabilizing.color)
            
            // Launching segment
            SegmentShape(
                startAngle: .degrees(-90 + ((metrics.landing + metrics.stabilizing) / 100 * 360)),
                endAngle: .degrees(-90 + ((metrics.landing + metrics.stabilizing + metrics.launching) / 100 * 360))
            )
            .fill(GaitCyclePhase.launching.color)
            
            // Flying segment
            SegmentShape(
                startAngle: .degrees(-90 + ((metrics.landing + metrics.stabilizing + metrics.launching) / 100 * 360)),
                endAngle: .degrees(-90 + 360)
            )
            .fill(GaitCyclePhase.flying.color)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Segment Shape
struct SegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let lineWidth: CGFloat = 30
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(
            center: center,
            radius: radius - lineWidth / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path.strokedPath(.init(lineWidth: lineWidth, lineCap: .butt))
    }
}

// MARK: - Gait Cycle Legend
/// Shows the four phases with their colors and percentages
struct GaitCycleLegend: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(spacing: Spacing.s) {
            ForEach(GaitCyclePhase.allCases) { phase in
                GaitCycleLegendRow(
                    phase: phase,
                    percentage: percentageForPhase(phase)
                )
            }
        }
    }
    
    private func percentageForPhase(_ phase: GaitCyclePhase) -> Double {
        switch phase {
        case .landing: return metrics.landing
        case .stabilizing: return metrics.stabilizing
        case .launching: return metrics.launching
        case .flying: return metrics.flying
        }
    }
}

// MARK: - Legend Row
struct GaitCycleLegendRow: View {
    let phase: GaitCyclePhase
    let percentage: Double
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Color indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(phase.color)
                .frame(width: 4, height: 20)
            
            // Phase name
            Text(phase.rawValue)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Percentage
            Text(String(format: "%.1f%%", percentage))
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundColor(phase.color)
        }
    }
}

// MARK: - Gait Cycle Timing Card
/// Shows contact time, flight time, and cadence
struct GaitCycleTimingCard: View {
    let metrics: GaitCycleMetrics
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            Text("Timing Metrics")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.m) {
                // Contact Time
                TimingMetricItem(
                    icon: "arrow.down.circle.fill",
                    label: "Contact",
                    value: String(format: "%.0f", metrics.contactTime),
                    unit: "ms",
                    color: .errorRed
                )
                
                // Flight Time
                TimingMetricItem(
                    icon: "airplane.circle.fill",
                    label: "Flight",
                    value: String(format: "%.0f", metrics.flightTime),
                    unit: "ms",
                    color: .infoBlue
                )
                
                // Cadence
                TimingMetricItem(
                    icon: "metronome.fill",
                    label: "Cadence",
                    value: "\(metrics.cadence)",
                    unit: "SPM",
                    color: .primaryOrange
                )
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Timing Metric Item
struct TimingMetricItem: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: Spacing.xl) {
        GaitCycleDial(
            metrics: GaitCycleMetrics(),
            size: 200
        )
        
        GaitCycleLegend(metrics: GaitCycleMetrics())
            .padding(.horizontal)
        
        GaitCycleTimingCard(metrics: GaitCycleMetrics())
            .padding(.horizontal)
    }
    .padding()
    .background(Color.backgroundBlack)
}