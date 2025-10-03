//
//  LibraryViewModel.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Library/LibraryViewModel.swift (NEW FILE)

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var runs: [Run] = []
    @Published var searchText: String = ""
    @Published var filter: RunFilter = RunFilter()
    @Published var sortOption: RunSort = .dateNewest
    @Published var viewMode: LibraryViewMode = .list
    
    var filteredAndSortedRuns: [Run] {
        var result = runs
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter { run in
                let searchLower = searchText.lowercased()
                return run.mode.rawValue.lowercased().contains(searchLower) ||
                       run.terrain.rawValue.lowercased().contains(searchLower)
            }
        }
        
        // Apply filters
        result = result.filter { filter.matches($0) }
        
        // Apply sort
        result = sortOption.sort(result)
        
        return result
    }
    
    var groupedByMonth: [(month: String, runs: [Run])] {
        let grouped = Dictionary(grouping: filteredAndSortedRuns) { run in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: run.date)
        }
        
        return grouped.sorted { first, second in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let date1 = formatter.date(from: first.key) ?? Date()
            let date2 = formatter.date(from: second.key) ?? Date()
            return date1 > date2
        }.map { (month: $0.key, runs: $0.value) }
    }
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        runs = SampleData.generateRuns(count: 60)
    }
    
    func toggleLike(for run: Run) {
        if let index = runs.firstIndex(where: { $0.id == run.id }) {
            runs[index].isLiked.toggle()
        }
    }
    
    func deleteRun(_ run: Run) {
        runs.removeAll { $0.id == run.id }
    }
}

// MARK: - View Mode
enum LibraryViewMode: String, CaseIterable {
    case list = "List"
    case calendar = "Calendar"
    
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .calendar: return "calendar"
        }
    }
}
