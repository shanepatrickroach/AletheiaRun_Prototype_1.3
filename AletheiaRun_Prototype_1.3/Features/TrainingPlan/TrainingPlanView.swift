//
//  TrainingPlanView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//
import SwiftUI

// MARK: - Training Plan View
/// Main view for personalized training plan based on metrics
struct TrainingPlanView: View {
    @StateObject private var viewModel = TrainingPlanViewModel()
    @State private var showGeneratePlan = false
    var isEmbedded: Bool = false  // Add this parameter

    var body: some View {
        Group {
            if isEmbedded {
                // When embedded, don't wrap in NavigationStack
                contentView
            } else {
                // When standalone, wrap in NavigationStack
                NavigationStack {
                    contentView
                }.navigationTitle("Training Plan")
                    .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            // Auto-generate plan on first launch
            if viewModel.currentPlan == nil {
                generateSamplePlan()
            }
        }
    }

    // MARK: - Content View
    private var contentView: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()

            if let plan = viewModel.currentPlan {
                planContentView(plan: plan)
            } else {
                emptyStateView
            }
        }
    }

    // MARK: - Plan Content View
    private func planContentView(plan: TrainingPlan) -> some View {
        ScrollView {
            VStack(spacing: Spacing.m) {
                // Plan Overview Header
                planOverviewCard(plan: plan)

                // Progress Card
                progressCard(plan: plan)

                // Exercises List
                exercisesSection
            }
            .padding(.horizontal, Spacing.m)
            .padding(.bottom, Spacing.xxl)
        }
    }

    // MARK: - Plan Overview Card
    private func planOverviewCard(plan: TrainingPlan) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Your Training Plan")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text(
                        "Created for run recorded on \(plan.generatedDate.formatted(date: .abbreviated, time: .omitted))"
                    )
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                }

            }

            // Targeted Metrics
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Targeting \(plan.targetedMetrics.count) Metrics")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.xs) {
                        ForEach(Array(plan.targetedMetrics.keys), id: \.self) {
                            metric in
                            if let score = plan.targetedMetrics[metric] {
                                MetricBadge(
                                    metric: metric,
                                    score: score
                                )
                            }
                        }
                    }
                }
            }

            // Pain Points
            if !plan.painPoints.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Addressing Pain Points")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    FlowLayout(spacing: Spacing.xs) {
                        ForEach(plan.painPoints, id: \.self) { painPoint in
                            PainPointTag(painPoint: painPoint)
                        }
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
    // MARK: - Progress Card
    private func progressCard(plan: TrainingPlan) -> some View {
        VStack(spacing: Spacing.m) {
            HStack {
                Text("Progress")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(plan.completedExercises)/\(plan.totalExercises)")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryOrange)
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.cardBorder)
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.primaryOrange, Color.primaryLight,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * plan.completionRate,
                            height: 12
                        )
                }
            }
            .frame(height: 12)

            // Stats Row
            HStack(spacing: Spacing.xl) {
                ProgressStatItem(
                    icon: "checkmark.circle.fill",
                    value: "\(plan.completedExercises)",
                    label: "Completed"
                )

                ProgressStatItem(
                    icon: "clock.fill",
                    value: "\(plan.totalExercises - plan.completedExercises)",
                    label: "Remaining"
                )

                ProgressStatItem(
                    icon: "percent",
                    value: String(format: "%.0f%%", plan.completionRate * 100),
                    label: "Complete"
                )
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }

    // MARK: - Filter Section
    private var filterSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Filters")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    // Clear filters
                    if viewModel.selectedMetricFilter != nil
                        || viewModel.selectedLevelFilter != nil
                    {
                        FilterChip(
                            title: "Clear All",
                            icon: "xmark.circle.fill",
                            isSelected: false,
                            action: {
                                viewModel.selectedMetricFilter = nil
                                viewModel.selectedLevelFilter = nil
                            }
                        )
                    }

                    // Level filters
                    ForEach(ExerciseLevel.allCases, id: \.self) { level in
                        FilterChip(
                            title: level.rawValue,
                            icon: level.icon,
                            isSelected: viewModel.selectedLevelFilter == level,
                            action: {
                                viewModel.selectedLevelFilter =
                                    viewModel.selectedLevelFilter == level
                                    ? nil : level
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Exercises Section
    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("\(viewModel.filteredExercises.count) Exercises")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()
            }

            ForEach(viewModel.sortedExercises) { exercise in
                NavigationLink(
                    destination: ExerciseDetailView(
                        exercise: exercise,
                        viewModel: viewModel
                    )
                ) {
                    ExerciseCard(exercise: exercise, viewModel: viewModel)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundColor(.textTertiary)

            VStack(spacing: Spacing.s) {
                Text("No Training Plan Yet")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)

                Text(
                    "Generate a personalized plan based on your running metrics"
                )
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
            }

            Button(action: { showGeneratePlan = true }) {
                HStack(spacing: Spacing.s) {
                    Image(systemName: "sparkles")
                    Text("Generate Plan")
                }
                .font(.bodyLarge)
                .foregroundColor(.backgroundBlack)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.m)
                .background(Color.primaryOrange)
                .cornerRadius(CornerRadius.large)
            }
            .padding(.top, Spacing.m)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Generating View
    private var generatingView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            ProgressView()
                .scaleEffect(1.5)
                .tint(.primaryOrange)

            VStack(spacing: Spacing.s) {
                Text("Generating Your Plan")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)

                Text(
                    "Analyzing your metrics and creating personalized exercises"
                )
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
            }

            Spacer()
        }
    }

    // MARK: - Helper Methods
    private func generateSamplePlan() {
        let sampleMetrics: [ExerciseMetric: Int] = [
            .impact: 20,
            .braking: 32,
            .sway: 78,
            .hipMobility: 15,
            .hipStability: 68,
            .cadence: 72,
        ]

        viewModel.generatePlan(
            metrics: sampleMetrics,
            painPoints: [.knee, .hip]
        )
    }
}

