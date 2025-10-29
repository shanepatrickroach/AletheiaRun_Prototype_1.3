//
//  RunnerDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


//
//  RunnerDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Runner Detail View
/// Detailed view of a specific runner showing their profile, stats, and runs
struct RunnerDetailView: View {
    let runner: Runner
    let runs: [Run]
    @ObservedObject var viewModel: CoachModeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditRunner = false
    @State private var showingDeleteAlert = false
    @State private var selectedTab: RunnerTab = .overview
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Header
                navigationHeader
                
                // Profile Header
                profileHeader
                
                // Tab Selector
                tabSelector
                
                // Content
                ScrollView {
                    VStack(spacing: Spacing.m) {
                        switch selectedTab {
                        case .overview:
                            OverviewTab(runner: runner, runs: runs)
                        case .runs:
                            RunsTab(runs: runs)
                        case .notes:
                            NotesTab(runner: runner, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.top, Spacing.m)
                    .padding(.bottom, Spacing.xxl)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditRunner) {
            EditRunnerView(runner: runner, viewModel: viewModel)
        }
        .alert("Delete Runner", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteRunner(runner)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to remove \(runner.fullName)? This action cannot be undone.")
        }
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "chevron.left")
                    Text("Athletes")
                }
                .foregroundColor(.primaryOrange)
            }
            
            Spacer()
            
            HStack(spacing: Spacing.m) {
                // Edit Button
                Button(action: { showingEditRunner = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.primaryOrange)
                }
                
                // Delete Button
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.errorRed)
                }
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: Spacing.m) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.primaryOrange.opacity(0.3),
                                Color.primaryOrange.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(runner.initials)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.primaryOrange)
            }
            .frame(width: 100, height: 100)
            
            // Name and Email
            VStack(spacing: Spacing.xxs) {
                Text(runner.fullName)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text(runner.email)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
            
            // Quick Stats
            HStack(spacing: Spacing.xl) {
                QuickStat(
                    icon: "figure.run",
                    value: "\(runner.totalRuns)",
                    label: "Runs"
                )
                
                QuickStat(
                    icon: "ruler",
                    value: runner.formattedTotalDistance,
                    label: "Distance"
                )
                
                QuickStat(
                    icon: "flame.fill",
                    value: "\(runner.currentStreak)",
                    label: "Streak"
                )
                
            }
            .padding(.top, Spacing.s)
        }
        .padding(.vertical, Spacing.m)
        .padding(.horizontal, Spacing.m)
        
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(RunnerTab.allCases) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: Spacing.xs) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: tab.icon)
                            Text(tab.title)
                        }
                        .font(.bodyMedium)
                        .foregroundColor(selectedTab == tab ? .primaryOrange : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                        
                        // Active indicator
                        Rectangle()
                            .fill(selectedTab == tab ? Color.primaryOrange : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .background(Color.cardBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.cardBorder),
            alignment: .bottom
        )
    }
}

// MARK: - Runner Tab Enum
enum RunnerTab: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case runs = "Runs"
    case notes = "Notes"
    
    var id: String { rawValue }
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .overview: return "chart.bar.fill"
        case .runs: return "figure.run"
        case .notes: return "note.text"
        }
    }
}

// MARK: - Quick Stat Component
struct QuickStat: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.bodyMedium)
                .frame(width:30, height: 30)
                .foregroundColor(.primaryOrange)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RunnerDetailView(
            runner: Runner.sampleRunners[0],
            runs: SampleData.generateRuns(count: 20),
            viewModel: CoachModeViewModel()
        )
    }
}
