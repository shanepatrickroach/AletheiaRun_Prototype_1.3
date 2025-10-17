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
                    VStack(spacing: Spacing.xl) {
                        SubscriptionBanner()

                        // MARK: - Header with Greeting
                        headerSection

                        
                        // MARK: - Latest Force Portrait (3 Views)
                        forcePortraitSection
                        
                        // Quick Coach Summary
                        
                        CoachHomeCard(latestRun: latestRun)
                     

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

                        

                        
                        // MARK: - Quick Actions
                        //                        quickActionsSection()

                        // MARK: - Tip of the Week
                        tipOfTheWeekSection
                    }

                    .padding(.bottom, 100)  // Extra space for tab bar
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
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
                icon: "road.lanes",
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

    // MARK: - Recommended Exercises Section
    private var recommendedExercisesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pocket Coach")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text("Personalized for your form")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Button(action: {
                    // Navigate to all exercises
                }) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.bodySmall)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            .padding(.horizontal, Spacing.m)

//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: Spacing.m) {
//                    ForEach(Array(recommendedExercises)) { exercise in
//                        ExerciseCard(exercise: exercise)
//                    }
//                }
//                .padding(.horizontal, Spacing.m)
//            }
        }
    }

    //    // MARK: - Quick Actions Section
    //    private var quickActionsSection: some View {
    //        VStack(alignment: .leading, spacing: Spacing.m) {
    //            Text("Quick Actions")
    //                .font(.headline)
    //                .foregroundColor(.textPrimary)
    //                .padding(.horizontal, Spacing.m)
    //
    //            LazyVGrid(columns: [
    //                GridItem(.flexible()),
    //                GridItem(.flexible())
    //            ], spacing: Spacing.m) {
    //                QuickActionButton(
    //                    icon: "calendar",
    //                    title: "Calendar",
    //                    color: .infoBlue,
    //                    action: onCalendarTap
    //                )
    //
    //                QuickActionButton(
    //                    icon: "chart.bar.fill",
    //                    title: "Progress",
    //                    color: .successGreen,
    //                    action: onProgressTap
    //                )
    //
    //                QuickActionButton(
    //                    icon: "chart.xyaxis.line",
    //                    title: "Stats",
    //                    color: .warningYellow,
    //                    action: {
    //                        // Navigate to stats
    //                    }
    //                )
    //
    //                QuickActionButton(
    //                    icon: "person.badge.shield.checkmark",
    //                    title: "Coach Mode",
    //                    color: .primaryOrange,
    //                    action: {
    //                        // Navigate to coach mode
    //                    }
    //                )
    //            }
    //            .padding(.horizontal, Spacing.m)
    //        }
    //    }
    //
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
                .stroke(tipColor.opacity(0.3), lineWidth: 1)
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

// MARK: - Quick Actions Section
struct quickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.m) {
                QuickActionButton(
                    icon: "books.vertical.fill",
                    title: "Library",
                    color: .infoBlue
                )

                QuickActionButton(
                    icon: "calendar",
                    title: "Calendar",
                    color: .successGreen
                )

                QuickActionButton(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Progress",
                    color: .primaryOrange
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        Button(action: {
            // Navigate to respective view
        }) {
            VStack(spacing: Spacing.s) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }

                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
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
