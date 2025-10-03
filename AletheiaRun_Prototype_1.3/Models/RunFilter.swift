//
//  RunFilter.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Models/RunFilter.swift (NEW FILE)

import Foundation

struct RunFilter: Equatable {
    var modes: Set<RunMode> = []
    var terrains: Set<TerrainType> = []
    var perspectives: Set<PerspectiveType> = []
    var onlyLiked: Bool = false
    var dateRange: DateRange? = nil
    
    var isActive: Bool {
        !modes.isEmpty || 
        !terrains.isEmpty || 
        !perspectives.isEmpty || 
        onlyLiked ||
        dateRange != nil
    }
    
    var activeFilterCount: Int {
        var count = 0
        if !modes.isEmpty { count += modes.count }
        if !terrains.isEmpty { count += terrains.count }
        if !perspectives.isEmpty { count += perspectives.count }
        if onlyLiked { count += 1 }
        if dateRange != nil { count += 1 }
        return count
    }
    
    func matches(_ run: Run) -> Bool {
        // Mode filter
        if !modes.isEmpty && !modes.contains(run.mode) {
            return false
        }
        
        // Terrain filter
        if !terrains.isEmpty && !terrains.contains(run.terrain) {
            return false
        }
        
        // Perspectives filter (run must have ALL selected perspectives)
        if !perspectives.isEmpty {
            if !perspectives.isSubset(of: run.perspectives) {
                return false
            }
        }
        
        // Liked filter
        if onlyLiked && !run.isLiked {
            return false
        }
        
        // Date range filter
        if let dateRange = dateRange {
            if run.date < dateRange.start || run.date > dateRange.end {
                return false
            }
        }
        
        return true
    }
    
    mutating func reset() {
        modes.removeAll()
        terrains.removeAll()
        perspectives.removeAll()
        onlyLiked = false
        dateRange = nil
    }
}

// MARK: - Date Range
struct DateRange: Equatable {
    let start: Date
    let end: Date
    
    static var thisWeek: DateRange {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        return DateRange(start: weekStart, end: weekEnd)
    }
    
    static var thisMonth: DateRange {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        return DateRange(start: monthStart, end: monthEnd)
    }
    
    static var lastMonth: DateRange {
        let calendar = Calendar.current
        let now = Date()
        let lastMonthStart = calendar.date(byAdding: .month, value: -1, to: calendar.date(from: calendar.dateComponents([.year, .month], from: now))!)!
        let lastMonthEnd = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        return DateRange(start: lastMonthStart, end: lastMonthEnd)
    }
}