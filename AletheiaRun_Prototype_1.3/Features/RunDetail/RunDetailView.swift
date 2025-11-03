// Features/RunDetail/RunDetailView.swift

import SwiftUI

// MARK: - Run Detail View
struct RunDetailView: View {
    // MARK: - Properties
    let run: Run
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailTab = .overview
    @State private var snapshots: [RunSnapshot] = []
    @State private var isSummaryExpanded: Bool = false

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Navigation Header
                navigationHeader

                // Tab Selector
                tabSelector

                // Content based on selected tab
                ScrollView {
                    VStack(spacing: Spacing.m) {
                        // Run Summary Card at top
                        //                        runSummaryCard

//                        if selectedTab != .tech {
//                            adaptiveSummaryCard
//                        }
                        
                        adaptiveSummaryCard

                        // Tab Content
                        switch selectedTab {
                        case .overview:  // CHANGED from .intervals
                            OverviewContentView(snapshots: snapshots)
                        case .gaitCycle:
                            GaitCycleDetailView(
                                snapshots: snapshots
                            )
                        case .tech:
                            TechModeView(snapshots: snapshots)
                        case .trainingPlan:
                            TrainingPlanLinkView()
                        case .notes:
                            PostRunNotesView(run: run)
                        case .map:
                            RouteMapView()
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.bottom, Spacing.xxl)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadSnapshots()  // CHANGED from loadIntervals
        }
    }

    @ViewBuilder
    private var adaptiveSummaryCard: some View {
        switch selectedTab {
        case .overview:
            // Overview tab shows collapsible performance metrics
            OverviewSummaryCard(
                run: run,
                isExpanded: $isSummaryExpanded
            )

        case .gaitCycle:
            // Gait Cycle tab shows collapsible gait metrics
            GaitCycleSummaryCard(
                run: run,
                isExpanded: $isSummaryExpanded
            )

        case .tech:
            // Tech view hides the summary (we already handle this above)
            TechViewSummaryCard(
                run: run,
                isExpanded: $isSummaryExpanded
            )

        case .notes, .map:
            // Other tabs show the basic summary (non-collapsible)
            EmptyView()
            
        case .trainingPlan:
            TrainingPlanSummaryCard(
                run: run,
                isExpanded: $isSummaryExpanded
            )
        }
        
    
    }

    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "chevron.left")
                    Text("Library")
                }
                .foregroundColor(.primaryOrange)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.primaryOrange)
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
    }

    // MARK: - Tab Selector
    private var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(DetailTab.allCases) { tab in
                    TabButton(
                        title: tab.title,
                        icon: tab.icon,
                        isSelected: selectedTab == tab,
                        action: { selectedTab = tab }
                    )
                }
            }
            .padding(.horizontal, Spacing.m)
        }
        .padding(.vertical, Spacing.s)
        .background(Color.backgroundBlack)
    }

    // MARK: - Run Summary Card
    private var runSummaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(run.date.formatted(date: .long, time: .shortened))
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    HStack(spacing: Spacing.m) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: run.mode.icon)
                            Text(run.mode.rawValue)
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                        HStack(spacing: Spacing.xs) {
                            Image(systemName: run.terrain.icon)
                            Text(run.terrain.rawValue)
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    }

                }

                Spacer()

                VStack(spacing: Spacing.xxs) {
                    Text("\(run.metrics.overallScore)")
                        .font(.titleLarge)
                        .foregroundColor(scoreColor(run.metrics.overallScore))

                    Text("Overall")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cardBorder)
                        .frame(height: 4)

                    // Progress
                    RoundedRectangle(cornerRadius: 2)
                        .fill(scoreColor(run.metrics.overallScore))
                        .frame(
                            width: geometry.size.width
                                * CGFloat(run.metrics.overallScore) / 100,
                            height: 4)
                }
            }
            .frame(height: 4)

            Divider()
                .background(Color.cardBorder)

            // Key Stats
            HStack(spacing: Spacing.xl) {
                RunDetailStatItem(
                    icon: "figure.run",
                    value: String(format: "%.2f", run.distance),
                    label: "Distance",
                    unit: "miles"
                )

                RunDetailStatItem(
                    icon: "timer",
                    value: formatDuration(run.duration),
                    label: "Duration",
                    unit: ""
                )

                RunDetailStatItem(
                    icon: "speedometer",
                    value: formatPace(run.distance, run.duration),
                    label: "Pace",
                    unit: "mi/mile"
                )

            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    // MARK: - Helper Functions
    private func loadSnapshots() {  // CHANGED from loadIntervals
        // In a real app, this would load from the database
        snapshots = RunSnapshot.generateSampleSnapshots(
            count: Int(run.distance * 2))
    }

    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formatPace(_ distance: Double, _ duration: TimeInterval)
        -> String
    {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Detail Tab Enum (UPDATED)
enum DetailTab: String, CaseIterable, Identifiable {
    case overview = "Overview"  // CHANGED from intervals
    case gaitCycle = "Gait Cycle"  // NEW
    case tech = "Tech View"
    case trainingPlan = "Training Plan"
    case notes = "Notes"
    case map = "Map"

    var id: String { rawValue }
    var title: String { rawValue }

    var icon: String {
        switch self {
        case .overview: return "list.clipboard"  // Changed from intervals
        case .gaitCycle: return "circle.dotted.and.circle"  // NEW
        case .tech: return "cpu"
        case .trainingPlan: return "person.fill.checkmark"
        case .notes: return "note.text"
        case .map: return "map.fill"
        }
    }
}

// MARK: - Tab Button Component
struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xxs) {
                Image(systemName: icon)
                    .font(.bodySmall)

                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.xs)
            .background(
                isSelected ? Color.primaryOrange.opacity(0.15) : Color.clear
            )
            .cornerRadius(CornerRadius.small)
        }
    }
}

