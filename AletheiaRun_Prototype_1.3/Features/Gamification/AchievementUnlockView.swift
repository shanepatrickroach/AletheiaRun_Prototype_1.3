//
//  AchievementUnlockView 2.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Gamification/AchievementUnlockView.swift (NEW FILE)

import SwiftUI

struct AchievementUnlockView: View {
    @Environment(\.dismiss) private var dismiss
    let achievement: Achievement
    
    @State private var showContent = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: Spacing.xl) {
                Spacer()
                
                // Achievement Content
                VStack(spacing: Spacing.l) {
                    // Achievement Icon
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        achievement.tier.color.opacity(0.3),
                                        achievement.tier.color.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .scaleEffect(showContent ? 1.0 : 0.5)
                            .opacity(showContent ? 1.0 : 0)
                        
                        // Icon background
                        Circle()
                            .fill(achievement.tier.color.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        // Icon
                        Image(systemName: achievement.icon)
                            .font(.system(size: 60))
                            .foregroundColor(achievement.tier.color)
                    }
                    .scaleEffect(showContent ? 1.0 : 0.3)
                    .rotation3DEffect(
                        .degrees(showContent ? 0 : 180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    
                    // Text Content
                    VStack(spacing: Spacing.s) {
                        Text("Achievement Unlocked!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(achievement.tier.color)
                            .textCase(.uppercase)
                            .tracking(2)
                        
                        Text(achievement.name)
                            .font(.titleLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text(achievement.description)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xl)
                        
                        // Tier Badge
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "seal.fill")
                                .font(.system(size: 14))
                            
                            Text(achievement.tier.rawValue)
                                .font(.bodyMedium)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(achievement.tier.color)
                        .padding(.horizontal, Spacing.m)
                        .padding(.vertical, Spacing.s)
                        .background(achievement.tier.color.opacity(0.2))
                        .cornerRadius(CornerRadius.large)
                    }
                    .opacity(showContent ? 1.0 : 0)
                    .offset(y: showContent ? 0 : 50)
                }
                .padding(Spacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.xxLarge)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.xxLarge)
                                .stroke(achievement.tier.color.opacity(0.5), lineWidth: 2)
                        )
                )
                .padding(.horizontal, Spacing.l)
                
                Spacer()
                
                // Close Button
                PrimaryButton(
                    title: "Awesome!"
                    
                ) {
                    dismiss()
                }
                .padding(.horizontal, Spacing.l)
                .opacity(showContent ? 1.0 : 0)
            }
            .padding(.bottom, Spacing.xl)
            
            // Confetti Effect
            if showConfetti {
                ConfettiView(color: achievement.tier.color)
            }
        }
        .onAppear {
            // Animate entrance
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
            
            // Trigger confetti
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50, id: \.self) { index in
                    ConfettiPiece(color: color)
                        .position(
                            x: isAnimating ? CGFloat.random(in: 0...geometry.size.width) : geometry.size.width / 2,
                            y: isAnimating ? geometry.size.height + 100 : geometry.size.height / 2
                        )
                        .animation(
                            .easeOut(duration: Double.random(in: 1.0...2.0))
                            .delay(Double.random(in: 0...0.5)),
                            value: isAnimating
                        )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Confetti Piece
struct ConfettiPiece: View {
    let color: Color
    @State private var rotation: Double = 0
    
    private let shapes = ["circle.fill", "triangle.fill", "square.fill", "star.fill"]
    private let shape = ["circle.fill", "triangle.fill", "square.fill", "star.fill"].randomElement()!
    
    var body: some View {
        Image(systemName: shape)
            .font(.system(size: CGFloat.random(in: 8...16)))
            .foregroundColor(color.opacity(Double.random(in: 0.5...1.0)))
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: Double.random(in: 1...2)).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

#Preview {
    AchievementUnlockView(achievement: Achievement.sampleAchievements[0])
}
