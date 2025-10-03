//
//  FloatingActionButton.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//


import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void
    @State private var isPressed = false
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                // Outer pulse ring
                Circle()
                    .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                    .frame(width: 70, height: 70)
                    .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                    .opacity(pulseAnimation ? 0 : 1)
                
                // Main button with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryOrange, Color.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: Color.primaryOrange.opacity(0.4), radius: 12, x: 0, y: 4)
                
                // Icon
                Image(systemName: "play.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.black)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
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

#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        FloatingActionButton {
            print("Start Recording")
        }
    }
}