// MARK: - Stat Item Component
struct RunDetailStatItem: View {
    let icon: String
    let value: String
    let label: String
    let unit: String?

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.bodyMedium)
                .foregroundColor(.primaryOrange)
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(unit ?? "")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)

    }
}

// MARK: - Snapshots Content View (UPDATED)
struct OverviewContentView: View {
    let snapshots: [RunSnapshot]

    var body: some View {
        VStack(spacing: Spacing.m) {
            // Section Header
            HStack {
                Text("Run Snapshots")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(snapshots.count) snapshots")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            // Snapshots List (UPDATED)
            ForEach(snapshots) { snapshot in
                SnapshotCard(
                    snapshot: snapshot,
                    allSnapshots: snapshots  // Pass all snapshots
                )
            }
        }
    }
}

// MARK: - Snapshot Card Component (UPDATED)
struct SnapshotCard: View {
    let snapshot: RunSnapshot
    let allSnapshots: [RunSnapshot]  // NEW: Add all snapshots
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            // Header - Always Visible
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(spacing: Spacing.m) {
                    // Snapshot Number Badge
                    Text("\(snapshot.snapshotNumber)")
                        .font(.headline)
                        .foregroundColor(.backgroundBlack)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.small)

                    //                    // Force Portrait Thumbnail
                    //                    ForcePortraitMini(
                    //                        snapshot: snapshot.performanceMetrics.overallScore
                    //                    )
                    //                    .frame(width: 60, height: 50)

                    // Force Portrait Thumbnail
                    ForcePortraitSnapshotThumbnail(
                        score: snapshot.performanceMetrics.overallScore
                    )
                    .frame(width: 90, height: 70)

                    // Quick Stats
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(snapshot.formattedDistance)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)

                        Text("\(snapshot.formattedPace) pace")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    // Overall Score
                    VStack(spacing: 2) {
                        Text("\(snapshot.performanceMetrics.overallScore)")
                            .font(.headline)
                            .foregroundColor(
                                scoreColor(
                                    snapshot.performanceMetrics.overallScore))

                        Image(
                            systemName: isExpanded
                                ? "chevron.up" : "chevron.down"
                        )
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.m)
            }

            // Expanded Content
            if isExpanded {
                VStack(spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)

                    // Performance Metrics (UPDATED with snapshots)
                    PerformanceMetricsSection(
                        metrics: snapshot.performanceMetrics,
                        snapshots: allSnapshots
                    )

                    Divider()
                        .background(Color.cardBorder)

                
                    InjuryDiagnosticsDetailSection(
                        metrics: snapshot.injuryMetrics)

                    Divider()
                        .background(Color.cardBorder)

                }
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, Spacing.m)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

struct ForcePortraitSnapshotThumbnail: View {
    let score: Int

    private var scoreColor: Color {
        if score >= 80 { return .successGreen }
        if score >= 60 { return .warningYellow }
        return .errorRed
    }

