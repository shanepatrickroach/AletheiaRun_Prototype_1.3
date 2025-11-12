//
//  TechModeView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/20/25.
//

import SwiftUI

// MARK: - Tech Mode View
/// Technical view for detailed Force Portrait analysis with multiple perspectives and views
struct TechModeView: View {
    let snapshots: [RunSnapshot]  // NEW: Accept snapshots

    // Selection States
    @State private var selectedPerspective: ForcePerspective = .rear
    @State private var selectedView: ForceView = .aesthetic
    @State private var selectedLeg: LegSelection = .both
    @State private var currentSnapshotIndex: Int = 0  // NEW: Track current snapshot

    // Current snapshot
    private var currentSnapshot: RunSnapshot? {
        guard !snapshots.isEmpty, currentSnapshotIndex < snapshots.count else {
            return nil
        }
        return snapshots[currentSnapshotIndex]
    }

    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            

            
            
            // Force Portrait Display
            forcePortraitDisplay
            // Snapshot Navigation (NEW)
            if snapshots.count > 1 {
                snapshotNavigator
            }

            // Perspective Selector
            perspectiveSelector

            // View Type Selector
            viewTypeSelector

            // Leg Selector (disabled for Aesthetic view)
            legSelector

           
            // Legend/Info based on selected view
            viewInfoSection
        }
    }

    // MARK: - Section Header
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Force Portrait Analysis")
                .font(.headline)
                .foregroundColor(.textPrimary)

            if let snapshot = currentSnapshot {
                Text(
                    "Snapshot \(snapshot.snapshotNumber) • \(snapshot.formattedDistance)"
                )
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            } else {
                Text("Explore different perspectives and analysis views")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Snapshot Navigator (NEW)
    private var snapshotNavigator: some View {
        VStack(spacing: Spacing.m) {
            // Snapshot info and counter
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Snapshot Navigation")
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)

                    if let snapshot = currentSnapshot {
                        HStack(spacing: Spacing.xs) {
                            Text("Snapshot \(snapshot.snapshotNumber)")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text(formatTimestamp(snapshot.duration))
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text(snapshot.formattedDistance)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }

                Spacer()

                // Snapshot counter
                Text("\(currentSnapshotIndex + 1) of \(snapshots.count)")
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    .background(Color.primaryOrange.opacity(0.2))
                    .cornerRadius(CornerRadius.small)
            }

            // Navigation controls
            HStack(spacing: Spacing.m) {
                // Previous button
                Button(action: previousSnapshot) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                            .font(.bodySmall)
                    }
                    .foregroundColor(
                        currentSnapshotIndex > 0
                            ? .primaryOrange : .textTertiary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.backgroundBlack)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                .disabled(currentSnapshotIndex == 0)

                // Timeline dots
                snapshotTimeline

                // Next button
                Button(action: nextSnapshot) {
                    HStack(spacing: Spacing.xs) {
                        Text("Next")
                            .font(.bodySmall)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(
                        currentSnapshotIndex < snapshots.count - 1
                            ? .primaryOrange : .textTertiary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.backgroundBlack)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                .disabled(currentSnapshotIndex >= snapshots.count - 1)
            }

            // Quick snapshot preview strip (NEW)
            //snapshotPreviewStrip
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Snapshot Timeline (NEW)
    private var snapshotTimeline: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(0..<snapshots.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                currentSnapshotIndex = index
                            }
                        }) {
                            Circle()
                                .fill(
                                    index == currentSnapshotIndex
                                        ? Color.primaryOrange : Color.cardBorder
                                )
                                .frame(width: 8, height: 8)
                                .id(index)
                        }
                    }
                }
                .padding(.horizontal, Spacing.xs)
            }
            .frame(maxWidth: 120)
            .onChange(of: currentSnapshotIndex) { newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }

    // MARK: - Snapshot Preview Strip (NEW)
    private var snapshotPreviewStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s) {
                ForEach(Array(snapshots.enumerated()), id: \.offset) {
                    index, snapshot in
                    SnapshotPreviewThumbnail(
                        snapshot: snapshot,
                        index: index,
                        isSelected: index == currentSnapshotIndex,
                        action: {
                            withAnimation {
                                currentSnapshotIndex = index
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Perspective Selector
    private var perspectiveSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Perspective")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.s) {
                ForEach(ForcePerspective.allCases, id: \.self) { perspective in
                    PerspectiveButton(
                        perspective: perspective,
                        isSelected: selectedPerspective == perspective,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPerspective = perspective
                            }
                        }
                    )
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    // MARK: - View Type Selector
    private var viewTypeSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("View Type")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.xs) {
                ForEach(ForceView.allCases, id: \.self) { view in
                    ViewTypeButton(
                        view: view,
                        isSelected: selectedView == view,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedView = view
                                // Reset to "both" when switching to aesthetic
                                if view == .aesthetic {
                                    selectedLeg = .both
                                }
                            }
                        }
                    )
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    // MARK: - Leg Selector
    private var legSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Text("Leg Selection")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(
                        isLegSelectorEnabled ? .textPrimary : .textTertiary)

                if !isLegSelectorEnabled {
                    Text("(Disabled for Aesthetic)")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }

            HStack(spacing: Spacing.s) {
                ForEach(LegSelection.allCases, id: \.self) { leg in
                    LegButton(
                        leg: leg,
                        isSelected: selectedLeg == leg,
                        isEnabled: isLegSelectorEnabled,
                        action: {
                            if isLegSelectorEnabled {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedLeg = leg
                                }
                            }
                        }
                    )
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .opacity(isLegSelectorEnabled ? 1.0 : 0.5)
    }

    private var isLegSelectorEnabled: Bool {
        selectedView != .aesthetic
    }

    // MARK: - Force Portrait Display
    private var forcePortraitDisplay: some View {
        VStack(spacing: Spacing.s) {
            // Current Selection Info
            HStack(spacing: Spacing.m) {
                // Perspective Badge
                SelectionBadge(
                    icon: selectedPerspective.icon,
                    label: selectedPerspective.rawValue,
                    color: .primaryOrange
                )

                // View Badge
                SelectionBadge(
                    icon: selectedView.icon,
                    label: selectedView.rawValue,
                    color: .infoBlue
                )

                // Leg Badge (if applicable)
                if isLegSelectorEnabled {
                    SelectionBadge(
                        icon: selectedLeg.icon,
                        label: selectedLeg.rawValue,
                        color: selectedLeg.color
                    )
                }
            }

            // Force Portrait Image
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.backgroundBlack)

                // Image based on selection
                forcePortraitImage
                    .transition(.opacity)
                    .id(
                        "\(currentSnapshotIndex)-\(selectedPerspective.rawValue)-\(selectedView.rawValue)-\(selectedLeg.rawValue)"
                    )  // NEW: Force refresh on changes
            }
            .frame(height: 300)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.primaryOrange.opacity(0.3),
                                Color.primaryOrange.opacity(0.1),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )

//            // NEW: Snapshot metrics preview
//            if let snapshot = currentSnapshot {
//                snapshotMetricsPreview(snapshot)
//            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    // MARK: - Snapshot Metrics Preview (NEW)
    private func snapshotMetricsPreview(_ snapshot: RunSnapshot) -> some View {
        HStack(spacing: Spacing.m) {
            MetricPreviewBadge(
                label: "Efficiency",
                value: snapshot.performanceMetrics.efficiency
            )

            MetricPreviewBadge(
                label: "Symmetry",
                value: snapshot.injuryMetrics.portraitSymmetry
            )

            MetricPreviewBadge(
                label: "Cadence",
                value: snapshot.gaitCycleMetrics.cadence
            )
        }
    }

    // MARK: - Force Portrait Image
    private var forcePortraitImage: some View {
        let imageName = constructImageName()

        return Group {
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding(Spacing.m)
            } else {
                // Fallback placeholder
                VStack(spacing: Spacing.m) {
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.textTertiary)

                    Text("Force Portrait")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    if let snapshot = currentSnapshot {
                        Text("Snapshot #\(snapshot.snapshotNumber)")
                            .font(.bodySmall)
                            .foregroundColor(.primaryOrange)
                    }

                    Text(imageName)
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)

                    Text("Image will be loaded here")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.xl)
            }
        }
    }

    // MARK: - Construct Image Name
    private func constructImageName() -> String {
        // Format: ForcePortrait_{Perspective}_{View}_{Leg}
        // Example: ForcePortrait_Rear_Aesthetic_Both

        var components = ["ForcePortrait"]
        components.append(selectedPerspective.rawValue)
        components.append(selectedView.rawValue)

        // Only add leg suffix if not aesthetic view
        if selectedView != .aesthetic {
            components.append(selectedLeg.rawValue)
        } else {
            components.append("Both")  // Always use "Both" for aesthetic
        }

        return components.joined(separator: "_")
    }

    // MARK: - View Info Section
    private var viewInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.infoBlue)

                Text(selectedView.infoTitle)
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
            }

            Text(selectedView.description)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            // View-specific legend
            if let legend = selectedView.legend {
                Divider()
                    .background(Color.cardBorder)

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(legend, id: \.label) { item in
                        HStack(spacing: Spacing.s) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 12, height: 12)

                            Text(item.label)
                                .font(.caption)
                                .foregroundColor(.textPrimary)

                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.infoBlue.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Helper Methods (NEW)
    private func previousSnapshot() {
        guard currentSnapshotIndex > 0 else { return }
        withAnimation {
            currentSnapshotIndex -= 1
        }
    }

    private func nextSnapshot() {
        guard currentSnapshotIndex < snapshots.count - 1 else { return }
        withAnimation {
            currentSnapshotIndex += 1
        }
    }

    private func formatTimestamp(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Snapshot Preview Thumbnail (NEW)
struct SnapshotPreviewThumbnail: View {
    let snapshot: RunSnapshot
    let index: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                // Snapshot number
                Text("#\(snapshot.snapshotNumber)")
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(
                        isSelected ? .primaryOrange : .textSecondary)

                // Mini force portrait thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.backgroundBlack)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 20))
                        .foregroundColor(
                            isSelected ? .primaryOrange : .textTertiary)
                }
                .frame(width: 50, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            isSelected ? Color.primaryOrange : Color.cardBorder,
                            lineWidth: isSelected ? 2 : 1
                        )
                )

                // Distance
                Text(snapshot.formattedDistance)
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.xs)
            .background(
                isSelected
                    ? Color.primaryOrange.opacity(0.1) : Color.backgroundBlack
            )
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

