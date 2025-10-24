//
//  RunsTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


//
//  RunsTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Runs Tab
/// Shows all runs for a specific runner with filtering options
struct RunsTab: View {
    let runs: [Run]
    
    @State private var searchText = ""
    @State private var filterMode: RunMode?
    @State private var sortOption: RunSortOption = .dateDescending
    
    private var filteredRuns: [Run] {
        var filtered = runs
        
        // Apply mode filter
        if let mode = filterMode {
            filtered = filtered.filter { $0.mode == mode }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter { run in
                "\(run.distance)".contains(searchText) ||
                run.mode.rawValue.localizedCaseInsensitiveContains(searchText) ||
                run.terrain.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sort
        switch sortOption {
        case .dateDescending:
            filtered.sort { $0.date > $1.date }
        case .dateAscending:
            filtered.sort { $0.date < $1.date }
        case .distanceDescending:
            filtered.sort { $0.distance > $1.distance }
        case .efficiencyDescending:
            filtered.sort { $0.metrics.overallScore > $1.metrics.overallScore }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Search Bar
            searchBar
            
            // Filter Chips
            filterChips
            
            // Sort Options
            sortBar
            
            // Runs List
            if filteredRuns.isEmpty {
                emptyState
            } else {
                runsList
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
            
            TextField("Search runs...", text: $searchText)
                .foregroundColor(.textPrimary)
                .autocapitalization(.none)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.small)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                // All filter
                RunsFilterChip(
                    title: "All",
                    isSelected: filterMode == nil,
                    action: { filterMode = nil }
                )
                
                // Mode filters
                ForEach(RunMode.allCases, id: \.self) { mode in
                    RunsFilterChip(
                        title: mode.rawValue,
                        icon: mode.icon,
                        isSelected: filterMode == mode,
                        action: { filterMode = mode }
                    )
                }
            }
        }
    }
    
    // MARK: - Sort Bar
    private var sortBar: some View {
        HStack {
            Text("\(filteredRuns.count) runs")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Menu {
                ForEach(RunSortOption.allCases) { option in
                    Button(action: { sortOption = option }) {
                        Label(option.title, systemImage: option.icon)
                    }
                }
            } label: {
                HStack(spacing: Spacing.xs) {
                    Text(sortOption.title)
                        .font(.bodySmall)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundColor(.textSecondary)
            }
        }
    }
    
    // MARK: - Runs List
    private var runsList: some View {
        VStack(spacing: Spacing.s) {
            ForEach(filteredRuns) { run in
                NavigationLink(destination: RunDetailView(run: run)) {
                    CompactRunCard(run: run)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text("No runs found")
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
            
            Text("Try adjusting your filters")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }
}

// MARK: - Filter Chip
struct RunsFilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.bodySmall)
            }
            .foregroundColor(isSelected ? .backgroundBlack : .textSecondary)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.primaryOrange : Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Run Sort Options
enum RunSortOption: String, CaseIterable, Identifiable {
    case dateDescending = "Newest First"
    case dateAscending = "Oldest First"
    case distanceDescending = "Longest First"
    case efficiencyDescending = "Best Performance"
    
    var id: String { rawValue }
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .dateDescending, .dateAscending: return "calendar"
        case .distanceDescending: return "map"
        case .efficiencyDescending: return "chart.line.uptrend.xyaxis"
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            RunsTab(runs: SampleData.generateRuns(count: 30))
                .padding()
        }
    }
}