    private var gradientColors: [Color] {
        if score >= 80 {
            return [
                Color.successGreen.opacity(0.8),
                Color.successGreen.opacity(0.3),
            ]
        } else if score >= 60 {
            return [
                Color.warningYellow.opacity(0.8),
                Color.warningYellow.opacity(0.3),
            ]
        } else {
            return [Color.errorRed.opacity(0.8), Color.errorRed.opacity(0.3)]
        }
    }

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.backgroundBlack)

            // Gradient overlay based on score
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .opacity(0.3)

            // Force Portrait Icon/Waveform
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(scoreColor)
                .opacity(0.9)
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(
                    LinearGradient(
                        colors: [
                            scoreColor.opacity(0.6), scoreColor.opacity(0.2),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

// MARK: - Performance Metrics Section (UPDATED)
struct PerformanceMetricsSection: View {
    let metrics: PerformanceMetrics
    let snapshots: [RunSnapshot]  // NEW: Add snapshots parameter

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {

            HStack {
                Image(systemName: "medal.star.fill")
                    .foregroundColor(.primaryOrange)

                Text("Performance Metrics")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)

                Spacer()
            }

            MetricRow(
                name: "Efficiency",
                value: metrics.efficiency,
                description: "Energy economy during running",
                metricType: .efficiency,
                snapshots: snapshots
            )

            MetricRow(
                name: "Braking",
                value: metrics.braking,
                description: "Deceleration forces",
                metricType: .braking,
                snapshots: snapshots
            )

            MetricRow(
                name: "Impact",
                value: metrics.impact,
                description: "Ground contact force",
                metricType: .impact,
                snapshots: snapshots
            )

            MetricRow(
                name: "Sway",
                value: metrics.sway,
                description: "Lateral movement and stability",
                metricType: .sway,
                snapshots: snapshots
            )

            MetricRow(
                name: "Variation",
                value: metrics.variation,
                description: "Stride consistency",
                metricType: .variation,
                snapshots: snapshots
            )

            MetricRow(
                name: "Warmup",
                value: metrics.warmup,
                description: "Initial readiness quality",
                metricType: .warmup,
                snapshots: snapshots
            )
            MetricRow(
                name: "Endurance",
                value: metrics.endurance,
                description: "Sustained performance capability",
                metricType: .endurance,
                snapshots: snapshots
            )
        }
    }
}
// MARK: - Injury Diagnostics Section
struct InjuryDiagnosticsSection: View {
    let metrics: InjuryMetrics

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Text("Injury Diagnostics")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)

                Spacer()

                // Risk Level Badge
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: metrics.riskLevel.icon)
                    Text("High Risk")
                        .font(.caption)
                }
                .foregroundColor(riskColor(metrics.riskLevel))
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, 4)
                .background(riskColor(metrics.riskLevel).opacity(0.15))
                .cornerRadius(CornerRadius.small)
            }

            ForEach(metrics.allMetrics, id: \.name) { metric in
                MetricRow(
                    name: metric.name,
                    value: metric.value,
                    description: metric.description,
                    metricType: nil,  // No detail view for injury metrics yet
                    snapshots: []
                )
            }
        }
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .low: return .successGreen
        case .moderate: return .warningYellow
        case .high: return .errorRed
        }
    }
}

// MARK: - Metric Row Component (UPDATED for Sheet)
struct MetricRow: View {
    let name: String
    let value: Int
    let description: String
    let metricType: MetricType?
    let snapshots: [RunSnapshot]
    @State private var showDescription = false
    @State private var showMetricDetail = false  // NEW: Sheet state

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Button(action: {
                if metricType != nil {
                    showMetricDetail = true
                }
            }) {
                HStack {
                    // Metric Name
                    Text(name)
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    // Value
                    Text("\(value)")
                        .font(.bodySmall)
                        .foregroundColor(scoreColor(value))
                        .fontWeight(.medium)

                    // Tap indicator
                    if metricType != nil {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cardBorder)
                        .frame(height: 4)

                    // Progress
                    RoundedRectangle(cornerRadius: 2)
                        .fill(scoreColor(value))
                        .frame(
                            width: geometry.size.width * CGFloat(value) / 100,
                            height: 4)
                }
            }
            .frame(height: 4)

        }
        .sheet(isPresented: $showMetricDetail) {
            if let metricType = metricType {
                MetricDetailView(
                    metricType: metricType,
                    snapshots: snapshots,
                    averageValue: value
                )
            }
        }
    }

    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.0,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 85,
            braking: 78,
            impact: 82,
            sway: 75,
            variation: 88,
            warmup: 80,
            endurance: 77
        ),
        gaitCycleMetrics: GaitCycleMetrics()
    )

    RunDetailView(run: sampleRun)
}
