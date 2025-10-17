//
//  PocketCoachView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/16/25.
//


import SwiftUI

// MARK: - Pocket Coach View
/// Shows personalized exercise recommendations based on run metrics
struct PocketCoachView: View {
    let interval: RunInterval
    
    @State private var completedExercises: Set<UUID> = []
    @State private var selectedExercise: Exercise?
    
    // Analyze metrics and generate coaching
    private var coaching: CoachingAnalysis {
        CoachingAnalysis.analyze(metrics: interval.performanceMetrics, injuryMetrics: interval.injuryMetrics)
    }
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Overall Assessment Card
            overallAssessmentCard
            
            // Focus Areas
            if !coaching.focusAreas.isEmpty {
                focusAreasSection
            }
            
            // What You Did Well
            if !coaching.strengths.isEmpty {
                strengthsSection
            }
            
            // Progress Tracker
//            progressSection
        }
    }
    
    // MARK: - Overall Assessment Card
    private var overallAssessmentCard: some View {
        VStack(spacing: Spacing.m) {
            HStack(spacing: Spacing.m) {
                // Assessment icon
                ZStack {
                    Circle()
                        .fill(coaching.overallStatus.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: coaching.overallStatus.icon)
                        .font(.system(size: 30))
                        .foregroundColor(coaching.overallStatus.color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Overall Assessment")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(coaching.overallStatus.title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
            }
            
            // Summary message
            Text(coaching.summaryMessage)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(coaching.overallStatus.color.opacity(0.5), lineWidth: 2)
        )
    }
    
    // MARK: - Focus Areas Section
    private var focusAreasSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Focus Areas")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            ForEach(coaching.focusAreas.prefix(3)) { area in
                FocusAreaCard(
                    area: area,
                    completedExercises: $completedExercises,
                    selectedExercise: $selectedExercise
                )
            }
        }
    }
    
    // MARK: - Strengths Section
    private var strengthsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "star.fill")
                    .foregroundColor(.warningYellow)
                
                Text("What You Did Well")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.s) {
                ForEach(coaching.strengths, id: \.self) { strength in
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.successGreen)
                        
                        Text(strength)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.successGreen.opacity(0.1))
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Today's Progress")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.m) {
                ProgressStat(
                    icon: "checkmark.circle.fill",
                    value: "\(completedExercises.count)",
                    label: "Completed",
                    color: .successGreen
                )
                
                ProgressStat(
                    icon: "flame.fill",
                    value: "\(completedExercises.count > 0 ? "1" : "0")",
                    label: "Day Streak",
                    color: .primaryOrange
                )
                
                ProgressStat(
                    icon: "target",
                    value: "\(Int(Double(completedExercises.count) / Double(coaching.totalExercises) * 100))%",
                    label: "Complete",
                    color: .infoBlue
                )
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailSheet(
                exercise: exercise,
                isCompleted: completedExercises.contains(exercise.id),
                onComplete: {
                    completedExercises.insert(exercise.id)
                    selectedExercise = nil
                }
            )
        }
    }
}

