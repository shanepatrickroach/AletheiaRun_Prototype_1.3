// Features/Dashboard/HomeView.swift

import SwiftUI

struct HomeView: View {
    let onLibraryTap: () -> Void
    let onCalendarTap: () -> Void
    let onProgressTap: () -> Void
    let onStartRunTap: () -> Void

    @State private var selectedForcePortraitView: ForcePortraitViewType = .rear
    @EnvironmentObject var gamificationManager: GamificationManager

    // Sample data - replace with actual data from your app
    let latestRun = SampleData.runs.first
    let weeklyTip = WeeklyTip.currentTip

    enum ForcePortraitViewType: String, CaseIterable {
        case rear = "Rear"
        case side = "Side"
        case top = "Top"

        var icon: String {
            switch self {
            case .rear: return "figure.stand"
            case .side: return "figure.walk"
            case .top: return "arrow.down.circle"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xxl) {
                        //SubscriptionBanner()

                        // MARK: - Header with Greeting
                        headerSection

                        
                        // MARK: - Latest Force Portrait (3 Views)
                        forcePortraitSection
                        
                                                
                        trainingPlanSection
                        
                        // MARK: - Coach Mode Feature Card (NEW)
                        coachModeFeatureCard
                     

                        // Recent Achievements (NEW)
                        if !gamificationManager.unlockedAchievements.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.m) {
                                HStack {
                                    Text("Recent Achievements")
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)

                                    Spacer()

                                    NavigationLink(destination: ProgressView())
                                    {
                                        Text("See All")
                                            .font(.bodySmall)
                                            .foregroundColor(.primaryOrange)
                                    }
                                }
                                .padding(.horizontal, Spacing.l)

                                ScrollView(.horizontal, showsIndicators: false)
                                {
                                    HStack(spacing: Spacing.m) {
                                        ForEach(
                                            gamificationManager
                                                .unlockedAchievements.prefix(5)
                                        ) { achievement in
                                            MiniAchievementCard(
                                                achievement: achievement)
                                        }
                                    }
                                    .padding(.horizontal, Spacing.l)
                                }
                            }
                        }

                        // Active Challenge (NEW)
                        if let challenge = gamificationManager.activeChallenges
                            .first
                        {
                            VStack(alignment: .leading, spacing: Spacing.m) {
                                HStack {
                                    Text("Active Challenge")
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)

                                    Spacer()

                                    NavigationLink(destination: ProgressView())
                                    {
                                        Text("View All")
                                            .font(.bodySmall)
                                            .foregroundColor(.primaryOrange)
                                    }
                                }
                                .padding(.horizontal, Spacing.l)

                                ChallengeCard(challenge: challenge)
                                    .padding(.horizontal, Spacing.l)
                            }
                        }

                
                        // MARK: - Tip of the Week
                        tipOfTheWeekSection
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 120) // Extra space for tab bar
                }
            }
            
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text(greeting)
                .font(.titleLarge)
                .foregroundColor(.textPrimary)

            if let run = latestRun {
                Text(
                    "Last run: \(run.date.formatted(date: .abbreviated, time: .omitted))"
                )
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            } else {
                Text("Ready to start your first run?")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.m)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }

    // MARK: - Force Portrait Section (UPDATED for Images)
    private var forcePortraitSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Latest Force Portrait")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

