//
//  TechModeView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


//
//  TechModeView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Tech Mode View
/// Advanced technical view showing Force Portrait snapshots with filtering
/// Allows users to view different perspectives, phases, and leg selections
struct TechModeView: View {
    // MARK: - State Properties
    @State private var selectedPerspective: PerspectiveType = .side
    @State private var selectedPhase: GaitPhase = .landing
    @State private var selectedLeg: LegSelection = .both
    @State private var snapshots: [TechViewSnapshot] = []
    @State private var currentSnapshotIndex: Int = 0
    
    // MARK: - Computed Properties
    /// Filters snapshots based on current selections
    private var filteredSnapshots: [TechViewSnapshot] {
        snapshots.filter { snapshot in
            snapshot.perspective == selectedPerspective &&
            snapshot.phase == selectedPhase &&
            snapshot.leg == selectedLeg
        }
    }
    
    /// Current snapshot being displayed
    private var currentSnapshot: TechViewSnapshot? {
        guard !filteredSnapshots.isEmpty,
              currentSnapshotIndex < filteredSnapshots.count else {
            return nil
        }
        return filteredSnapshots[currentSnapshotIndex]
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Section Header
            sectionHeader
            
            // Main Force Portrait Display
            forcePortraitDisplay
            
            // Snapshot Navigation
            if filteredSnapshots.count > 1 {
                snapshotNavigation
            }
            
            // Filter Controls
            filterControls
            
            // Info Card
            //infoCard
        }
        .onAppear {
            loadSnapshots()
        }
        .onChange(of: selectedPerspective) { _ in resetSnapshotIndex() }
        .onChange(of: selectedPhase) { _ in resetSnapshotIndex() }
        .onChange(of: selectedLeg) { _ in resetSnapshotIndex() }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Technical View")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("Detailed Force Portrait Analysis")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Snapshot counter
            if !filteredSnapshots.isEmpty {
                Text("\(currentSnapshotIndex + 1) of \(filteredSnapshots.count)")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, Spacing.xxs)
                    .background(Color.cardBorder)
                    .cornerRadius(CornerRadius.small)
            }
        }
    }
    
    // MARK: - Force Portrait Display
    private var forcePortraitDisplay: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(Color.backgroundBlack)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                )
            
            if let snapshot = currentSnapshot {
                // Force Portrait Image (placeholder for now)
                VStack(spacing: Spacing.m) {
                    // Placeholder image - will be replaced with actual API image
                    Image("ForcePortrait")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .font(.system(size: 120))
                        .foregroundColor(.primaryOrange)
                    
                    // Snapshot info
                    VStack(spacing: Spacing.xxs) {
                        Text("Interval \(snapshot.intervalNumber)")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Time: \(formatTimestamp(snapshot.timestamp))")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            } else {
                // No snapshots available
                VStack(spacing: Spacing.s) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundColor(.textTertiary)
                    
                    Text("No snapshots available")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    
                    Text("for this combination")
                        .font(.bodySmall)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Snapshot Navigation
    private var snapshotNavigation: some View {
        HStack(spacing: Spacing.m) {
            // Previous button
            Button(action: previousSnapshot) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(currentSnapshotIndex > 0 ? .primaryOrange : .textTertiary)
                    .frame(width: 44, height: 44)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            }
            .disabled(currentSnapshotIndex == 0)
            
            // Progress dots
            HStack(spacing: Spacing.xxs) {
                ForEach(0..<min(filteredSnapshots.count, 10), id: \.self) { index in
                    Circle()
                        .fill(index == currentSnapshotIndex ? Color.primaryOrange : Color.cardBorder)
                        .frame(width: 8, height: 8)
                }
                
                if filteredSnapshots.count > 10 {
                    Text("...")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Next button
            Button(action: nextSnapshot) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(currentSnapshotIndex < filteredSnapshots.count - 1 ? .primaryOrange : .textTertiary)
                    .frame(width: 44, height: 44)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            }
            .disabled(currentSnapshotIndex >= filteredSnapshots.count - 1)
        }
        .padding(.horizontal, Spacing.m)
    }
    
    // MARK: - Filter Controls
    private var filterControls: some View {
        VStack(spacing: Spacing.m) {
            // Perspective Selector
            FilterSection(
                title: "Perspective",
                icon: "perspective"
            ) {
                HStack(spacing: Spacing.xs) {
                    ForEach(PerspectiveType.allCases) { perspective in
                        TechViewFilterButton(
                            title: perspective.rawValue,
                            icon: perspective.icon,
                            isSelected: selectedPerspective == perspective,
                            action: { selectedPerspective = perspective }
                        )
                    }
                }
            }
            
            // Phase Selector
            FilterSection(
                title: "Gait Phase",
                icon: "figure.run"
            ) {
                VStack(spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        ForEach(Array(GaitPhase.allCases.prefix(2))) { phase in
                            TechViewFilterButton(
                                title: phase.rawValue,
                                icon: phase.icon,
                                isSelected: selectedPhase == phase,
                                action: { selectedPhase = phase }
                            )
                        }
                    }
                    HStack(spacing: Spacing.xs) {
                        ForEach(Array(GaitPhase.allCases.suffix(2))) { phase in
                            TechViewFilterButton(
                                title: phase.rawValue,
                                icon: phase.icon,
                                isSelected: selectedPhase == phase,
                                action: { selectedPhase = phase }
                            )
                        }
                    }
                }
            }
            
            // Leg Selector
            FilterSection(
                title: "Leg Selection",
                icon: "figure.walk"
            ) {
                HStack(spacing: Spacing.xs) {
                    ForEach(LegSelection.allCases) { leg in
                        TechViewFilterButton(
                            title: leg.rawValue,
                            icon: leg.icon,
                            isSelected: selectedLeg == leg,
                            action: { selectedLeg = leg }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Info Card
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.infoBlue)
                
                Text("Current Selection")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                InfoRow(label: "Perspective", value: selectedPerspective.rawValue)
                InfoRow(label: "Phase", value: selectedPhase.rawValue)
                InfoRow(label: "Leg", value: selectedLeg.rawValue)
                
                if let snapshot = currentSnapshot {
                    InfoRow(label: "Interval", value: "#\(snapshot.intervalNumber)")
                    InfoRow(label: "Timestamp", value: formatTimestamp(snapshot.timestamp))
                }
            }
            
            Text(selectedPhase.description)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .padding(.top, Spacing.xs)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.infoBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Functions
    private func loadSnapshots() {
        // In a real app, this would load from API based on the run
        // For now, generate sample snapshots for 6 intervals
        snapshots = TechViewSnapshot.generateSampleSnapshots(intervalCount: 6)
    }
    
    private func resetSnapshotIndex() {
        currentSnapshotIndex = 0
    }
    
    private func previousSnapshot() {
        if currentSnapshotIndex > 0 {
            currentSnapshotIndex -= 1
        }
    }
    
    private func nextSnapshot() {
        if currentSnapshotIndex < filteredSnapshots.count - 1 {
            currentSnapshotIndex += 1
        }
    }
    
    private func formatTimestamp(_ timestamp: TimeInterval) -> String {
        let minutes = Int(timestamp) / 60
        let seconds = Int(timestamp) % 60
        let milliseconds = Int((timestamp.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

// MARK: - Filter Section Component
/// Reusable section container for filter controls
struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
                    .font(.bodySmall)
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
            }
            
            content
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Filter Button Component
/// Individual button for selecting filter options
struct TechViewFilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xxs) {
                Image(systemName: icon)
                    .font(.bodyMedium)
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .backgroundBlack : .textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(
                isSelected ? Color.primaryOrange : Color.backgroundBlack
            )
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Info Row Component
/// Simple row for displaying label-value pairs
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            TechModeView()
                .padding()
        }
    }
}