// MARK: - Metric Preview Badge (NEW)
struct MetricPreviewBadge: View {
    let label: String
    let value: Int

    private var color: Color {
        if value >= 80 { return .successGreen }
        if value >= 60 { return .warningYellow }
        return .errorRed
    }

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.bodyMedium)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xs)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Force Perspective Enum
enum ForcePerspective: String, CaseIterable {
    case top = "Top"
    case side = "Side"
    case rear = "Rear"

    var icon: String {
        switch self {
        case .top: return Icon.topViewIcon
        case .side: return Icon.sideViewIcon
        case .rear: return Icon.rearViewIcon
        }
    }

    var description: String {
        switch self {
        case .top: return "View from above showing lateral movement"
        case .side: return "View from below showing ground contact"
        case .rear: return "View from behind showing body alignment"
        }
    }
}

// MARK: - Force View Enum
enum ForceView: String, CaseIterable {
    case aesthetic = "Aesthetic"
    case leftRight = "Left/Right"
    case gaitCycle = "Gait Cycle"

    var icon: String {
        switch self {
        case .aesthetic: return "paintbrush.fill"
        case .leftRight: return "arrow.left.and.right"
        case .gaitCycle: return "circle.dotted.and.circle"
        }
    }

    var infoTitle: String {
        switch self {
        case .aesthetic: return "Aesthetic View"
        case .leftRight: return "Left/Right Comparison"
        case .gaitCycle: return "Gait Cycle Phases"
        }
    }

