// Features/Run/PostRunSurveyView.swift

import SwiftUI

struct PostRunSurveyView: View {
    @ObservedObject var runSession: RunSessionManager

    @State private var painPointDetails = ""
    @State private var energyLevel: EnergyLevel = .moderate
    @State private var perceivedEffort = 5
    @State private var notes = ""
    @State private var showingCompletion = false
    @State private var showingPainInfo: PainPointType?

    @State private var selectedPainPoints: Set<PainPointSelection> = []
    @State private var showingSideSelection: PainPointType?  // NEW

    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {

                    // MARK: - Header
                    header

                    // MARK: - Run Summary
                    runSummary

                    // MARK: - Pain Points (NEW)
                    painPointsSection

                    // MARK: - Energy Level
                    energyLevelSection

                    // MARK: - Perceived Effort
                    perceivedEffortSection

                    // MARK: - Notes
                    notesSection

                    // MARK: - Submit Button
                    PrimaryButton(
                        title: "Complete Session"
                    ) {
                        submitSurvey()
                    }
                    .padding(.bottom, Spacing.xl)
                }
                .padding(Spacing.m)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $showingPainInfo) { painPoint in
            PainPointDetailSheet(painPoint: painPoint)
        }
        .alert("Session Saved!", isPresented: $showingCompletion) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Your run has been saved and is ready for analysis.")
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: Spacing.s) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.successGreen)

            Text("Great Work!")
                .font(Font.titleLarge)
                .foregroundColor(.textPrimary)

            Text("Help us understand your run better")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, Spacing.xl)
    }

    // MARK: - Run Summary
    private var runSummary: some View {
        VStack(spacing: Spacing.m) {
            Text("Session Summary")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: Spacing.m) {

                SummaryMetric(
                    icon: "ruler",
                    value: String(format: "%.2f mi", runSession.distance),
                    label: "Distance"
                )
                SummaryMetric(
                    icon: "clock.fill",
                    value: runSession.formattedDuration,
                    label: "Duration"
                )
                SummaryMetric(
                    icon: "speedometer",
                    value: runSession.formattedPace,
                    label: "Avg Pace"
                )
            }

            HStack(spacing: Spacing.m) {

                SummaryMetric(
                    icon: runSession.configuration?.mode.icon ?? "figure.run",
                    value: runSession.configuration?.mode.rawValue ?? "Run",
                    label: "Type"
                )

                SummaryMetric(
                    icon: runSession.configuration?.terrain.icon
                        ?? "road.lanes",
                    value: runSession.configuration?.terrain.rawValue ?? "Road",
                    label: "Terrain"
                )
            }
        }
    }

    // MARK: - Pain Points Section (UPDATED with Side Selection)
    private var painPointsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Any Pain or Discomfort?")
                .font(Font.headline)
                .foregroundColor(.textPrimary)

            Text("Tap areas where you felt pain")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)

            // Quick selection grid
            LazyVGrid(columns: columns, spacing: Spacing.m) {
                ForEach(PainPointType.allCases) { painPoint in
                    PainPointGridCell(
                        painPoint: painPoint,
                        isSelected: isPainPointSelected(painPoint),
                        selectedSides: getSelectedSides(for: painPoint),  // NEW
                        onToggle: {
                            handlePainPointTap(painPoint)
                        },
                        onInfo: {
                            showingPainInfo = painPoint
                        }
                    )
                }
            }

            // Selected summary
            if !selectedPainPoints.isEmpty {
                selectedPainSummary
            }

            // Pain details text field
            if !selectedPainPoints.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Additional Details (Optional)")
                        .font(Font.caption)
                        .foregroundColor(.textSecondary)

                    TextEditor(text: $painPointDetails)
                        .font(Font.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .frame(height: 80)
                        .padding(Spacing.s)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.small)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                }
                .transition(.opacity)
            }

            // Quick tip
            quickTip
        }
        .sheet(item: $showingSideSelection) { painPoint in
            PainPointSideSelectionSheet(
                painPoint: painPoint,
                onSelect: { side in
                    addPainPoint(type: painPoint, side: side)
                }
            )
        }
    }

    // Add this helper function:
    private func getSelectedSides(for type: PainPointType) -> [PainPointSide] {
        selectedPainPoints
            .filter { $0.type == type }
            .map { $0.side }
    }

    // MARK: - Helper Functions for Pain Points
    private func isPainPointSelected(_ type: PainPointType) -> Bool {
        selectedPainPoints.contains { $0.type == type }
    }

    private func handlePainPointTap(_ type: PainPointType) {
        // If already selected, remove all instances of this pain point
        if isPainPointSelected(type) {
            withAnimation {
                selectedPainPoints = selectedPainPoints.filter {
                    $0.type != type
                }
            }
        } else {
            // If needs side selection, show sheet
            if type.needsSideSelection {
                showingSideSelection = type
            } else {
                // For pain points that don't need side selection (like low back)
                addPainPoint(type: type, side: .both)
            }
        }
    }

    private func addPainPoint(type: PainPointType, side: PainPointSide) {
        withAnimation(.spring(response: 0.3)) {
            let selection = PainPointSelection(type: type, side: side)
            selectedPainPoints.insert(selection)
        }
    }

    private func removePainPoint(_ selection: PainPointSelection) {
        withAnimation {
            selectedPainPoints.remove(selection)
        }
    }

    // MARK: - Selected Pain Summary (UPDATED)
    private var selectedPainSummary: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Selected Pain Points (\(selectedPainPoints.count))")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button(action: {
                    withAnimation {
                        selectedPainPoints.removeAll()
                    }
                }) {
                    Text("Clear All")
                        .font(.bodySmall)
                        .foregroundColor(.errorRed)
                }
            }

            // Compact list with sides
            VStack(spacing: Spacing.xs) {
                ForEach(
                    Array(selectedPainPoints).sorted(by: {
                        $0.displayText < $1.displayText
                    })
                ) { selection in
                    HStack(spacing: Spacing.s) {
                        // Color indicator
                        Circle()
                            .fill(selection.type.color)
                            .frame(width: 8, height: 8)

                        // Side badge
                        HStack(spacing: 4) {
                            Image(systemName: selection.side.icon)
                                .font(.system(size: 10))
                            Text(selection.side.rawValue)
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(selection.side.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(selection.side.color.opacity(0.2))
                        .cornerRadius(4)

                        // Pain point name
                        Text(selection.type.displayName)
                            .font(.bodySmall)
                            .foregroundColor(.textPrimary)

                        Spacer()

                        // Remove button
                        Button(action: {
                            removePainPoint(selection)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.errorRed.opacity(0.7))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, Spacing.xs)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }

    // MARK: - Quick Tip
    private var quickTip: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundColor(.warningYellow)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Important")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                Text(
                    "If pain persists or worsens, consult a healthcare professional"
                )
                .font(.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(Spacing.s)
        .background(Color.warningYellow.opacity(0.1))
        .cornerRadius(CornerRadius.small)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Energy Level Section
    private var energyLevelSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Energy Level")
                .font(Font.headline)
                .foregroundColor(.textPrimary)

            Text("How did you feel during this run?")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)

            HStack(spacing: Spacing.s) {
                ForEach(EnergyLevel.allCases, id: \.self) { level in
                    EnergyLevelButton(
                        level: level,
                        isSelected: energyLevel == level
                    ) {
                        energyLevel = level
                    }
                }
            }
        }
    }

    // MARK: - Perceived Effort Section
    private var perceivedEffortSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Perceived Effort")
                    .font(Font.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(perceivedEffort)/10")
                    .font(Font.titleMedium)
                    .foregroundColor(.primaryOrange)
            }

            Text(
                "Rate how hard this run felt (1 = very easy, 10 = maximum effort)"
            )
            .font(Font.bodySmall)
            .foregroundColor(.textSecondary)

            VStack(spacing: Spacing.s) {
                // Slider
                Slider(
                    value: Binding(
                        get: { Double(perceivedEffort) },
                        set: { perceivedEffort = Int($0) }
                    ), in: 1...10, step: 1
                )
                .tint(.primaryOrange)

                // Labels
                HStack {
                    Text("Easy")
                        .font(Font.caption)
                        .foregroundColor(.successGreen)

                    Spacer()

                    Text("Moderate")
                        .font(Font.caption)
                        .foregroundColor(.warningYellow)

                    Spacer()

                    Text("Hard")
                        .font(Font.caption)
                        .foregroundColor(.errorRed)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }

    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Additional Notes")
                .font(Font.headline)
                .foregroundColor(.textPrimary)

            Text("Any other insights about this run? (Optional)")
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)

            TextEditor(text: $notes)
                .scrollContentBackground(.hidden)  // hides default background
                .background(Color.black.opacity(0.6))
                .font(Font.bodyMedium)
                .foregroundColor(.textPrimary)
                .frame(height: 120)
                .padding(Spacing.s)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.cardBorder, lineWidth: 2)
                )
        }
    }

    // MARK: - Submit Survey (UPDATED)
    private func submitSurvey() {
        

        // Create detailed pain description with sides
        let detailedPainDescription = createDetailedPainDescription()

        

        
        showingCompletion = true
    }

    // Helper to create detailed pain description with sides
    private func createDetailedPainDescription() -> String {
        var descriptions: [String] = []

        for selection in selectedPainPoints {
            let sideText =
                selection.type.needsSideSelection
                ? "\(selection.side.rawValue) " : ""
            descriptions.append("\(sideText)\(selection.type.displayName)")
        }

        var fullDescription = descriptions.joined(separator: ", ")

        if !painPointDetails.isEmpty {
            fullDescription += "\n\nAdditional details: \(painPointDetails)"
        }

        return fullDescription
    }

    
}

