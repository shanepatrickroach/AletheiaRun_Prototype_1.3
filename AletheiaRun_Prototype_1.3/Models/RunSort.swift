//
//  RunSort.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Models/RunSort.swift (NEW FILE)

import Foundation

enum RunSort: String, CaseIterable {
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case distanceLongest = "Distance (Longest)"
    case distanceShortest = "Distance (Shortest)"
    
    
    var icon: String {
        switch self {
        case .dateNewest, .dateOldest:
            return "calendar"
        case .distanceLongest, .distanceShortest:
            return "ruler"
       
        }
    }
    
    func sort(_ runs: [Run]) -> [Run] {
        switch self {
        case .dateNewest:
            return runs.sorted { $0.date > $1.date }
        case .dateOldest:
            return runs.sorted { $0.date < $1.date }
        case .distanceLongest:
            return runs.sorted { $0.distance > $1.distance }
        case .distanceShortest:
            return runs.sorted { $0.distance < $1.distance }
        
        }
    }
    
    private func paceToSeconds(_ pace: String) -> Int {
        let components = pace.split(separator: ":")
        guard components.count == 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]) else {
            return 0
        }
        return minutes * 60 + seconds
    }
}