    var description: String {
        switch self {
        case .aesthetic:
            return
                "Overall force distribution visualization."
        case .leftRight:
            return
                "Side-by-side comparison of left and right forces."
        case .gaitCycle:
            return
                "Force distribution across different gait cycle phases."
        }
    }

    var legend: [LegendItem]? {
        switch self {
        case .aesthetic:
            return [
                LegendItem(
                    color: .successGreen, label: "Optimal force distribution"),
                LegendItem(color: .warningYellow, label: "Moderate force"),
                LegendItem(color: .errorRed, label: "High force concentration"),
            ]
        case .leftRight:
            return [
                LegendItem(color: .leftSide, label: "Left leg forces"),
                LegendItem(color: .rightSide, label: "Right leg forces"),
            ]
        case .gaitCycle:
            return [
                LegendItem(color: .landingColor, label: "Landing phase"),
                LegendItem(
                    color: .stabilizingColor, label: "Stabilizing phase"),
                LegendItem(
                    color: .launchingColor, label: "Launching phase"),
                LegendItem(color: .flyingColor, label: "Flying phase"),
            ]
        }
    }
}

// MARK: - Leg Selection Enum
enum LegSelection: String, CaseIterable {
    case both = "Both"
    case left = "Left"
    case right = "Right"

    var icon: String {
        switch self {
        case .both: return "figure.stand"
        case .left: return "l.square.fill"
        case .right: return "r.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .both: return .successGreen
        case .left: return .leftSide
        case .right: return .rightSide
        }
    }
}

