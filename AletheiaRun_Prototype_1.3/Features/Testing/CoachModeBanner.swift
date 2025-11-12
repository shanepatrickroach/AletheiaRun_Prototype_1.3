//
//  CoachModeBanner.swift
//  AletheiaRun_Prototype_1.3
//
//  Banner to indicate current athlete being viewed in Coach Mode
//

import SwiftUI

// MARK: - Coach Mode Manager
class CoachModeManager: ObservableObject {
    @Published var isInCoachMode: Bool = false
    @Published var currentAthlete: Athlete?
    
    func enterCoachMode(athlete: Athlete) {
        currentAthlete = athlete
        isInCoachMode = true
    }
    
    func exitCoachMode() {
        isInCoachMode = false
        currentAthlete = nil
    }
    
    func switchAthlete(_ athlete: Athlete) {
        currentAthlete = athlete
    }
}

// MARK: - Athlete Model
struct Athlete: Identifiable, Equatable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let profileImage: String?  // URL or asset name
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let first = firstName.prefix(1)
        let last = lastName.prefix(1)
        return "\(first)\(last)".uppercased()
    }
    
    // Mock athletes for testing
    static let mockAthletes = [
        Athlete(id: UUID(), firstName: "Sarah", lastName: "Johnson", email: "sarah.j@email.com", profileImage: nil),
        Athlete(id: UUID(), firstName: "Mike", lastName: "Chen", email: "mike.chen@email.com", profileImage: nil),
        Athlete(id: UUID(), firstName: "Emily", lastName: "Rodriguez", email: "emily.r@email.com", profileImage: nil),
        Athlete(id: UUID(), firstName: "David", lastName: "Kim", email: "david.kim@email.com", profileImage: nil),
    ]
}

// MARK: - Option 1: Prominent Top Banner (RECOMMENDED)
struct CoachModeBanner: View {
    @ObservedObject var coachManager: CoachModeManager
    @State private var isAnimating = false
    
