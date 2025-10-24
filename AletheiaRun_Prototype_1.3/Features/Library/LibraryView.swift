import SwiftUI

// MARK: - Library View Model
// This manages the state for our Library screen
class LibraryViewModel: ObservableObject {
    // Published properties trigger UI updates when changed
    @Published var runs: [Run] = []
    @Published var searchText: String = ""
    @Published var selectedMode: RunMode? = nil // nil = "All"
    @Published var sortOption: SortOption = .date
    @Published var viewMode: ViewMode = .list
    @Published var showingSortMenu = false
    @Published var selectedDate: Date? = nil // For calendar view
    
    init() {
        // Generate sample data for testing
        self.runs = SampleRunData.generateSampleRuns(count: 30)
    }
    
    // Filtered and sorted runs based on user selection
    var filteredRuns: [Run] {
        var result = runs
        
        // Filter by mode if selected
        if let mode = selectedMode {
            result = result.filter { $0.mode == mode }
        }
        
        // Filter by search text (searches in mode and terrain)
        if !searchText.isEmpty {
            result = result.filter { run in
                run.mode.rawValue.localizedCaseInsensitiveContains(searchText) ||
                run.terrain.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort by selected option
        switch sortOption {
        case .date:
            result.sort { $0.date > $1.date } // Newest first
        case .distance:
            result.sort { $0.distance > $1.distance } // Longest first
        }
        
        return result
    }
    
    // Get runs for a specific date (for calendar view)
    func runs(for date: Date) -> [Run] {
        filteredRuns.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    // Check if a date has runs
    func hasRuns(on date: Date) -> Bool {
        runs.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

// MARK: - Enums
enum ViewMode: String, CaseIterable {
    case list = "List"
    case calendar = "Calendar"
}

enum SortOption: String, CaseIterable {
    case date = "Date"
    case distance = "Distance"
    
    var icon: String {
        switch self {
        case .date: return "calendar"
        case .distance: return "ruler"
        }
    }
}

// MARK: - Main Library View
struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with segmented control
                    headerSection
                    
                    // Search and filters
                    searchAndFiltersSection
                    
                    // Content based on view mode
                    if viewModel.viewMode == .list {
                        listContentView
                    } else {
                        calendarContentView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Spacing.m) {
            // Title
            HStack {
                Text("Library")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Sort button
                Button(action: { viewModel.showingSortMenu.toggle() }) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: viewModel.sortOption.icon)
                        Text(viewModel.sortOption.rawValue)
                            .font(.bodySmall)
                    }
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.top, Spacing.m)
            
//            // Segmented Control
//            Picker("View Mode", selection: $viewModel.viewMode) {
//                ForEach(ViewMode.allCases, id: \.self) { mode in
//                    
//                    
//                    Text(mode.rawValue).tag(mode)
//                    
//                    
//                }
//            }
//            .pickerStyle(.segmented).tint(.orange)
//            .padding(.horizontal, Spacing.m)
//            .tint(.orange)
            
            HStack(spacing: 8) {
                ForEach(ViewMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                        .font(.headline)
                        .foregroundColor(viewModel.viewMode == mode ? .black : .white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(viewModel.viewMode == mode ? Color.primaryOrange : Color.gray.opacity(0.3))
                        .cornerRadius(50)
                        .onTapGesture {
                            viewModel.viewMode = mode
                        }
                }
            }
            
            

        }
        .padding(.bottom, Spacing.m)
        .background(Color.backgroundBlack)
        .overlay(
            // Sort Menu Overlay
            Group {
                if viewModel.showingSortMenu {
                    sortMenuOverlay
                }
            }
        )
    }
    
    // MARK: - Sort Menu
    private var sortMenuOverlay: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showingSortMenu = false
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Sort by")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, Spacing.m)
                        .padding(.top, Spacing.m)
                        .padding(.bottom, Spacing.s)
                    
                    Divider()
                        .background(Color.cardBorder)
                    
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.sortOption = option
                            viewModel.showingSortMenu = false
                        }) {
                            HStack {
                                Image(systemName: option.icon)
                                    .foregroundColor(.primaryOrange)
                                    .frame(width: 24)
                                
                                Text(option.rawValue)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                if viewModel.sortOption == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.m)
                        }
                        
                        if option != SortOption.allCases.last {
                            Divider()
                                .background(Color.cardBorder)
                                .padding(.leading, Spacing.xxxxl)
                        }
                    }
                }
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.large)
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, Spacing.xxl)
            }
        }
    }
    
    // MARK: - Search and Filters
    private var searchAndFiltersSection: some View {
        VStack(spacing: Spacing.m) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textTertiary)
                
                TextField("Search runs...", text: $viewModel.searchText)
                    .foregroundColor(.textPrimary)
                    .font(.bodyMedium)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.s)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .padding(.horizontal, Spacing.m)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    // "All" chip
                    FilterChip(
                        title: "All",
                        isSelected: viewModel.selectedMode == nil,
                        action: { viewModel.selectedMode = nil }
                    )
                    
                    // Mode chips
                    ForEach(RunMode.allCases, id: \.self) { mode in
                        FilterChip(
                            title: mode.rawValue,
                            icon: mode.icon,
                            isSelected: viewModel.selectedMode == mode,
                            action: { viewModel.selectedMode = mode }
                        )
                    }
                }
                .padding(.horizontal, Spacing.m)
            }
        }
        .padding(.bottom, Spacing.m)
    }
    
    // MARK: - List Content View
    private var listContentView: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.m) {
                if viewModel.filteredRuns.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.filteredRuns) { run in
                        NavigationLink(destination: RunDetailView(run: run)) {
                            RunCard(run: run)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.bottom, Spacing.xxl)
        }
    }
    
    // MARK: - Calendar Content View
    private var calendarContentView: some View {
        ScrollView {
            VStack(spacing: Spacing.m) {
                CalendarGridView(
                    selectedDate: $viewModel.selectedDate,
                    hasRuns: viewModel.hasRuns
                )
                .padding(.horizontal, Spacing.m)
                
                // Show runs for selected date
                if let selectedDate = viewModel.selectedDate {
                    let runsForDate = viewModel.runs(for: selectedDate)
                    
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text(selectedDate.formatted(date: .long, time: .omitted))
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        if runsForDate.isEmpty {
                            Text("No runs on this date")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.xxl)
                        } else {
                            ForEach(runsForDate) { run in
                                RunCard(run: run)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                }
            }
            .padding(.bottom, Spacing.xxl)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 64))
                .foregroundColor(.textTertiary)
                .padding(.top, Spacing.xxxxl)
            
            Text("No runs found")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text("Try adjusting your filters or start a new run")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, Spacing.xxl)
    }
}