// MARK: - Legend Item
struct LegendItem {
    let color: Color
    let label: String
}

// MARK: - Perspective Button
struct PerspectiveButton: View {
    let perspective: ForcePerspective
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(perspective.icon)
                    .font(.system(size: 24))
                    .foregroundColor(
                        isSelected ? .backgroundBlack : .primaryOrange)

                Text(perspective.rawValue)
                    .font(.bodySmall)
                    .foregroundColor(
                        .textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(
                Color.backgroundBlack
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        isSelected ? Color.primaryOrange : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

// MARK: - View Type Button
struct ViewTypeButton: View {
    let view: ForceView
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                Image(systemName: view.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .backgroundBlack : .infoBlue)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(view.rawValue)
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(
                            isSelected ? .backgroundBlack : .textPrimary)

                    if !isSelected {
                        Text(view.description)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.backgroundBlack)
                }
            }
            .padding(Spacing.m)
            .background(isSelected ? Color.infoBlue : Color.backgroundBlack)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(
                        isSelected ? Color.infoBlue : Color.cardBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

// MARK: - Leg Button
struct LegButton: View {
    let leg: LegSelection
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: leg.icon)
                    .font(.system(size: 24))
                    .foregroundColor(buttonForegroundColor)

                Text(leg.rawValue)
                    .font(.bodySmall)
                    .foregroundColor(buttonForegroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(buttonBackgroundColor)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(buttonBorderColor, lineWidth: isSelected ? 2 : 1)
            )
        }
        .disabled(!isEnabled)
    }

    private var buttonForegroundColor: Color {
        if !isEnabled {
            return .textTertiary
        }
        return isSelected ? .backgroundBlack : leg.color
    }

    private var buttonBackgroundColor: Color {
        if !isEnabled {
            return Color.cardBorder.opacity(0.3)
        }
        return isSelected ? leg.color : Color.backgroundBlack
    }

    private var buttonBorderColor: Color {
        if !isEnabled {
            return Color.cardBorder
        }
        return isSelected ? leg.color : Color.cardBorder
    }
}

// MARK: - Selection Badge
struct SelectionBadge: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.caption)

            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(color)
        .padding(.horizontal, Spacing.s)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}


// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()

        ScrollView {
            TechModeView(
                snapshots: RunSnapshot.generateSampleSnapshots(count: 10)
            )
            .padding()
        }
    }
}
