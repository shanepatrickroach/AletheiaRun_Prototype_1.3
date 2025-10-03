//
//  CalendarModels.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//

import Foundation

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let runs: [Run]
    
    var hasRuns: Bool {
        !runs.isEmpty
    }
    
    var totalDistance: Double {
        runs.reduce(0) { $0 + $1.distance }
    }
    
    var totalDuration: TimeInterval {
        runs.reduce(0) { $0 + $1.duration }
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}

class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Date = Date()
    @Published var runs: [Run] = []
    
    init() {
        // Load sample data on initialization
        loadSampleData()
    }
    
    var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var daysInMonth: [CalendarDay] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.end) else {
            return []
        }
        
        var days: [CalendarDay] = []
        var currentDate = monthFirstWeek.start
        
        while currentDate < monthLastWeek.end {
            let dayRuns = runs.filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
            days.append(CalendarDay(date: currentDate, runs: dayRuns))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    func runsForSelectedDate() -> [Run] {
        runs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    func loadSampleData() {
        runs = SampleData.runs
    }
    
    func addRun(_ run: Run) {
        runs.append(run)
        runs.sort { $0.date > $1.date }
    }
}