// MARK: - Focus Area Card
struct FocusAreaCard: View {
    let area: FocusArea
    @Binding var completedExercises: Set<UUID>
    @Binding var selectedExercise: Exercise?
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: { withAnimation { isExpanded.toggle() }}) {
                HStack(spacing: Spacing.m) {
                    // Priority indicator
                    ZStack {
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .fill(area.severity.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: area.severity.icon)
                            .foregroundColor(area.severity.color)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(area.title)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: Spacing.xs) {
                            Text("Score: \(area.score)")
                                .font(.caption)
                                .foregroundColor(area.severity.color)
                            
                            Text("•")
                                .foregroundColor(.textTertiary)
                            
                            Text(area.severity.title)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.m)
            }
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Divider()
                        .background(Color.cardBorder)
                    
                    // Why it matters
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "info.circle.fill")
                                .font(.caption)
                                .foregroundColor(.infoBlue)
                            
                            Text("Why This Matters")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .fontWeight(.semibold)
                        }
                        
                        Text(area.why)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    // Quick tip
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption)
                                .foregroundColor(.warningYellow)
                            
                            Text("Quick Tip")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .fontWeight(.semibold)
                        }
                        
                        Text(area.quickTip)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    Divider()
                        .background(Color.cardBorder)
                    
                    // Exercises
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Recommended Exercises")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .fontWeight(.semibold)
                            .padding(.horizontal, Spacing.m)
                        
                        ForEach(area.exercises) { exercise in
                            ExerciseRow(
                                exercise: exercise,
                                isCompleted: completedExercises.contains(exercise.id),
                                onTap: { selectedExercise = exercise }
                            )
                        }
                    }
                }
                .padding(.bottom, Spacing.m)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(area.severity.color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Exercise Row
struct ExerciseRow: View {
    let exercise: Exercise
    let isCompleted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.m) {
                // Thumbnail placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "play.circle.fill")
                        .font(.titleMedium)
                        .foregroundColor(.primaryOrange)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(exercise.name)
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(exercise.duration)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    // Difficulty badge
                    Text(exercise.difficulty.rawValue)
                        .font(.caption)
                        .foregroundColor(exercise.difficulty.color)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(exercise.difficulty.color.opacity(0.15))
                        .cornerRadius(CornerRadius.small)
                }
                
                Spacer()
                
                // Completion indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.titleMedium)
                        .foregroundColor(.successGreen)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(Spacing.m)
            .background(isCompleted ? Color.successGreen.opacity(0.1) : Color.backgroundBlack)
            .cornerRadius(CornerRadius.small)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Exercise Detail Sheet
struct ExerciseDetailSheet: View {
    let exercise: Exercise
    let isCompleted: Bool
    let onComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Video placeholder
                        ZStack {
                            Rectangle()
                                .fill(Color.cardBackground)
                                .frame(height: 250)
                            
                            VStack(spacing: Spacing.m) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.primaryOrange)
                                
                                Text("Video Demo")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            // Exercise info
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text(exercise.name)
                                    .font(.titleLarge)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.m) {
                                    Label(exercise.duration, systemImage: "clock")
                                    Label(exercise.difficulty.rawValue, systemImage: "chart.bar")
                                }
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                            }
                            
                            // Benefit
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Primary Benefit")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                    .fontWeight(.semibold)
                                
                                Text(exercise.benefit)
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryOrange)
                            }
                            .padding(Spacing.m)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.primaryOrange.opacity(0.1))
                            .cornerRadius(CornerRadius.medium)
                            
                            // Instructions
                            VStack(alignment: .leading, spacing: Spacing.s) {
                                Text("How To Perform")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                
                                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                                    HStack(alignment: .top, spacing: Spacing.s) {
                                        Text("\(index + 1)")
                                            .font(.bodySmall)
                                            .foregroundColor(.backgroundBlack)
                                            .fontWeight(.bold)
                                            .frame(width: 24, height: 24)
                                            .background(Color.primaryOrange)
                                            .cornerRadius(CornerRadius.small)
                                        
                                        Text(instruction)
                                            .font(.bodySmall)
                                            .foregroundColor(.textSecondary)
                                    }
                                }
                            }
                            
                            // Tips
                            if !exercise.tips.isEmpty {
                                VStack(alignment: .leading, spacing: Spacing.s) {
                                    Text("Pro Tips")
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)
                                    
                                    ForEach(exercise.tips, id: \.self) { tip in
                                        HStack(alignment: .top, spacing: Spacing.xs) {
                                            Image(systemName: "lightbulb.fill")
                                                .font(.caption)
                                                .foregroundColor(.warningYellow)
                                            
                                            Text(tip)
                                                .font(.bodySmall)
                                                .foregroundColor(.textSecondary)
                                        }
                                    }
                                }
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.medium)
                            }
                        }
                        .padding(.horizontal, Spacing.m)
                    }
                }
                
                // Mark complete button
                VStack {
                    Spacer()
                    
                    if !isCompleted {
                        Button(action: onComplete) {
                            Text("Mark as Complete")
                                .font(.bodyLarge)
                                .foregroundColor(.backgroundBlack)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.m)
                                .background(Color.primaryOrange)
                                .cornerRadius(CornerRadius.medium)
                        }
                        .padding(.horizontal, Spacing.m)
                        .padding(.bottom, Spacing.m)
                        .background(
                            LinearGradient(
                                colors: [Color.backgroundBlack.opacity(0), Color.backgroundBlack],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
            }
            .navigationTitle("Exercise Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Progress Stat Component
struct ProgressStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.titleMedium)
                .foregroundColor(color)
            
            Text(value)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(color.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Models

struct CoachingAnalysis {
    let overallStatus: AssessmentStatus
    let summaryMessage: String
    let focusAreas: [FocusArea]
    let strengths: [String]
    
    var totalExercises: Int {
        focusAreas.reduce(0) { $0 + $1.exercises.count }
    }
    
    static func analyze(metrics: PerformanceMetrics, injuryMetrics: InjuryMetrics) -> CoachingAnalysis {
        var focusAreas: [FocusArea] = []
        var strengths: [String] = []
        
        // Analyze performance metrics
        if metrics.impact < 60 {
            focusAreas.append(FocusArea.highImpact(score: metrics.impact))
        } else if metrics.impact >= 85 {
            strengths.append("Excellent impact control")
        }
        
        if metrics.sway < 60 {
            focusAreas.append(FocusArea.lateralSway(score: metrics.sway))
        } else if metrics.sway >= 85 {
            strengths.append("Great lateral stability")
        }
        
        if metrics.efficiency >= 85 {
            strengths.append("Outstanding efficiency (\(metrics.efficiency))")
        }
        
        // Analyze injury metrics
        if injuryMetrics.hipMobility < 70 {
            focusAreas.append(FocusArea.hipMobility(score: injuryMetrics.hipMobility))
        }
        
        // Determine overall status
        let avgScore = (metrics.overallScore + injuryMetrics.overallScore) / 2
        let status: AssessmentStatus
        let message: String
        
        if avgScore >= 80 {
            status = .good
            message = "Great run! Just a few minor areas to maintain your excellent form."
        } else if avgScore >= 60 {
            status = .attention
            message = "Solid run with some areas that need attention. Let's work on these together."
        } else {
            status = .concern
            message = "We've identified several areas to improve. Focus on these exercises to reduce injury risk."
        }
        
        return CoachingAnalysis(
            overallStatus: status,
            summaryMessage: message,
            focusAreas: focusAreas.sorted { $0.score < $1.score }.prefix(3).map { $0 },
            strengths: strengths
        )
    }
}

enum AssessmentStatus {
    case good, attention, concern
    
    var title: String {
        switch self {
        case .good: return "Looking Good!"
        case .attention: return "Needs Attention"
        case .concern: return "Focus Required"
        }
    }
    
    var icon: String {
        switch self {
        case .good: return "checkmark.circle.fill"
        case .attention: return "exclamationmark.triangle.fill"
        case .concern: return "exclamationmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .good: return .successGreen
        case .attention: return .warningYellow
        case .concern: return .errorRed
        }
    }
}

struct FocusArea: Identifiable {
    let id = UUID()
    let title: String
    let score: Int
    let severity: Severity
    let why: String
    let quickTip: String
    let exercises: [Exercise]
    
    static func highImpact(score: Int) -> FocusArea {
        FocusArea(
            title: "High Impact Forces",
            score: score,
            severity: score < 50 ? .high : .medium,
            why: "Hard landings increase stress on your knees, shins, and ankles, raising injury risk over time.",
            quickTip: "Focus on landing mid-foot with a slight forward lean. Imagine running quietly.",
            exercises: [
                Exercise(
                    name: "Calf Raises",
                    duration: "3 sets × 15 reps",
                    difficulty: .beginner,
                    benefit: "Strengthens calves for softer landings",
                    instructions: [
                        "Stand with feet hip-width apart",
                        "Rise up onto the balls of your feet",
                        "Hold for 2 seconds at the top",
                        "Lower slowly back down"
                    ],
                    tips: ["Keep core engaged", "Can add weight for progression"]
                ),
                Exercise(
                    name: "Jump Rope Drills",
                    duration: "3 minutes",
                    difficulty: .intermediate,
                    benefit: "Improves landing mechanics and rhythm",
                    instructions: [
                        "Start with feet together",
                        "Jump on the balls of your feet",
                        "Keep knees slightly bent",
                        "Focus on light, quick contacts"
                    ],
                    tips: ["Land softly", "Maintain upright posture"]
                )
            ]
        )
    }
    
    static func lateralSway(score: Int) -> FocusArea {
        FocusArea(
            title: "Lateral Sway",
            score: score,
            severity: score < 50 ? .high : .medium,
            why: "Excessive side-to-side movement wastes energy and can lead to IT band and hip issues.",
            quickTip: "Engage your core and imagine running on a straight line. Keep hips level.",
            exercises: [
                Exercise(
                    name: "Single-Leg Balance",
                    duration: "3 sets × 30 seconds each leg",
                    difficulty: .beginner,
                    benefit: "Improves hip stability and balance",
                    instructions: [
                        "Stand on one leg",
                        "Keep hips level",
                        "Hold arms out for balance",
                        "Close eyes for added challenge"
                    ],
                    tips: ["Focus on a point ahead", "Engage glutes"]
                ),
                Exercise(
                    name: "Side Plank",
                    duration: "3 sets × 30 seconds each side",
                    difficulty: .intermediate,
                    benefit: "Strengthens core and hip stabilizers",
                    instructions: [
                        "Lie on your side",
                        "Prop up on elbow",
                        "Lift hips off ground",
                        "Keep body in straight line"
                    ],
                    tips: ["Don't let hips sag", "Breathe steadily"]
                )
            ]
        )
    }
    
    static func hipMobility(score: Int) -> FocusArea {
        FocusArea(
            title: "Limited Hip Mobility",
            score: score,
            severity: score < 50 ? .high : .medium,
            why: "Tight hips restrict your stride and can cause compensations leading to lower back or knee pain.",
            quickTip: "Stretch hip flexors daily, especially after sitting for long periods.",
            exercises: [
                Exercise(
                    name: "Hip Flexor Stretch",
                    duration: "3 sets × 30 seconds each side",
                    difficulty: .beginner,
                    benefit: "Increases hip flexor length and mobility",
                    instructions: [
                        "Kneel on one knee (lunge position)",
                        "Keep back straight",
                        "Push hips forward gently",
                        "Feel stretch in front of hip"
                    ],
                    tips: ["Don't arch lower back", "Breathe into the stretch"]
                ),
                Exercise(
                    name: "90/90 Hip Stretch",
                    duration: "3 sets × 45 seconds",
                    difficulty: .intermediate,
                    benefit: "Improves internal and external hip rotation",
                    instructions: [
                        "Sit with both legs at 90 degrees",
                        "One leg in front, one to the side",
                        "Lean forward over front leg",
                        "Switch sides"
                    ],
                    tips: ["Keep back straight", "Use yoga block if needed"]
                )
            ]
        )
    }
}

enum Severity {
    case low, medium, high
    
    var title: String {
        switch self {
        case .low: return "Minor"
        case .medium: return "Moderate"
        case .high: return "Important"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "info.circle.fill"
        case .medium: return "exclamationmark.triangle.fill"
        case .high: return "exclamationmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .infoBlue
        case .medium: return .warningYellow
        case .high: return .errorRed
        }
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let difficulty: Difficulty
    let benefit: String
    let instructions: [String]
    let tips: [String]
}

enum Difficulty: String {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var color: Color {
        switch self {
        case .beginner: return .successGreen
        case .intermediate: return .warningYellow
        case .advanced: return .errorRed
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleInterval = RunInterval(
        id: UUID(),
        intervalNumber: 1,
        distance: 0.5,
        duration: 240,
        timestamp: Date(),
        performanceMetrics: PerformanceMetrics(
            efficiency: 85,
            sway: 55,
            braking: 72,
            endurance: 78,
            warmup: 80,
            impact: 45,
            variation: 68
        ),
        injuryMetrics: InjuryMetrics(
            hipMobility: 65,
            hipStability: 75,
            portraitSymmetry: 82
        )
    )
    
    ScrollView {
        PocketCoachView(interval: sampleInterval)
            .padding(Spacing.m)
    }
    .background(Color.backgroundBlack)
}