// MARK: - Metric Badge
struct MetricBadge: View {
    let metric: ExerciseMetric
    let score: Int

    private var level: ExerciseLevel {
        ExerciseLevel.forScore(score)
    }

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: metric.icon)
                .font(.caption)

            Text(metric.rawValue)
                .font(.caption)

            Text("\(score)")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(level.color)
        .padding(.horizontal, Spacing.s)
        .padding(.vertical, 4)
        .background(level.color.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Pain Point Tag
struct PainPointTag: View {
    let painPoint: PainPoint

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Image(systemName: painPoint.icon)
                .font(.system(size: 10))
            Text(painPoint.rawValue)
                .font(.caption)
        }
        .foregroundColor(.errorRed)
        .padding(.horizontal, Spacing.s)
        .padding(.vertical, 4)
        .background(Color.errorRed.opacity(0.15))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Progress Stat Item
struct ProgressStatItem: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)

            Text(value)
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Exercise Card
struct ExerciseCard: View {
    let exercise: Exercise
    @ObservedObject var viewModel: TrainingPlanViewModel

    var body: some View {
        HStack(spacing: Spacing.m) {
            // Icon/Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(exercise.level.color.opacity(0.2))

                Image(systemName: exercise.videoThumbnail)
                    .font(.system(size: 32))
                    .foregroundColor(Color.white)
            }
            .frame(width: 70, height: 70)

            // Exercise Info
            VStack(alignment: .leading, spacing: Spacing.xs) {

                HStack(spacing: Spacing.s) {
                    // Level badge
                    HStack(spacing: 4) {

                        Text(exercise.level.rawValue)
                    }
                    .font(.caption)
                    .foregroundColor(exercise.level.color)

                    // Target metric
                    HStack(spacing: Spacing.xxs) {

                        Text(exercise.targetMetric.rawValue)
                            .font(.caption)
                    }.foregroundColor(exercise.targetMetric.color)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(exercise.targetMetric.color.opacity(0.15))
                        .cornerRadius(4)
                }

                Text(exercise.name)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                HStack(spacing: Spacing.s) {

                    // Duration
                    Text(exercise.duration)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

            }

            Spacer()

            // Completion checkmark
            Button(action: {
                if exercise.isCompleted {
                    viewModel.resetExercise(exercise)
                } else {
                    viewModel.completeExercise(exercise)
                }
            }) {
                Image(
                    systemName: exercise.isCompleted
                        ? "checkmark.circle.fill" : "circle"
                )
                .font(.system(size: 28))
                .foregroundColor(
                    exercise.isCompleted ? .successGreen : .textTertiary)
            }
        }
        .padding(Spacing.m)
        .background(
            exercise.isCompleted
                ? Color.successGreen.opacity(0.05) : Color.cardBackground
        )
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(
                    exercise.isCompleted
                        ? Color.successGreen.opacity(0.3) : Color.cardBorder,
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Preview
#Preview {
    TrainingPlanView()
}