// MARK: - Pain Point Grid Cell (UPDATED to show sides)
struct PainPointGridCell: View {
    let painPoint: PainPointType
    let isSelected: Bool
    let selectedSides: [PainPointSide]  // NEW parameter
    let onToggle: () -> Void
    let onInfo: () -> Void

    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: Spacing.m) {
                // Icon area
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(
                            isSelected
                                ? painPoint.color.opacity(0.2)
                                : Color.cardBackground
                        )
                        .frame(height: 100)

                    VStack(spacing: Spacing.s) {
                        // Body part icon
                        Image(systemName: painPoint.bodyIcon)
                            .font(.system(size: 36))
                            .foregroundColor(
                                isSelected ? painPoint.color : .textTertiary)

                        // Side indicators if selected
                        if isSelected && !selectedSides.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(selectedSides, id: \.self) { side in
                                    Image(systemName: side.icon)
                                        .font(.system(size: 14))
                                        .foregroundColor(side.color)
                                }
                            }
                        } else if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(painPoint.color)
                        }
                    }

                    // Info button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: onInfo) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.infoBlue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(Spacing.xs)
                        }
                        Spacer()
                    }
                }

                // Label
                VStack(spacing: 4) {
                    Text(painPoint.displayName)
                        .font(.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(height: 34)

                    Text(painPoint.locationLabel)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
            }
            .padding(Spacing.s)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(
                        isSelected ? painPoint.color : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ? painPoint.color.opacity(0.3) : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Summary Metric
struct SummaryMetric: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)

            Text(value)
                .font(Font.bodyLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(label)
                .font(Font.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Energy Level Button
struct EnergyLevelButton: View {
    let level: EnergyLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Text(level.emoji)
                    .font(.system(size: 32))

                Text(level.title)
                    .font(Font.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(
                isSelected
                    ? Color.primaryOrange.opacity(0.2) : Color.cardBackground
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        PostRunSurveyView(runSession: RunSessionManager())
    }
}