//                if let run = latestRun {
//                    HStack(spacing: 4) {
//                        Circle()
//                            .fill(efficiencyColor(run.metrics.efficiency))
//                            .frame(width: 8, height: 8)
//
//                        Text("\(run.metrics.efficiency)")
//                            .font(.bodySmall)
//                            .foregroundColor(.textSecondary)
//                    }
//                }
            }
            .padding(.horizontal, Spacing.m)

            if let run = latestRun {
                VStack(spacing: Spacing.m) {
                    // Three Force Portrait Views with Images
                    threeViewForcePortrait

                    // Run Stats (Distance, Time, Pace)
                    runStatsRow(for: run)
                }
            } else {
                // Empty State
                emptyForcePortraitState
            }
        }
    }

    // MARK: - Three View Force Portrait Display (Using Images)
    private var threeViewForcePortrait: some View {
        VStack(spacing: Spacing.s) {
            // View Labels
            HStack(spacing: Spacing.xs) {
                Text("Rear")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)

                Text("Side")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)

                Text("Top")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, Spacing.m)

            // Three Views Side by Side
            HStack(spacing: Spacing.s) {
                // Rear View
                forcePortraitImageView(imageName: "ForcePortrait_Rear")

                // Side View
                forcePortraitImageView(imageName: "ForcePortrait_Side")

                // Top View
                forcePortraitImageView(imageName: "ForcePortrait_Top")
            }
            .frame(height: 220)
            .padding(.horizontal, Spacing.m)

            // Tap to view detailed analysis
            Text("Tap to view detailed analysis")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, Spacing.m)
        .onTapGesture {
            // Navigate to detailed Force Portrait view
        }
    }

    // MARK: - Individual Force Portrait Image View
    private func forcePortraitImageView(imageName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.backgroundBlack)

            // Force Portrait Image
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(4)

            // Fallback if image not found
            if UIImage(named: imageName) == nil {
                VStack(spacing: Spacing.xs) {
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.textTertiary)

                    Text("No Image")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.primaryOrange.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Run Stats Row (Distance, Time, Pace)
    private func runStatsRow(for run: Run) -> some View {
        HStack(spacing: Spacing.m) {
            // Distance
            RunStatCard(
                icon: "ruler",
                value: String(format: "%.2f", run.distance),
                unit: "mi",
                label: "Distance"
            )

            // Time
            RunStatCard(
                icon: "clock.fill",
                value: formatDuration(Int(run.duration)),
                unit: "",
                label: "Time"
            )

            // Pace
            RunStatCard(
                icon: "speedometer",
                value: "7",
                unit: "min/mi",
                label: "Pace"
            )
        }
        .padding(.horizontal, Spacing.m)
    }

    // MARK: - Run Stat Card
    struct RunStatCard: View {
        let icon: String
        let value: String
        let unit: String
        let label: String

        var body: some View {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryOrange)

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    if !unit.isEmpty {
                        Text(unit)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }

                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }

    // MARK: - Helper Function to Format Duration
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }

    private var emptyForcePortraitState: some View {
        VStack(spacing: Spacing.m) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.cardBackground)
                    .frame(height: 320)

                VStack(spacing: Spacing.m) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 60))
                        .foregroundColor(.textTertiary)

                    Text("No Force Portrait Yet")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text(
                        "Start your first run to see your biomechanics analysis"
                    )
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)

                    Button(action: onStartRunTap) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Run")
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.black)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.m)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.medium)
                    }
                    .padding(.top, Spacing.s)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .padding(.horizontal, Spacing.m)
    }


        
    // MARK: - Coach Mode Feature Card (UPDATED)
    private var coachModeFeatureCard: some View {
        NavigationLink(destination: CoachModeView()) {
            ZStack(alignment: .leading) {
                // Background Image with Overlay
                GeometryReader { geometry in
                    // Placeholder for background image
                    // Replace "coach_background" with your actual image asset name
                    if let _ = UIImage(named: "coach_background") {
                        Image("coach_background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    } else {
                        // Fallback gradient background
                        LinearGradient(
                            colors: [
                                Color.primaryOrange.opacity(0.6),
                                Color.primaryDark.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                    
                    // Dark overlay for text readability
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0.5)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.m) {
                    HStack {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            HStack(spacing: 6) {
                                Text("Coach Mode")
                                    .font(.titleMedium)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                // "New" badge
                                Text("NEW")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.primaryOrange)
                                    .cornerRadius(6)
                            }
                            
                            Text("Help other runners improve")
                                .font(.bodyLarge)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                        
                        // Arrow in circle
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }.padding(10)
                    
                    // Feature highlights with icons
                    HStack(spacing: Spacing.l) {
                        CoachModeFeatureHighlight(
                            icon: "person.2.fill",
                            text: "Multiple Athletes"
                        )
                        
                        CoachModeFeatureHighlight(
                            icon: "chart.line.uptrend.xyaxis",
                            text: "Track Progress"
                        )
                        
                        CoachModeFeatureHighlight(
                            icon: "message.fill",
                            text: "Real-time Feedback"
                        )
                    }
                    .padding(.top, Spacing.xs)
                }
                .padding(Spacing.l)
            }
            .frame(height: 260)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.primaryOrange.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: Color.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, Spacing.m)
    }
    
    // MARK: - Tip of the Week Section
    private var tipOfTheWeekSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Tip of the Week")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.m)

            TipCard(tip: weeklyTip)
                .padding(.horizontal, Spacing.m)
        }
    }

    // MARK: - Helper Functions
    private func efficiencyColor(_ value: Int) -> Color {
        switch value {
        case 80...100: return .successGreen
        case 60..<80: return .warningYellow
        default: return .errorRed
        }
    }
}
// MARK: - Coach Mode Feature Highlight (UPDATED)
struct CoachModeFeatureHighlight: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Training Plan Section
private var trainingPlanSection: some View {
    VStack(alignment: .leading, spacing: Spacing.m) {
        HStack {
            Text("Training Plan")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            NavigationLink(destination: TrainingPlanView()) {
                Text("View")
                    .font(.bodySmall)
                    .foregroundColor(.primaryOrange)
            }
        }
        .padding(.horizontal, Spacing.m)
        
        TrainingPlanHomeCard()
            .padding(.horizontal, Spacing.m)
    }
}



// MARK: - Training Plan Home Card
struct TrainingPlanHomeCard: View {
    @StateObject private var viewModel = TrainingPlanViewModel()
    
