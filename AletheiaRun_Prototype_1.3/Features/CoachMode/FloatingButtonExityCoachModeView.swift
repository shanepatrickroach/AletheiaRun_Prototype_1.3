//
//  FloatingButtonExityCoachModeView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/30/25.
//

import SwiftUI

struct FloatingButtonExityCoachModeView: View {
    
    
    var body: some View {
        
        ZStack() {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack() {
                CoachModeExitBanner()
                
                ExampleHomeView()
            }
        }
        
    }
}



struct CoachModeExitBanner: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        
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
                    
                    Text("Viewing Joe")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Exit button
                Button(action: {
                    withAnimation {
                        
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

#Preview {FloatingButtonExityCoachModeView()}


