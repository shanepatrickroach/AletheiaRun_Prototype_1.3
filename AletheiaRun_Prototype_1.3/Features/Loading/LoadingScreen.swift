import SwiftUI

struct LoadingScreen: View {
    @State private var logoScale: CGFloat = 1.5
    @State private var logoOpacity: Double = 1.0
    @State private var pulseAnimation = false
    @State private var loadingProgress: Double = 0.0
    @State private var currentMessageIndex = 0
    @State private var rotationAngle: Double = 0
    
    // Completion handler
    var onLoadingComplete: (() -> Void)? = nil
    
    private let loadingMessages = [
        "Initializing app...",
        "Calibrating Force Portraits...",
        "Loading biomechanics engine...",
        "Preparing your dashboard...",
        "Ready to analyze your form!"
    ]
    
    var body: some View {
        ZStack {
            // Dynamic background gradient
            LinearGradient(
                colors: [
                    Color.backgroundBlack,
                    Color.cardBackground,
                    Color.cardBorder,
                    Color.backgroundBlack
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background particles
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(pulseAnimation ? 0.8 : 0.2)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: pulseAnimation
                    )
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo Section
                VStack(spacing: Spacing.xxxl) {
                    // Animated Logo
                    ZStack {
                        // Outer rotating ring
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.primaryOrange,
                                        Color.primaryOrange.opacity(0.3),
                                        Color.clear,
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 140, height: 140)
                            .rotationEffect(.degrees(rotationAngle))
                        
                        // Pulse rings
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseAnimation ? 1.5 + (Double(index) * 0.3) : 1.0)
                                .opacity(pulseAnimation ? 0 : 0.7)
                                .animation(
                                    .easeOut(duration: 2.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.4),
                                    value: pulseAnimation
                                )
                        }
                        
                        // Main logo circle with gradient
                        
                        
                        if let logoImage = UIImage(named: "LogoGradient") {
                            Image(uiImage: logoImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .opacity(logoOpacity)
                        } else {
                            // Fallback to SF Symbol if custom image not found
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .opacity(logoOpacity)
                        }
                        // Inner rotating particles
                        ForEach(0..<8) { index in
                            Circle()
                                .fill(Color.primaryOrange)
                                .frame(width: 4, height: 4)
                                .offset(x: 50)
                                .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 0.5))
                                .opacity(logoOpacity * 0.6)
                        }
                    }
                    
                    // App Name with gradient
                    VStack(spacing: Spacing.s) {
                        Text("Aletheia Run")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.primaryOrange,
                                        Color.primaryLight,
                                        Color.primaryOrange
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(logoOpacity)
                            .shadow(color: Color.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Force Portrait Technology")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .opacity(logoOpacity)
                            .tracking(2)
                    }
                }
                
                Spacer()
                
                // Loading Section
                VStack(spacing: Spacing.xl) {
                    // Loading Message with fade animation
                    Text(loadingMessages[currentMessageIndex])
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .id(currentMessageIndex)
                        .animation(.easeInOut(duration: 0.5), value: currentMessageIndex)
                    
                    // Progress Section
                    VStack(spacing: Spacing.m) {
                        // Custom Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .fill(Color.cardBackground)
                                    .frame(height: 8)
                                
                                // Progress fill with gradient
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.primaryOrange,
                                                Color.primaryLight
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * loadingProgress, height: 8)
                                    .shadow(color: Color.primaryOrange.opacity(0.6), radius: 8, x: 0, y: 0)
                            }
                        }
                        .frame(height: 8)
                        .frame(maxWidth: 280)
                        
                        // Percentage
                        Text("\(Int(loadingProgress * 100))%")
                            .font(.bodyLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryOrange)
                            .monospacedDigit()
                    }
                }
                .opacity(logoOpacity)
                
                Spacer()
                    .frame(height: Spacing.xxxxl * 2)
            }
            .padding(.horizontal, Spacing.xl)
        }
        .onAppear {
            startLoadingSequence()
        }
    }
    
    // MARK: - Animation Sequence
    
    private func startLoadingSequence() {
        // Logo entrance animation
        withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Start pulse animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            pulseAnimation = true
        }
        
        // Start rotation
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Start loading progress
        startProgressAnimation()
    }
    
    private func startProgressAnimation() {
        let totalDuration: Double = 5.0
        let steps = loadingMessages.count
        let stepDuration = totalDuration / Double(steps)
        
        for step in 0..<steps {
            let delay = stepDuration * Double(step)
            
            // Update message
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentMessageIndex = step
                }
            }
            
            // Update progress
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: stepDuration * 0.9)) {
                    loadingProgress = Double(step + 1) / Double(steps)
                }
            }
        }
        
//        // Complete loading
//        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.5) {
//            withAnimation(.easeOut(duration: 0.4)) {
//                logoOpacity = 0
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                (onLoadingComplete ?? <#default value#>)()
//            }
//        }
    }
}

#Preview {
    LoadingScreen {
        print("Loading complete!")
    }
}