    var body: some View {
        NavigationLink(destination: TrainingPlanView()) {
            Group {
                if let plan = viewModel.currentPlan {
                    // Has Plan - Show Progress
                    activePlanCard(plan: plan)
                } else {
                    // No Plan - Prompt to Generate
                    emptyPlanCard
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Active Plan Card
    private func activePlanCard(plan: TrainingPlan) -> some View {
        VStack(spacing: Spacing.m) {
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Your Training Plan")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(plan.completedExercises) of \(plan.totalExercises) exercises completed")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.cardBorder)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryOrange, Color.primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * plan.completionRate,
                            height: 8
                        )
                }
            }
            .frame(height: 8)
            
            // Quick Stats
            HStack(spacing: Spacing.xl) {
                PlanStatBadge(
                    icon: "target",
                    value: "\(plan.targetedMetrics.count)",
                    label: "Metrics"
                )
                
                PlanStatBadge(
                    icon: "calendar",
                    value: "Updated \(relativeDateString(plan.generatedDate))",
                    label: ""
                )
                
                PlanStatBadge(
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
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Empty Plan Card
    private var emptyPlanCard: some View {
        VStack(spacing: Spacing.m) {
            HStack(spacing: Spacing.m) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Get Your Training Plan")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Personalized exercises based on your metrics")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
            }
            
            // Feature Highlights
            HStack(spacing: Spacing.m) {
                EmptyPlanFeature(
                    icon: "chart.line.uptrend.xyaxis",
                    text: "Metric-Based"
                )
                
                EmptyPlanFeature(
                    icon: "arrow.triangle.2.circlepath",
                    text: "Dynamic"
                )
                
                EmptyPlanFeature(
                    icon: "bandage.fill",
                    text: "Pain Focus"
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
    
    // MARK: - Helper Functions
    private func relativeDateString(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "today"
        } else if calendar.isDateInYesterday(date) {
            return "yesterday"
        } else {
            let days = calendar.dateComponents([.day], from: date, to: now).day ?? 0
            if days < 7 {
                return "\(days)d ago"
            } else {
                return date.formatted(date: .abbreviated, time: .omitted)
            }
        }
    }
}

// MARK: - Plan Stat Badge
struct PlanStatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.primaryOrange)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                if !label.isEmpty {
                    Text(label)
                        .font(.system(size: 9))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Empty Plan Feature
struct EmptyPlanFeature: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.primaryOrange)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xs)
        .background(Color.backgroundBlack)
        .cornerRadius(CornerRadius.small)
    }
}


// MARK: - Quick Metric Card
struct QuickMetricCard: View {
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)

            Text("\(value)")
                .font(.titleSmall)
                .foregroundColor(color)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}


// MARK: - Tip Card
struct TipCard: View {
    let tip: WeeklyTip

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    Circle()
                        .fill(tipColor.opacity(0.2))
                        .frame(width: 40, height: 40)

                    Image(systemName: tip.icon)
                        .font(.system(size: 20))
                        .foregroundColor(tipColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.category.rawValue)
                        .font(.caption)
                        .foregroundColor(tipColor)

                    Text(tip.title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }

                Spacer()
            }

            Text(tip.description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(tipColor.opacity(0.8), lineWidth: 1)
        )
        
    }

    private var tipColor: Color {
        switch tip.category.color {
        case "primaryOrange": return .primaryOrange
        case "errorRed": return .errorRed
        case "infoBlue": return .infoBlue
        case "successGreen": return .successGreen
        case "warningYellow": return .warningYellow
        case "primaryLight": return .primaryLight
        default: return .primaryOrange
        }
    }
}

// MARK: - Mini Achievement Card
struct MiniAchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: Spacing.s) {
            ZStack {
                Circle()
                    .fill(achievement.tier.color.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: achievement.icon)
                    .font(.system(size: 28))
                    .foregroundColor(achievement.tier.color)
            }

            Text(achievement.name)
                .font(.caption)
                .foregroundColor(.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)

            Text(achievement.tier.rawValue)
                .font(.system(size: 9))
                .fontWeight(.semibold)
                .foregroundColor(achievement.tier.color)
                .padding(.horizontal, 6)

                .background(achievement.tier.color.opacity(0.2))
                .cornerRadius(4)
        }
        .frame(width: 100)
        .padding(.vertical, Spacing.s)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Quick Stats Section
struct QuickStatsSection: View {
    var body: some View {
        VStack{
            Text("Quick Stats")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.m) {
                QuickStatCard(
                    value: "3.2",
                    unit: "mi",
                    label: "Today",
                    color: .primaryOrange
                )

                QuickStatCard(
                    value: "12.5",
                    unit: "mi",
                    label: "This Week",
                    color: .successGreen
                )

                QuickStatCard(
                    value: "156",
                    unit: "mi",
                    label: "Total",
                    color: .infoBlue
                )
            }
            
        }
        
    }
}

struct QuickStatCard: View {
    let value: String
    let unit: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.s) {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)

                Text(unit)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Force Portrait Section
struct ForcePortraitSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Latest Force Portrait")
                .font(.headline)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.m) {
                // Placeholder for Force Portrait
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.backgroundBlack)
                        .frame(height: 150)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryOrange.opacity(0.3))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                )

                HStack {
                    Text("Overall Efficiency")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    Spacer()

                    Text("85%")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.successGreen)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
        }
    }
}


#Preview {
    HomeView(
        onLibraryTap: {},
        onCalendarTap: {},
        onProgressTap: {},
        onStartRunTap: {}
    )
    .environmentObject(GamificationManager())
    .environmentObject(AuthenticationManager())
}






