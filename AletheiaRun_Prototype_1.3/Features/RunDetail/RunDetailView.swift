import SwiftUI

// MARK: - Run Detail View
/// Main container for displaying detailed information about a specific run
/// Shows intervals, metrics, diagnostics, and additional features
struct RunDetailView: View {
    // MARK: - Properties
    let run: Run
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailTab = .intervals
    @State private var intervals: [RunInterval] = []
    
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
                        runSummaryCard
                        
                        // Tab Content
                        switch selectedTab {
                        case .intervals:
                            IntervalsContentView(intervals: intervals)
                        case .tech:
                            TechModeView()
                        case .metrics:
                            MetricsOverTimeView()
                        case .coach:
                            PocketCoachView()
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
            // Load intervals when view appears
            loadIntervals()
        }
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            // Back button
            Button(action: { dismiss() }) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "chevron.left")
                    Text("Library")
                }
                .foregroundColor(.primaryOrange)
            }
            
            Spacer()
            
            // Share button (placeholder)
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
            // Date and Mode
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(run.date.formatted(date: .long, time: .shortened))
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: run.mode.icon)
                        Text(run.mode.rawValue)
                    }
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Overall Score
                VStack(spacing: Spacing.xxs) {
                    Text("\(run.metrics.overallScore)")
                        .font(.titleLarge)
                        .foregroundColor(scoreColor(run.metrics.overallScore))
                    
                    Text("Overall")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Key Stats
            HStack(spacing: Spacing.xl) {
                StatItem(
                    icon: "figure.run",
                    value: String(format: "%.2f", run.distance),
                    label: "Miles"
                )
                
                StatItem(
                    icon: "timer",
                    value: formatDuration(run.duration),
                    label: "Duration"
                )
                
                StatItem(
                    icon: "speedometer",
                    value: formatPace(run.distance, run.duration),
                    label: "Pace"
                )
                
                StatItem(
                    icon: run.terrain.icon,
                    value: run.terrain.rawValue,
                    label: "Terrain"
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
    private func loadIntervals() {
        // In a real app, this would load from the database
        intervals = RunInterval.generateSampleIntervals(count: Int(run.distance * 2))
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
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
    
    private func formatPace(_ distance: Double, _ duration: TimeInterval) -> String {
        guard distance > 0 else { return "0:00" }
        let pace = (duration / 60) / distance
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Detail Tab Enum
/// Defines the different tabs available in the run detail view
enum DetailTab: String, CaseIterable, Identifiable {
    case intervals = "Intervals"
    case tech = "Tech View"
    case metrics = "Metrics"
    case coach = "Coach"
    case notes = "Notes"
    case map = "Map"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .intervals: return "chart.bar.fill"
        case .tech: return "cpu"
        case .metrics: return "chart.line.uptrend.xyaxis"
        case .coach: return "person.fill.checkmark"
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
            .background(isSelected ? Color.primaryOrange.opacity(0.15) : Color.clear)
            .cornerRadius(CornerRadius.small)
        }
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.bodyMedium)
                .foregroundColor(.primaryOrange)
            
            Text(value)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Intervals Content View
/// Shows all intervals with their Force Portraits and metrics
struct IntervalsContentView: View {
    let intervals: [RunInterval]
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Section Header
            HStack {
                Text("Run Intervals")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(intervals.count) intervals")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            // Intervals List
            ForEach(intervals) { interval in
                IntervalCard(interval: interval)
            }
        }
    }
}

// MARK: - Interval Card Component
struct IntervalCard: View {
    let interval: RunInterval
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - Always Visible
            Button(action: { withAnimation { isExpanded.toggle() }}) {
                HStack(spacing: Spacing.m) {
                    // Interval Number Badge
                    Text("\(interval.intervalNumber)")
                        .font(.headline)
                        .foregroundColor(.backgroundBlack)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.small)
                    
                    // Force Portrait Thumbnail
                    ForcePortraitThumbnail(score: interval.performanceMetrics.overallScore)
                        .frame(width: 60, height: 50)
                    
                    // Quick Stats
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(interval.formattedDistance)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("\(interval.formattedPace) pace")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Overall Score
                    VStack(spacing: 2) {
                        Text("\(interval.performanceMetrics.overallScore)")
                            .font(.headline)
                            .foregroundColor(scoreColor(interval.performanceMetrics.overallScore))
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
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
                    
                    // Performance Metrics
                    PerformanceMetricsSection(metrics: interval.performanceMetrics)
                    
                    Divider()
                        .background(Color.cardBorder)
                    
                    // Injury Diagnostics
                    InjuryDiagnosticsSection(metrics: interval.injuryMetrics)
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
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// MARK: - Performance Metrics Section
struct PerformanceMetricsSection: View {
    let metrics: PerformanceMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Performance Metrics")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            ForEach(metrics.allMetrics, id: \.name) { metric in
                MetricRow(
                    name: metric.name,
                    value: metric.value,
                    description: metric.description
                )
            }
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
                    Text(metrics.riskLevel.title)
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
                    description: metric.description
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

// MARK: - Metric Row Component
struct MetricRow: View {
    let name: String
    let value: Int
    let description: String
    @State private var showDescription = false
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
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
                
                // Info button
                Button(action: { showDescription.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
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
                        .fill(scoreColor(value))
                        .frame(width: geometry.size.width * CGFloat(value) / 100, height: 4)
                }
            }
            .frame(height: 4)
            
            // Description (if shown)
            if showDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Spacing.xxs)
            }
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
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
            sway: 78,
            endurance: 82,
            warmup: 75,
            impact: 88,
            braking: 80,
            variation: 77
        )
    )
    
    RunDetailView(run: sampleRun)
}