//
//  CoachModeView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Coach Mode View
/// Main view for coaches to manage and view their athletes
struct CoachModeView: View {
    @StateObject private var viewModel = CoachModeViewModel()
    @State private var showingAddRunner = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    coachModeHeader
                    
                    // Search and Sort Bar
                    //searchAndSortBar
                    
                    // Runners List
                    if viewModel.filteredRunners.isEmpty {
                        emptyStateView
                    } else {
                        runnersList
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddRunner) {
                AddRunnerView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Header
    private var coachModeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Coach Mode")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Text("\(viewModel.runners.count) Athletes")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Add Runner Button
            Button(action: { showingAddRunner = true }) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .font(.bodyMedium)
                .foregroundColor(.primaryOrange)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.s)
                .background(Color.primaryOrange.opacity(0.15))
                .cornerRadius(CornerRadius.large)
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
    }
    
    // MARK: - Search and Sort Bar
    private var searchAndSortBar: some View {
        HStack(spacing: Spacing.m) {
            // Search Field
            HStack(spacing: Spacing.s) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textTertiary)
                
                TextField("Search athletes...", text: $viewModel.searchText)
                    .foregroundColor(.textPrimary)
                    .autocapitalization(.none)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
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
            
            // Sort Menu
            Menu {
                ForEach(CoachModeSortOption.allCases) { option in
                    Button(action: { viewModel.sortOption = option }) {
                        Label(option.rawValue, systemImage: option.icon)
                    }
                }
            } label: {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "arrow.up.arrow.down")
                    Image(systemName: "chevron.down")
                }
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .padding(Spacing.s)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.small)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.bottom, Spacing.m)
    }
    
    // MARK: - Runners List
    private var runnersList: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.m) {
                ForEach(viewModel.filteredRunners) { runner in
                    NavigationLink(destination: FloatingButtonExityCoachModeView()) {
                        RunnerCard(runner: runner)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.bottom, Spacing.xxl)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "person.3.fill")
                .font(.system(size: 80))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: Spacing.s) {
                Text(viewModel.searchText.isEmpty ? "No Athletes Yet" : "No Results")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text(viewModel.searchText.isEmpty ?
                     "Add your first athlete to get started" :
                     "Try a different search term")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if viewModel.searchText.isEmpty {
                Button(action: { showingAddRunner = true }) {
                    HStack(spacing: Spacing.s) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Athlete")
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.backgroundBlack)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.m)
                    .background(Color.primaryOrange)
                    .cornerRadius(CornerRadius.large)
                }
                .padding(.top, Spacing.m)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Runner Card
struct RunnerCard: View {
    let runner: Runner
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Profile Avatar
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                
                Text(runner.initials)
                    .font(.headline)
                    .foregroundColor(.primaryOrange)
            }
            .frame(width: 60, height: 60)
            
            // Runner Info
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(runner.fullName)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(runner.email)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                // Stats Row
                HStack(spacing: Spacing.m) {
                    
                    
                    StatBadge(
                        icon: "flame.fill",
                        value: "\(runner.currentStreak)",
                        color: .primaryOrange
                    )
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.bodySmall)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    private func efficiencyColor(_ efficiency: Int) -> Color {
        if efficiency >= 80 {
            return .successGreen
        } else if efficiency >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(color)
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Preview
#Preview {
    CoachModeView()
}