    var body: some View {
        if coachManager.isInCoachMode, let athlete = coachManager.currentAthlete {
            HStack(spacing: Spacing.m) {
                // Coach icon with pulse animation
                ZStack {
                    Circle()
                        .fill(Color.infoBlue.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .opacity(isAnimating ? 0.5 : 1.0)
                    
                    Image(systemName: "person.2.fill")
                        .font(.body)
                        .foregroundColor(.infoBlue)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
                
                // Athlete info
                VStack(alignment: .leading, spacing: 2) {
                    Text("Coach Mode")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("Viewing \(athlete.firstName)")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Exit button
                Button(action: {
                    withAnimation {
                        coachManager.exitCoachMode()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .font(.caption)
                        
                        Text("Exit")
                            .font(.bodySmall)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.infoBlue)
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.infoBlue.opacity(0.15))
                    .cornerRadius(CornerRadius.small)
                }
            }
            .padding(Spacing.m)
            .background(
                LinearGradient(
                    colors: [
                        Color.infoBlue.opacity(0.15),
                        Color.infoBlue.opacity(0.05)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                Rectangle()
                    .fill(Color.infoBlue)
                    .frame(height: 3),
                alignment: .bottom
            )
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

// MARK: - Option 2: Compact Pill Banner
struct CompactCoachModeBanner: View {
    @ObservedObject var coachManager: CoachModeManager
    
    var body: some View {
        if coachManager.isInCoachMode, let athlete = coachManager.currentAthlete {
            HStack(spacing: Spacing.s) {
                // Athlete avatar
                ZStack {
                    Circle()
                        .fill(Color.infoBlue.opacity(0.3))
                        .frame(width: 28, height: 28)
                    
                    Text(athlete.initials)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.infoBlue)
                }
                
                // Name
                Text(athlete.firstName)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                // Exit button
                Button(action: {
                    withAnimation {
                        coachManager.exitCoachMode()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.xs)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.infoBlue.opacity(0.5), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - Option 3: Card-Style Banner with More Info
struct DetailedCoachModeBanner: View {
    @ObservedObject var coachManager: CoachModeManager
    
    var body: some View {
        if coachManager.isInCoachMode, let athlete = coachManager.currentAthlete {
            VStack(spacing: Spacing.s) {
                HStack(spacing: Spacing.m) {
                    // Athlete avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.infoBlue, Color.infoBlue.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Text(athlete.initials)
                            .font(.titleSmall)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "person.2.fill")
                                .font(.caption)
                                .foregroundColor(.infoBlue)
                            
                            Text("Coach Mode")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Text(athlete.fullName)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text(athlete.email)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .background(Color.cardBorder)
                
                // Actions
                HStack(spacing: Spacing.m) {
                    Button(action: {
                        // Switch athlete action
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.caption)
                            
                            Text("Switch")
                                .font(.bodySmall)
                        }
                        .foregroundColor(.primaryOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.primaryOrange.opacity(0.1))
                        .cornerRadius(CornerRadius.small)
                    }
                    
                    Button(action: {
                        withAnimation {
                            coachManager.exitCoachMode()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                                .font(.caption)
                            
                            Text("Exit Coach Mode")
                                .font(.bodySmall)
                        }
                        .foregroundColor(.infoBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.infoBlue.opacity(0.1))
                        .cornerRadius(CornerRadius.small)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.infoBlue.opacity(0.5), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

// MARK: - Option 4: Floating Bubble (Bottom Corner)
struct FloatingCoachModeBubble: View {
    @ObservedObject var coachManager: CoachModeManager
    @State private var isExpanded = false
    
    var body: some View {
        if coachManager.isInCoachMode, let athlete = coachManager.currentAthlete {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    if isExpanded {
                        // Expanded view
                        HStack(spacing: Spacing.m) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Coach Mode")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                
                                Text(athlete.firstName)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .fontWeight(.semibold)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    coachManager.exitCoachMode()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(Spacing.m)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.large)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    } else {
                        // Collapsed view
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.infoBlue)
                                    .frame(width: 60, height: 60)
                                
                                VStack(spacing: 2) {
                                    Image(systemName: "person.2.fill")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    Text(athlete.initials)
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.trailing, Spacing.m)
                .padding(.bottom, 100) // Above tab bar
            }
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - View Extension for Easy Integration
extension View {
    func coachModeBanner(_ coachManager: CoachModeManager, style: CoachBannerStyle = .prominent) -> some View {
        ZStack(alignment: .top) {
            self
            
            VStack(spacing: 0) {
                switch style {
                case .prominent:
                    CoachModeBanner(coachManager: coachManager)
                case .compact:
                    HStack {
                        Spacer()
                        CompactCoachModeBanner(coachManager: coachManager)
                            .padding(.top, Spacing.s)
                            .padding(.trailing, Spacing.m)
                    }
                case .detailed:
                    DetailedCoachModeBanner(coachManager: coachManager)
                        .padding(.horizontal, Spacing.m)
                        .padding(.top, Spacing.s)
                }
                
                Spacer()
            }
        }
    }
    
    func floatingCoachBubble(_ coachManager: CoachModeManager) -> some View {
        ZStack {
            self
            
            FloatingCoachModeBubble(coachManager: coachManager)
        }
    }
}

enum CoachBannerStyle {
    case prominent  // Full width banner at top
    case compact    // Small pill in corner
    case detailed   // Card with more info
}

// MARK: - Usage Examples
struct CoachModeBannerExamples: View {
    @StateObject private var coachManager = CoachModeManager()
    @State private var selectedStyle: Int = 0
    
    var body: some View {
        TabView {
            // Tab 1: Prominent Banner
            ExampleHomeView()
                .coachModeBanner(coachManager, style: .prominent)
                .tabItem {
                    Label("Prominent", systemImage: "1.circle")
                }
            
            // Tab 2: Compact Banner
            ExampleHomeView()
                .coachModeBanner(coachManager, style: .compact)
                .tabItem {
                    Label("Compact", systemImage: "2.circle")
                }
            
            // Tab 3: Detailed Banner
            ExampleHomeView()
                .coachModeBanner(coachManager, style: .detailed)
                .tabItem {
                    Label("Detailed", systemImage: "3.circle")
                }
            
            // Tab 4: Floating Bubble
            ExampleHomeView()
                .floatingCoachBubble(coachManager)
                .tabItem {
                    Label("Bubble", systemImage: "4.circle")
                }
            
            // Tab 5: Controls
            ControlsView(coachManager: coachManager)
                .tabItem {
                    Label("Controls", systemImage: "gear")
                }
        }
        .environmentObject(coachManager)
    }
}

struct ExampleHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        Text("Example Content")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        ForEach(0..<10) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cardBackground)
                                .frame(height: 100)
                                .overlay(
                                    Text("Content Item \(index + 1)")
                                        .foregroundColor(.textPrimary)
                                )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct ControlsView: View {
    @ObservedObject var coachManager: CoachModeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        Text("Test Coach Mode")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        if !coachManager.isInCoachMode {
                            VStack(spacing: Spacing.m) {
                                Text("Select an athlete to view:")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                
                                ForEach(Athlete.mockAthletes) { athlete in
                                    Button(action: {
                                        withAnimation {
                                            coachManager.enterCoachMode(athlete: athlete)
                                        }
                                    }) {
                                        HStack {
                                            Text(athlete.fullName)
                                                .font(.bodyLarge)
                                                .foregroundColor(.textPrimary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.textTertiary)
                                        }
                                        .padding(Spacing.m)
                                        .background(Color.cardBackground)
                                        .cornerRadius(CornerRadius.medium)
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: Spacing.m) {
                                Text("Currently viewing:")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                
                                if let athlete = coachManager.currentAthlete {
                                    Text(athlete.fullName)
                                        .font(.titleMedium)
                                        .foregroundColor(.primaryOrange)
                                        .fontWeight(.bold)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        coachManager.exitCoachMode()
                                    }
                                }) {
                                    Text("Exit Coach Mode")
                                        .font(.bodyLarge)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.errorRed)
                                        .cornerRadius(CornerRadius.medium)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Controls")
        }
    }
}

// MARK: - Preview
#Preview("All Styles") {
    CoachModeBannerExamples()
}

#Preview("Prominent Banner") {
    let manager = CoachModeManager()
    manager.enterCoachMode(athlete: Athlete.mockAthletes[0])
    
    return ExampleHomeView()
        .coachModeBanner(manager, style: .prominent)
        .environmentObject(manager)
}

#Preview("Compact Banner") {
    let manager = CoachModeManager()
    manager.enterCoachMode(athlete: Athlete.mockAthletes[1])
    
    return ExampleHomeView()
        .coachModeBanner(manager, style: .compact)
        .environmentObject(manager)
}

#Preview("Detailed Banner") {
    let manager = CoachModeManager()
    manager.enterCoachMode(athlete: Athlete.mockAthletes[2])
    
    return ExampleHomeView()
        .coachModeBanner(manager, style: .detailed)
        .environmentObject(manager)
}

#Preview("Floating Bubble") {
    let manager = CoachModeManager()
    manager.enterCoachMode(athlete: Athlete.mockAthletes[3])
    
    return ExampleHomeView()
        .floatingCoachBubble(manager)
        .environmentObject(manager)
}
