import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var gamificationManager = GamificationManager()
    @State private var selectedTab: Tab = .home
    @State private var showingPreRun = false
    @State private var showingCalendar = false
    
    enum Tab {
        case home
        case library
        case record
        case progress
        case profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            
            VStack{
                // Subscription Banner (appears at top if no subscription)
                                if case .authenticated(let user) = authManager.authState,
                                   !user.hasActiveSubscription {
                                    SubscriptionBanner()
                                }
            }
           
            // Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView(
                        onLibraryTap: { selectedTab = .library },
                        onCalendarTap: { showingCalendar = true},
                        onProgressTap: { selectedTab = .progress },
                        onStartRunTap: { showingPreRun = true }
                    )
                case .library:
                    LibraryView()
                case .record:
                    HomeView(
                        onLibraryTap: { selectedTab = .library },
                        onCalendarTap: { },
                        onProgressTap: { selectedTab = .progress },
                        onStartRunTap: { showingPreRun = true }
                    )
                case .progress:
                    ProgressView()
                case .profile:
                    ProfileView()
                }
            }
            
            // Custom Tab Bar with Center Record Button
            CenterRecordTabBar(
                selectedTab: $selectedTab,
                onRecordTap: {
                    showingPreRun = true
                }
            )
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showingPreRun) {
                    PreRunView()
            }
        .sheet(isPresented: $showingCalendar) {
                    NavigationStack {
                        SeperateCalendarView()
                    }
                }
        .environmentObject(gamificationManager)
            .sheet(isPresented: $gamificationManager.showAchievementUnlock) {
                if let achievement = gamificationManager.recentlyUnlockedAchievement {
                    AchievementUnlockView(achievement: achievement)
                }
            }
        
    }
}

// MARK: - Center Record Tab Bar
struct CenterRecordTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    let onRecordTap: () -> Void
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Tab bar background with cutout
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height: CGFloat = 84
                    let centerWidth: CGFloat = 80
                    
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: (width - centerWidth) / 2 - 20, y: 0))
                    
                    // Curve for center button
                    path.addQuadCurve(
                        to: CGPoint(x: (width + centerWidth) / 2 + 20, y: 0),
                        control: CGPoint(x: width / 2, y: -20)
                    )
                    
                    path.addLine(to: CGPoint(x: width, y: 0))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(Color.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                
                // Top border
                Path { path in
                    let width = geometry.size.width
                    let centerWidth: CGFloat = 80
                    
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: (width - centerWidth) / 2 - 20, y: 0))
                    
                    path.move(to: CGPoint(x: (width + centerWidth) / 2 + 20, y: 0))
                    path.addLine(to: CGPoint(x: width, y: 0))
                }
                .stroke(Color.cardBorder, lineWidth: 1)
            }
            .frame(height: 84)
            
            // Tab bar buttons
            HStack(spacing: 0) {
                TabBarButton(
                    icon: "house.fill",
                    title: "Home",
                    isSelected: selectedTab == .home,
                    action: { selectedTab = .home }
                )
                
                TabBarButton(
                    icon: "tray.fill",
                    title: "Library",
                    isSelected: selectedTab == .library,
                    action: { selectedTab = .library }
                )
                
                // Spacer for center button
                Spacer()
                    .frame(width: 80)
                
                TabBarButton(
                    icon: "chart.bar.fill",
                    title: "Progress",
                    isSelected: selectedTab == .progress,
                    action: { selectedTab = .progress }
                )
                
                TabBarButton(
                    icon: "person.fill",
                    title: "Profile",
                    isSelected: selectedTab == .profile,
                    action: { selectedTab = .profile }
                )
            }
            .padding(.horizontal, Spacing.xs)
            .padding(.top, Spacing.s)
            .padding(.bottom, Spacing.l)
            
            // Center Record Button
            VStack {
                Button(action: {
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    onRecordTap()
                }) {
                    ZStack {
                        // Outer pulse ring
                        Circle()
                            .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                            .frame(width: 74, height: 74)
                            .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                            .opacity(pulseAnimation ? 0 : 1)
                        
                        // Main button
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryOrange, Color.primaryLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 68, height: 68)
                            .shadow(color: Color.primaryOrange.opacity(0.5), radius: 15, x: 0, y: 5)
                        
                        // Icon
                        Image(systemName: "play.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .offset(y: -28) // Lift above tab bar
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 8)
        }
        .frame(height: 84)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                pulseAnimation = true
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .primaryOrange : .textTertiary)
                    .frame(height: 24)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primaryOrange : .textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationManager())
}
