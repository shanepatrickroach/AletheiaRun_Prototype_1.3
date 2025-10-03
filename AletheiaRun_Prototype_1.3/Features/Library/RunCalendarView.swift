//
//  RunCalendarView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//

// Features/Library/RunCalendarView.swift (NEW FILE)

import SwiftUI

struct RunCalendarView: View {
    let runs: [Run]
    let onRunTap: (Run) -> Void

    @State private var selectedDate: Date?
    @State private var currentMonth: Date = Date()

    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    private var runsForSelectedDate: [Run] {
        guard let selectedDate = selectedDate else { return [] }
        return runs.filter {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.l) {
                // Month Header
                HStack {
                    Button(action: { previousMonth() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primaryOrange)
                    }

                    Spacer()

                    Text(monthYearString(from: currentMonth))
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Button(action: { nextMonth() }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.m)

                // Calendar Grid
                VStack(spacing: Spacing.s) {
                    // Days of week header
                    HStack(spacing: 0) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.textSecondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, Spacing.l)

                    // Calendar days
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 4),
                            count: 7), spacing: 4
                    ) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                CalendarDayCell(
                                    date: date,
                                    runs: runsOnDate(date),
                                    isSelected: selectedDate != nil
                                        && calendar.isDate(
                                            date, inSameDayAs: selectedDate!),
                                    isToday: calendar.isDateInToday(date)
                                )
                                .onTapGesture {
                                    selectedDate = date
                                }
                            } else {
                                Color.clear
                                    .frame(height: 60)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.large)
                .padding(.horizontal, Spacing.l)

                // Selected Date Runs
                if let selectedDate = selectedDate {
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        HStack {
                            Text(selectedDateString(from: selectedDate))
                                .font(.headline)
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Text(
                                "\(runsForSelectedDate.count) run\(runsForSelectedDate.count == 1 ? "" : "s")"
                            )
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        }

                        if runsForSelectedDate.isEmpty {
                            VStack(spacing: Spacing.s) {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 40))
                                    .foregroundColor(.textTertiary)

                                Text("No runs on this day")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.xl)
                        } else {
                            ForEach(runsForSelectedDate) { run in
                                RunListCard(run: run) {
                                    // Like toggle would go here
                                }
                                .onTapGesture {
                                    onRunTap(run)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                }
            }
            .padding(.bottom, Spacing.xxxl)
        }
    }

    // MARK: - Calendar Helpers

    private var daysInMonth: [Date?] {
        guard
            let monthInterval = calendar.dateInterval(
                of: .month, for: currentMonth),
            let monthFirstWeek = calendar.dateInterval(
                of: .weekOfMonth, for: monthInterval.start)
        else {
            return []
        }

        let days = calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )

        // Add padding days at start
        let firstWeekday = calendar.component(
            .weekday, from: monthInterval.start)
        let paddingDays = Array(
            repeating: nil as Date?, count: firstWeekday - 1)

        return paddingDays + days
    }

    private func runsOnDate(_ date: Date) -> [Run] {
        runs.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func previousMonth() {
        if let newMonth = calendar.date(
            byAdding: .month, value: -1, to: currentMonth)
        {
            withAnimation {
                currentMonth = newMonth
            }
        }
    }

    private func nextMonth() {
        if let newMonth = calendar.date(
            byAdding: .month, value: 1, to: currentMonth)
        {
            withAnimation {
                currentMonth = newMonth
            }
        }
    }

    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func selectedDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let runs: [Run]
    let isSelected: Bool
    let isToday: Bool

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private var hasRuns: Bool {
        !runs.isEmpty
    }

    private var runCount: Int {
        runs.count
    }

    var body: some View {
        VStack(spacing: 4) {
            // Day number
            Text(dayNumber)
                .font(.bodyMedium)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(
                    isSelected
                        ? .backgroundBlack
                        : isToday ? .primaryOrange : .textPrimary)

            // Run indicator
            if hasRuns {
                HStack(spacing: 2) {
                    ForEach(0..<min(runCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(
                                isSelected
                                    ? Color.backgroundBlack
                                    : Color.primaryOrange
                            )
                            .frame(width: 4, height: 4)
                    }
                }
            } else {
                Spacer()
                    .frame(height: 4)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(
                    isSelected
                        ? Color.primaryOrange
                        : (isToday
                            ? Color.primaryOrange.opacity(0.1) : Color.clear))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(
                    isToday && !isSelected ? Color.primaryOrange : Color.clear,
                    lineWidth: 1)
        )
    }
}

// MARK: - Calendar Extension
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

#Preview {
    RunCalendarView(
        runs: SampleData.generateRuns(count: 60),
        onRunTap: { _ in }
    )
    .background(Color.backgroundBlack)
}