// MARK: - Filter Chip Component
struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.bodySmall)
            }
            .foregroundColor(isSelected ? .backgroundBlack : .textPrimary)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.primaryOrange : Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
}

// MARK: - Run Card Component
struct RunCard: View {
    let run: Run
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Force Portrait Thumbnail
            ForcePortraitThumbnail(score: run.metrics.overallScore)
                .frame(width: 90, height: 75)
            
            // Run Info
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text(run.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Efficiency Score
                    Text("\(run.metrics.overallScore)")
                        .font(.headline)
                        .foregroundColor(scoreColor(run.metrics.overallScore))
                }
                
                HStack(spacing: Spacing.m) {
                    // Distance
                    Label(String(format: "%.2f mi", run.distance), systemImage: "figure.run")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    
                    // Duration
                    Label(formatDuration(run.duration), systemImage: "timer")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: Spacing.xs) {
                    // Mode badge
                    BadgeView(text: run.mode.rawValue, color: .primaryOrange)
                    
                    // Terrain badge
                    BadgeView(text: run.terrain.rawValue, color: .infoBlue)
                }
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
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Badge Component
struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(color)
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Force Portrait Thumbnail
struct ForcePortraitThumbnail: View {
    let score: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.black)
            
            // Force Portrait Image
            Image("ForcePortrait")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 60)
                .opacity(0.9)
            
            
//            // Overlay color based on score
//            RoundedRectangle(cornerRadius: CornerRadius.small)
//                .fill(scoreColor.opacity(0.2))
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var scoreColor: Color {
        if score >= 80 { return .successGreen }
        else if score >= 60 { return .warningYellow }
        else { return .errorRed }
    }
}

// MARK: - Calendar Grid View
struct CalendarGridView: View {
    @Binding var selectedDate: Date?
    let hasRuns: (Date) -> Bool
    
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Month Header
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryOrange)
                }
                
                Spacer()
                
                Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primaryOrange)
                }
            }
            .padding(.horizontal, Spacing.m)
            
            // Today button
            Button(action: goToToday) {
                Text("Today")
                    .font(.bodySmall)
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
            }
            
            // Days of week
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Spacing.xs) {
                ForEach(monthDates, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                            isToday: calendar.isDateInToday(date),
                            hasRuns: hasRuns(date),
                            onTap: { selectedDate = date }
                        )
                    } else {
                        Color.clear
                            .frame(height: 50)
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .onAppear {
            // Select today by default
            selectedDate = Date()
        }
    }
    
    private var monthDates: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let days = calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        
        // Add leading empty cells
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let leadingEmptyCells = firstWeekday - 1
        
        var result: [Date?] = Array(repeating: nil, count: leadingEmptyCells)
        result.append(contentsOf: days.map { $0 as Date? })
        
        return result
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    private func goToToday() {
        currentMonth = Date()
        selectedDate = Date()
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasRuns: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.bodySmall)
                    .foregroundColor(textColor)
                
                // Orange dot if has runs
                Circle()
                    .fill(hasRuns ? Color.primaryOrange : Color.clear)
                    .frame(width: 4, height: 4)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 0)
            )
        }
    }
    
    private var textColor: Color {
        if isSelected { return .backgroundBlack }
        return .textPrimary
    }
    
    private var backgroundColor: Color {
        if isSelected { return .primaryOrange }
        return Color.clear
    }
    
    private var borderColor: Color {
        isToday ? .primaryOrange : .clear
    }
}

// MARK: - Calendar Helper Extension
extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

// MARK: - Sample Data
struct SampleRunData {
    static func generateSampleRuns(count: Int) -> [Run] {
        var runs: [Run] = []
        
        for i in 0..<count {
            let daysAgo = i
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            
            let run = Run(
                date: date,
                mode: RunMode.allCases.randomElement() ?? .run,
                terrain: TerrainType.allCases.randomElement() ?? .road,
                distance: Double.random(in: 2.0...10.0),
                duration: TimeInterval.random(in: 1200...3600),
                metrics: RunMetrics(
                    efficiency: Int.random(in: 60...95),
                    braking: Int.random(in: 60...95),
                    impact: Int.random(in: 60...95),
                    sway: Int.random(in: 60...95),
                    variation: Int.random(in: 60...95),
                    warmup: Int.random(in: 60...95),
                    endurance: Int.random(in: 60...95)
                )
            )
            
            runs.append(run)
        }
        
        return runs
    }
}

// MARK: - Preview
#Preview {
    LibraryView()
}
