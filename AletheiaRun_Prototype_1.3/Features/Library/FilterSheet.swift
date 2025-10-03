//
//  FilterSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//

import SwiftUI

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filter: RunFilter
    
    @State private var localFilter: RunFilter
    
    init(filter: Binding<RunFilter>) {
        self._filter = filter
        self._localFilter = State(initialValue: filter.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    filterContent
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    resetButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    applyButton
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var filterContent: some View {
        VStack(spacing: Spacing.xl) {
            runModeSection
            sectionDivider
            terrainSection
            sectionDivider
            perspectiveSection
            sectionDivider
            favoritesSection
            sectionDivider
            dateRangeSection
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.l)
    }
    
    private var runModeSection: some View {
        FilterSection(title: "Run Mode", icon: "figure.run") {
            FlowLayout(spacing: Spacing.s) {
                ForEach(RunMode.allCases, id: \.self) { mode in
                    FilterChip(
                        title: mode.rawValue,
                        icon: mode.icon,
                        isSelected: localFilter.modes.contains(mode),
                        color: Color.primary
                    ) {
                        toggleMode(mode)
                    }
                }
            }
        }
    }
    
    private var terrainSection: some View {
        FilterSection(title: "Terrain", icon: "mountain.2") {
            FlowLayout(spacing: Spacing.s) {
                ForEach(TerrainType.allCases, id: \.self) { terrain in
                    FilterChip(
                        title: terrain.rawValue,
                        icon: terrain.icon,
                        isSelected: localFilter.terrains.contains(terrain),
                        color: Color.primary
                    ) {
                        toggleTerrain(terrain)
                    }
                }
            }
        }
    }
    
    private var perspectiveSection: some View {
        FilterSection(title: "Perspectives", icon: "camera") {
            VStack(spacing: Spacing.s) {
                perspectiveDescription
                perspectiveChips
            }
        }
    }
    
    private var perspectiveDescription: some View {
        Text("Runs must include ALL selected perspectives")
            .font(.caption)
            .foregroundColor(.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var perspectiveChips: some View {
        FlowLayout(spacing: Spacing.s) {
            ForEach(PerspectiveType.allCases, id: \.self) { perspective in
                FilterChip(
                    title: perspective.rawValue,
                    icon: perspective.icon,
                    isSelected: localFilter.perspectives.contains(perspective),
                    color: Color.primary
                ) {
                    togglePerspective(perspective)
                }
            }
        }
    }
    
    private var favoritesSection: some View {
        FilterSection(title: "Favorites", icon: "heart.fill") {
            Toggle(isOn: $localFilter.onlyLiked) {
                HStack(spacing: Spacing.s) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.errorRed)
                    
                    Text("Show only liked runs")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
            }
            .tint(.primaryOrange)
        }
    }
    
    private var dateRangeSection: some View {
        FilterSection(title: "Date Range", icon: "calendar") {
            VStack(spacing: Spacing.s) {
                DateRangeButton(
                    title: "This Week",
                    isSelected: localFilter.dateRange == .thisWeek
                ) {
                    toggleDateRange(.thisWeek)
                }
                
                DateRangeButton(
                    title: "This Month",
                    isSelected: localFilter.dateRange == .thisMonth
                ) {
                    toggleDateRange(.thisMonth)
                }
                
                DateRangeButton(
                    title: "Last Month",
                    isSelected: localFilter.dateRange == .lastMonth
                ) {
                    toggleDateRange(.lastMonth)
                }
            }
        }
    }
    
    private var sectionDivider: some View {
        Divider()
            .background(Color.cardBorder)
    }
    
    private var resetButton: some View {
        Button("Reset") {
            localFilter.reset()
        }
        .foregroundColor(.errorRed)
        .disabled(!localFilter.isActive)
    }
    
    private var applyButton: some View {
        Button("Apply") {
            filter = localFilter
            dismiss()
        }
        .foregroundColor(.primaryOrange)
        .fontWeight(.semibold)
    }
    
    // MARK: - Helper Methods
    
    private func toggleMode(_ mode: RunMode) {
        if localFilter.modes.contains(mode) {
            localFilter.modes.remove(mode)
        } else {
            localFilter.modes.insert(mode)
        }
    }
    
    private func toggleTerrain(_ terrain: TerrainType) {
        if localFilter.terrains.contains(terrain) {
            localFilter.terrains.remove(terrain)
        } else {
            localFilter.terrains.insert(terrain)
        }
    }
    
    private func togglePerspective(_ perspective: PerspectiveType) {
        if localFilter.perspectives.contains(perspective) {
            localFilter.perspectives.remove(perspective)
        } else {
            localFilter.perspectives.insert(perspective)
        }
    }
    
    private func toggleDateRange(_ range: DateRangeFilter) {
        localFilter.dateRange = localFilter.dateRange == range ? nil : range
    }
}

// MARK: - Filter Section
struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            sectionHeader
            content
        }
    }
    
    private var sectionHeader: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            chipContent
        }
    }
    
    private var chipContent: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12))
            
            Text(title)
                .font(.bodySmall)
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.s)
        .background(backgroundColor)
        .cornerRadius(CornerRadius.large)
        .overlay(chipBorder)
    }
    
    private var foregroundColor: Color {
        isSelected ? color : .textSecondary
    }
    
    private var backgroundColor: Color {
        isSelected ? color.opacity(0.2) : Color.cardBackground
    }
    
    private var chipBorder: some View {
        RoundedRectangle(cornerRadius: CornerRadius.large)
            .stroke(isSelected ? color : Color.cardBorder, lineWidth: 1)
    }
}

// MARK: - Date Range Button
struct DateRangeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            buttonContent
        }
    }
    
    private var buttonContent: some View {
        HStack {
            Text(title)
                .font(.bodyMedium)
                .foregroundColor(textColor)
            
            Spacer()
            
            if isSelected {
                checkmark
            }
        }
        .padding(Spacing.m)
        .background(backgroundColor)
        .cornerRadius(CornerRadius.medium)
        .overlay(buttonBorder)
    }
    
    private var textColor: Color {
        isSelected ? .primaryOrange : .textPrimary
    }
    
    private var backgroundColor: Color {
        isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground
    }
    
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.primaryOrange)
    }
    
    private var buttonBorder: some View {
        RoundedRectangle(cornerRadius: CornerRadius.medium)
            .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: 1)
    }
}

#Preview {
    FilterSheet(filter: .constant(RunFilter()))
}
