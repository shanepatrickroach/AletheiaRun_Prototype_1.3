import SwiftUI

struct SeperateCalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        ZStack {
            Color.backgroundBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                SeperateCalendarHeader(viewModel: viewModel)
                
                // Calendar grid
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.l) {
                        // Month/Year and navigation
                        HStack {
                            Button(action: {
                                viewModel.previousMonth()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primaryOrange)
                                    .frame(width: 44, height: 44)
                            }
                            
                            Spacer()
                            
                            Text(viewModel.monthString)
                                .font(.titleSmall)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.nextMonth()
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primaryOrange)
                                    .frame(width: 44, height: 44)
                            }
                        }
                        .padding(.horizontal, Spacing.l)
                        .padding(.top, Spacing.m)
                        
                        // Week day headers
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(weekDays, id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Calendar days
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(viewModel.daysInMonth) { day in
                                SeperateCalendarDayCell(
                                    day: day,
                                    isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate),
                                    action: {
                                        viewModel.selectDate(day.date)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Selected date runs
                        SeperateSelectedDateRunsSection(viewModel: viewModel)
                            .padding(.top, Spacing.l)
                    }
                    .padding(.bottom, 140) // Extra padding for FAB and tab bar
                }
            }
        }
    }
}

// MARK: - Calendar Header
struct SeperateCalendarHeader: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Run Calendar")
                    .font(.titleLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("\(viewModel.runs.count) total runs")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.currentMonth = Date()
                viewModel.selectDate(Date())
            }) {
                Text("Today")
                    .font(.bodySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.primaryOrange.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
            }
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
    }
}

// MARK: - Calendar Day Cell
struct SeperateCalendarDayCell: View {
    let day: CalendarDay
    let isSelected: Bool
    let action: () -> Void
    
    var isCurrentMonth: Bool {
        Calendar.current.isDate(day.date, equalTo: Date(), toGranularity: .month)
    }
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: day.date)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(.bodySmall)
                    .fontWeight(day.isToday ? .bold : .regular)
                    .foregroundColor(
                        isSelected ? .black :
                        day.isToday ? .primaryOrange :
                        isCurrentMonth ? .textPrimary : .textTertiary
                    )
                
                // Run indicator dots
                if day.hasRuns {
                    HStack(spacing: 2) {
                        ForEach(0..<min(day.runs.count, 3), id: \.self) { _ in
                            Circle()
                                .fill(isSelected ? Color.black : Color.primaryOrange)
                                .frame(width: 4, height: 4)
                        }
                    }
                } else {
                    Spacer()
                        .frame(height: 4)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.primaryOrange :
                day.isToday ? Color.primaryOrange.opacity(0.1) :
                Color.clear
            )
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(
                        day.isToday && !isSelected ? Color.primaryOrange : Color.clear,
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Selected Date Runs Section
struct SeperateSelectedDateRunsSection: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: viewModel.selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(selectedDateString)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.l)
            
            let runsForDate = viewModel.runsForSelectedDate()
            
            if runsForDate.isEmpty {
                EmptyRunsForDateView()
            } else {
                ForEach(runsForDate) { run in
                    RunSummaryCard(run: run)
                        .padding(.horizontal, Spacing.l)
                }
            }
        }
    }
}

struct EmptyRunsForDateView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)
            
            Text("No runs on this day")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxxl)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .padding(.horizontal, Spacing.l)
    }
}

// MARK: - Run Summary Card
struct RunSummaryCard: View {
    let run: Run
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: run.date)
    }
    
    var durationString: String {
        let hours = Int(run.duration) / 3600
        let minutes = Int(run.duration) / 60 % 60
        let seconds = Int(run.duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            HStack {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: run.mode.icon)
                        .font(.system(size: 14))
                        .foregroundColor(.primaryOrange)
                    
                    Text(run.mode.rawValue)
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryOrange)
                }
                .padding(.horizontal, Spacing.s)
                .padding(.vertical, 4)
                .background(Color.primaryOrange.opacity(0.2))
                .cornerRadius(CornerRadius.small)
                
                Spacer()
                
                Text(timeString)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            // Stats grid
            HStack(spacing: Spacing.m) {
                StatColumn(
                    icon: "ruler",
                    label: "Distance",
                    value: String(format: "%.2f mi", run.distance)
                )
                
                Divider()
                    .frame(height: 40)
                    .background(Color.textTertiary.opacity(0.3))
                
                StatColumn(
                    icon: "clock",
                    label: "Time",
                    value: durationString
                )
                
                Divider()
                    .frame(height: 40)
                    .background(Color.textTertiary.opacity(0.3))
                
                StatColumn(
                    icon: "speedometer",
                    label: "Pace",
                    value: "11"
                )
            }
            
            // Terrain and metrics preview
            HStack(spacing: Spacing.m) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: run.terrain.icon)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    
                    Text(run.terrain.rawValue)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: Spacing.xs) {
                    Text("Efficiency:")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("\(run.metrics.efficiency)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryOrange)
                }
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

struct StatColumn: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
            
            Text(value)
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SeperateCalendarView()
}
