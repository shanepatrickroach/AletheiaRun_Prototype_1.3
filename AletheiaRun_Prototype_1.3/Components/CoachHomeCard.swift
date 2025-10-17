//
//  CoachHomeCard.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/16/25.
//


import SwiftUI

// MARK: - Coach Home Card
/// Adaptive card that shows relevant coaching content on home screen
struct CoachHomeCard: View {
    let latestRun: Run?
    @State private var completedToday: Set<String> = []
    @State private var showingFullCoach = false
    
    private var cardContent: CoachCardContent {
        CoachCardContent.determine(from: latestRun, completedExercises: completedToday)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Header
            HStack {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: cardContent.headerIcon)
                        .foregroundColor(.primaryOrange)
                    
                    Text(cardContent.headerTitle)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Button(action: { showingFullCoach = true }) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.bodySmall)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            .padding(.horizontal, Spacing.m)
            
            // Content Card
            contentCard
        }
        .sheet(isPresented: $showingFullCoach) {
            FullCoachView(latestRun: latestRun)
        }
    }
    
    // MARK: - Content Card
    private var contentCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Status indicator
            HStack(spacing: Spacing.s) {
                Image(systemName: cardContent.statusIcon)
                    .foregroundColor(cardContent.statusColor)
                
                Text(cardContent.statusMessage)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
            }
            
            // Main content based on type
            switch cardContent.type {
            case .postRun(let focusArea):
                postRunContent(focusArea: focusArea)
                
            case .streakMaintenance(let days):
                streakContent(days: days)
                
            case .activeRecovery:
                recoveryContent()
                
            case .weeklyPattern(let issue):
                patternContent(issue: issue)
            }
            
            // Action button
            actionButton
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(cardContent.borderColor.opacity(0.5), lineWidth: 2)
        )
        .padding(.horizontal, Spacing.m)
    }
    
    // MARK: - Post Run Content
    private func postRunContent(focusArea: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            // Focus area badge
            HStack(spacing: Spacing.xs) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(.warningYellow)
                
                Text("Focus Area: \(focusArea)")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            // Recommended exercises
            VStack(spacing: Spacing.xs) {
                ForEach(cardContent.exercises.prefix(2), id: \.self) { exercise in
                    exerciseRow(exercise)
                }
            }
        }
    }
    
    // MARK: - Streak Content
    private func streakContent(days: Int) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Streak visualization
            HStack(spacing: Spacing.xs) {
                ForEach(0..<7, id: \.self) { index in
                    Circle()
                        .fill(index < days ? Color.primaryOrange : Color.cardBorder)
                        .frame(width: 8, height: 8)
                }
            }
            
            Text("Complete today's exercises to keep it going!")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            // Today's exercises
            VStack(spacing: Spacing.xs) {
                ForEach(cardContent.exercises.prefix(2), id: \.self) { exercise in
                    exerciseRow(exercise)
                }
            }
        }
    }
    
    // MARK: - Recovery Content
    private func recoveryContent() -> some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Perfect time for active recovery:")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: Spacing.xs) {
                ForEach(cardContent.exercises, id: \.self) { exercise in
                    exerciseRow(exercise)
                }
            }
        }
    }
    
    // MARK: - Pattern Content
    private func patternContent(issue: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Based on your last 5 runs:")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: Spacing.xs) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.caption)
                    .foregroundColor(.infoBlue)
                
                Text("Consistent \(issue) detected")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            VStack(spacing: Spacing.xs) {
                ForEach(cardContent.exercises.prefix(2), id: \.self) { exercise in
                    exerciseRow(exercise)
                }
            }
        }
    }
    
    // MARK: - Exercise Row
    private func exerciseRow(_ exercise: String) -> some View {
        HStack {
            Button(action: {
                // Toggle completion
                if completedToday.contains(exercise) {
                    completedToday.remove(exercise)
                } else {
                    completedToday.insert(exercise)
                }
            }) {
                Image(systemName: completedToday.contains(exercise) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(completedToday.contains(exercise) ? .successGreen : .textTertiary)
            }
            
            Text(exercise)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .strikethrough(completedToday.contains(exercise))
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button(action: { showingFullCoach = true }) {
            HStack {
                Image(systemName: cardContent.actionIcon)
                Text(cardContent.actionText)
            }
            .font(.bodyMedium)
            .foregroundColor(.backgroundBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(Color.primaryOrange)
            .cornerRadius(CornerRadius.medium)
        }
    }
}

// MARK: - Coach Card Content Model
struct CoachCardContent {
    let type: CoachCardType
    let headerTitle: String
    let headerIcon: String
    let statusIcon: String
    let statusMessage: String
    let statusColor: Color
    let borderColor: Color
    let exercises: [String]
    let actionText: String
    let actionIcon: String
    
    enum CoachCardType {
        case postRun(focusArea: String)
        case streakMaintenance(days: Int)
        case activeRecovery
        case weeklyPattern(issue: String)
    }
    
    static func determine(from run: Run?, completedExercises: Set<String>) -> CoachCardContent {
        // Check if there's a recent run (within 24 hours)
        if let run = run, isRecent(run.date) {
            return postRunAnalysis(run)
        }
        
        // Check for active streak
        let streakDays = 5 // Mock - would calculate from actual data
        if streakDays > 0 && !completedExercises.isEmpty {
            return streakMaintenance(days: streakDays)
        }
        
        // Check if it's a rest day (no run in last 48 hours)
        if let run = run, !isRecent(run.date) && !isVeryRecent(run.date) {
            return activeRecovery()
        }
        
        // Default: weekly pattern
        return weeklyPattern()
    }
    
    private static func isRecent(_ date: Date) -> Bool {
        Date().timeIntervalSince(date) < 86400 // 24 hours
    }
    
    private static func isVeryRecent(_ date: Date) -> Bool {
        Date().timeIntervalSince(date) < 172800 // 48 hours
    }
    
    // MARK: - Post Run Analysis
    private static func postRunAnalysis(_ run: Run) -> CoachCardContent {
        // Analyze metrics to find focus area
        let metrics = run.metrics
        var focusArea = "Form"
        var exercises: [String] = []
        
        if metrics.impact < 60 {
            focusArea = "High Impact"
            exercises = ["Calf Raises (3×15)", "Jump Rope Drills (3 min)"]
        } else if metrics.sway < 60 {
            focusArea = "Lateral Sway"
            exercises = ["Single-Leg Balance (3×30s)", "Side Plank (3×30s)"]
        } else if metrics.efficiency < 70 {
            focusArea = "Efficiency"
            exercises = ["Form Drills (10 min)", "Cadence Work (5 min)"]
        } else {
            focusArea = "Maintenance"
            exercises = ["Hip Stretches (10 min)", "Core Work (5 min)"]
        }
        
        return CoachCardContent(
            type: .postRun(focusArea: focusArea),
            headerTitle: "Post-Run Coach",
            headerIcon: "figure.run.circle.fill",
            statusIcon: metrics.overallScore >= 80 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill",
            statusMessage: metrics.overallScore >= 80 ? "Great run! One area to maintain:" : "Good run! Let's work on:",
            statusColor: metrics.overallScore >= 80 ? .successGreen : .warningYellow,
            borderColor: .primaryOrange,
            exercises: exercises,
            actionText: "View Full Analysis",
            actionIcon: "arrow.right.circle.fill"
        )
    }
    
    // MARK: - Streak Maintenance
    private static func streakMaintenance(days: Int) -> CoachCardContent {
        CoachCardContent(
            type: .streakMaintenance(days: days),
            headerTitle: "Pocket Coach",
            headerIcon: "flame.fill",
            statusIcon: "flame.fill",
            statusMessage: "\(days)-Day Exercise Streak! 🔥",
            statusColor: .primaryOrange,
            borderColor: .primaryOrange,
            exercises: [
                "Hip Flexor Stretch (3×30s)",
                "Single-Leg Balance (3×30s)",
                "Core Activation (5 min)"
            ],
            actionText: "Start Today's Session",
            actionIcon: "play.circle.fill"
        )
    }
    
    // MARK: - Active Recovery
    private static func activeRecovery() -> CoachCardContent {
        CoachCardContent(
            type: .activeRecovery,
            headerTitle: "Recovery Day",
            headerIcon: "heart.circle.fill",
            statusIcon: "leaf.fill",
            statusMessage: "Active recovery helps you bounce back stronger",
            statusColor: .successGreen,
            borderColor: .successGreen,
            exercises: [
                "Foam Rolling (10 min)",
                "Dynamic Stretching (10 min)",
                "Light Yoga Flow (15 min)"
            ],
            actionText: "Start Recovery Session",
            actionIcon: "play.circle.fill"
        )
    }
    
    // MARK: - Weekly Pattern
    private static func weeklyPattern() -> CoachCardContent {
        CoachCardContent(
            type: .weeklyPattern(issue: "hip mobility"),
            headerTitle: "Pocket Coach",
            headerIcon: "chart.xyaxis.line",
            statusIcon: "info.circle.fill",
            statusMessage: "Based on your patterns, focus on:",
            statusColor: .infoBlue,
            borderColor: .infoBlue,
            exercises: [
                "Hip Mobility Work (10 min)",
                "Glute Activation (8 min)"
            ],
            actionText: "View Recommendations",
            actionIcon: "arrow.right.circle.fill"
        )
    }
}

// MARK: - Full Coach View (Modal)
struct FullCoachView: View {
    let latestRun: Run?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Placeholder for full coach interface
                        VStack(spacing: Spacing.m) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Full Pocket Coach")
                                .font(.titleLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("Complete exercise library and detailed analysis coming soon")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.top, Spacing.xxxxl)
                        
                        // Quick actions
                        VStack(spacing: Spacing.m) {
                            QuickCoachAction(
                                icon: "list.bullet.clipboard",
                                title: "View Exercise Library",
                                description: "Browse all available exercises"
                            )
                            
                            QuickCoachAction(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Track Progress",
                                description: "See your improvement over time"
                            )
                            
                            QuickCoachAction(
                                icon: "calendar",
                                title: "Schedule Workouts",
                                description: "Plan your exercise routine"
                            )
                        }
                        .padding(.horizontal, Spacing.m)
                    }
                }
            }
            .navigationTitle("Pocket Coach")
            .navigationBarTitleDisplayMode(.large)
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

// MARK: - Quick Coach Action
struct QuickCoachAction: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
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

// MARK: - Preview
#Preview {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.2,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 55,
            sway: 78,
            endurance: 82,
            warmup: 75,
            impact: 88,
            braking: 80,
            variation: 77
        )
    )
    
    ScrollView {
        CoachHomeCard(latestRun: sampleRun)
    }
    .background(Color.backgroundBlack)
}