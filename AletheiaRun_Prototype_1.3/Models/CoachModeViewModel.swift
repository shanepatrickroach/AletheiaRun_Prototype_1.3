//
//  CoachModeViewModel.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


//
//  CoachModeViewModel.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import Foundation
import Combine

// MARK: - Coach Mode View Model
/// Manages the state for coach mode, including runners and their data
class CoachModeViewModel: ObservableObject {
    @Published var runners: [Runner] = []
    @Published var selectedRunner: Runner?
    @Published var searchText: String = ""
    @Published var sortOption: CoachModeSortOption = .dateAdded
    @Published var isAddingRunner: Bool = false
    
    // Run data for each runner (in real app, this would come from API/database)
    private var runnerRunsMap: [UUID: [Run]] = [:]
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Computed Properties
    var filteredRunners: [Runner] {
        var filtered = runners
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { runner in
                runner.fullName.localizedCaseInsensitiveContains(searchText) ||
                runner.email.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting
        switch sortOption {
        case .dateAdded:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .name:
            filtered.sort { $0.fullName < $1.fullName }
        case .totalRuns:
            filtered.sort { $0.totalRuns > $1.totalRuns }
        case .efficiency:
            filtered.sort { $0.averageEfficiency > $1.averageEfficiency }
        }
        
        return filtered
    }
    
    // MARK: - Methods
    func getRuns(for runner: Runner) -> [Run] {
        return runnerRunsMap[runner.id] ?? []
    }
    
    func getRunnerWithRuns(_ runner: Runner) -> RunnerWithRuns {
        let runs = getRuns(for: runner)
        return RunnerWithRuns(runner: runner, runs: runs)
    }
    
    func addRunner(_ runner: Runner) {
        runners.append(runner)
        // Generate sample runs for new runner
        runnerRunsMap[runner.id] = SampleData.generateRuns(count: Int.random(in: 10...30))
    }
    
    func updateRunner(_ runner: Runner) {
        if let index = runners.firstIndex(where: { $0.id == runner.id }) {
            runners[index] = runner
        }
    }
    
    func deleteRunner(_ runner: Runner) {
        runners.removeAll { $0.id == runner.id }
        runnerRunsMap.removeValue(forKey: runner.id)
        if selectedRunner?.id == runner.id {
            selectedRunner = nil
        }
    }
    
    func selectRunner(_ runner: Runner) {
        selectedRunner = runner
    }
    
    // MARK: - Sample Data
    private func loadSampleData() {
        runners = Runner.sampleRunners
        
        // Generate sample runs for each runner
        for runner in runners {
            runnerRunsMap[runner.id] = SampleData.generateRuns(
                count: runner.totalRuns
            )
        }
    }
}

// MARK: - Sort Options
enum CoachModeSortOption: String, CaseIterable, Identifiable {
    case dateAdded = "Date Added"
    case name = "Name"
    case totalRuns = "Total Runs"
    case efficiency = "Efficiency"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dateAdded: return "calendar"
        case .name: return "textformat.abc"
        case .totalRuns: return "figure.run"
        case .efficiency: return "chart.line.uptrend.xyaxis"
        }
    }
}
