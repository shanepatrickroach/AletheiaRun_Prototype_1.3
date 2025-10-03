// Features/Library/LibraryView.swift (COMPLETE REBUILD)

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var selectedRun: Run?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal, Spacing.l)
                        .padding(.vertical, Spacing.m)
                    
                    // View Mode Toggle & Stats
                    HStack {
                        // View Mode Picker
                        Picker("View Mode", selection: $viewModel.viewMode) {
                            ForEach(LibraryViewMode.allCases, id: \.self) { mode in
                                Label(mode.rawValue, systemImage: mode.icon)
                                    .tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                        
                        Spacer()
                        
                        // Results count
                        Text("\(viewModel.filteredAndSortedRuns.count) runs")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.bottom, Spacing.m)
                    
                    // Filter & Sort Bar
                    HStack(spacing: Spacing.m) {
                        // Filter Button
                        Button(action: {
                            showingFilters = true
                        }) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "line.3.horizontal.decrease.circle\(viewModel.filter.isActive ? ".fill" : "")")
                                    .foregroundColor(viewModel.filter.isActive ? .primaryOrange : .textSecondary)
                                
                                Text("Filter")
                                    .font(.bodySmall)
                                    .foregroundColor(viewModel.filter.isActive ? .primaryOrange : .textPrimary)
                                
                                if viewModel.filter.isActive {
                                    Text("(\(viewModel.filter.activeFilterCount))")
                                        .font(.caption)
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.s)
                            .background(
                                viewModel.filter.isActive
                                    ? Color.primaryOrange.opacity(0.1)
                                    : Color.cardBackground
                            )
                            .cornerRadius(CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .stroke(
                                        viewModel.filter.isActive
                                            ? Color.primaryOrange
                                            : Color.cardBorder,
                                        lineWidth: 1
                                    )
                            )
                        }
                        
                        // Sort Button
                        Button(action: {
                            showingSortOptions = true
                        }) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: viewModel.sortOption.icon)
                                    .foregroundColor(.textSecondary)
                                
                                Text(viewModel.sortOption.rawValue)
                                    .font(.bodySmall)
                                    .foregroundColor(.textPrimary)
                                    .lineLimit(1)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundColor(.textTertiary)
                            }
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.s)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.bottom, Spacing.m)
                    
                    // Content
                    if viewModel.filteredAndSortedRuns.isEmpty {
                        EmptyLibraryView(hasFilters: viewModel.filter.isActive)
                    } else {
                        switch viewModel.viewMode {
                        case .list:
                            RunListView(
                                runs: viewModel.filteredAndSortedRuns,
                                onLikeTap: { run in
                                    viewModel.toggleLike(for: run)
                                },
                                onRunTap: { run in
                                    selectedRun = run
                                }
                            )
                        case .calendar:
                            RunCalendarView(
                                runs: viewModel.filteredAndSortedRuns,
                                onRunTap: { run in
                                    selectedRun = run
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingFilters) {
            FilterSheet(filter: $viewModel.filter)
        }
        .sheet(isPresented: $showingSortOptions) {
            SortSheet(sortOption: $viewModel.sortOption)
        }
        .sheet(item: $selectedRun) { run in
            RunDetailView(run: run)
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
            
            TextField("Search runs...", text: $text)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Empty Library View
struct EmptyLibraryView: View {
    let hasFilters: Bool
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: hasFilters ? "line.3.horizontal.decrease.circle" : "figure.run")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text(hasFilters ? "No Matching Runs" : "No Runs Yet")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(hasFilters
                ? "Try adjusting your filters"
                : "Record your first run to see it here"
            )
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LibraryView()
}
