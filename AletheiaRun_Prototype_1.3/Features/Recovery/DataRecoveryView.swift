//
//  DataRecoveryView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


import SwiftUI

// MARK: - Data Recovery View
/// Shows progress while attempting to recover run data from the sensor
/// Displays animated loading state with status messages
struct DataRecoveryView: View {
    // MARK: - Properties
    @ObservedObject var recoveryManager: RecoveryManager
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var currentMessageIndex = 0
    
    // Recovery status messages
    private let statusMessages = [
        "Connecting to sensor...",
        "Authenticating connection...",
        "Accessing temporary storage...",
        "Retrieving run data...",
        "Processing GPS coordinates...",
        "Recovering Force Portrait data...",
        "Validating data integrity...",
        "Finalizing recovery..."
    ]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Spacing.xxl) {
            Spacer()
            
            // Animated sensor icon
            animatedSensorIcon
            
            // Status text
            statusSection
            
            // Progress indicator
            progressIndicator
            
            // Sensor info
            if let sensor = recoveryManager.selectedSensor {
                sensorInfoCard(sensor)
            }
            
            // Important note
            importantNote
            
            Spacer()
        }
        .padding(.horizontal, Spacing.m)
        .onAppear {
            startAnimations()
            cycleMessages()
        }
    }
    
    // MARK: - Animated Sensor Icon
    private var animatedSensorIcon: some View {
        ZStack {
            // Outer pulse ring
            Circle()
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                .frame(width: 140, height: 140)
                .scaleEffect(pulseScale)
            
            // Middle pulse ring
            Circle()
                .stroke(Color.primaryOrange.opacity(0.2), lineWidth: 2)
                .frame(width: 120, height: 120)
                .scaleEffect(pulseScale * 0.9)
            
            // Inner circle
            Circle()
                .fill(Color.primaryOrange.opacity(0.2))
                .frame(width: 100, height: 100)
            
            // Rotating sensor icon
            Image(systemName: "sensor.fill")
                .font(.system(size: 50))
                .foregroundColor(.primaryOrange)
                .rotationEffect(.degrees(rotationAngle))
            
            // Data stream particles
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.primaryOrange)
                    .frame(width: 4, height: 4)
                    .offset(y: -60)
                    .rotationEffect(.degrees(Double(index) * 120 + rotationAngle))
            }
        }
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
        VStack(spacing: Spacing.s) {
            Text("Recovering Your Run")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Text(statusMessages[currentMessageIndex])
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .animation(.easeInOut, value: currentMessageIndex)
        }
    }
    
    // MARK: - Progress Indicator
    private var progressIndicator: some View {
        VStack(spacing: Spacing.xs) {
            // Progress dots
            HStack(spacing: Spacing.xs) {
                ForEach(0..<8) { index in
                    Circle()
                        .fill(index <= currentMessageIndex ? Color.primaryOrange : Color.cardBorder)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut.delay(Double(index) * 0.1), value: currentMessageIndex)
                }
            }
            
            // Estimated time
            Text("This may take a few moments...")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
    }
    
    // MARK: - Sensor Info Card
    private func sensorInfoCard(_ sensor: RecoverySensor) -> some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "sensor.fill")
                .foregroundColor(.primaryOrange)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Connected to:")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                Text(sensor.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(sensor.serialNumber)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Connection indicator
            HStack(spacing: Spacing.xxs) {
                Circle()
                    .fill(Color.successGreen)
                    .frame(width: 8, height: 8)
                
                Text("Connected")
                    .font(.caption)
                    .foregroundColor(.successGreen)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Important Note
    private var importantNote: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: "info.circle")
                .foregroundColor(.infoBlue)
            
            Text("Please keep the sensor nearby and don't close the app")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.s)
        .frame(maxWidth: .infinity)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
    
    // MARK: - Animations
    
    private func startAnimations() {
        // Rotation animation
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Pulse animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
    
    private func cycleMessages() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            if currentMessageIndex < statusMessages.count - 1 {
                withAnimation {
                    currentMessageIndex += 1
                }
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        DataRecoveryView(recoveryManager: {
            let manager = RecoveryManager()
            manager.selectedSensor = RecoverySensor(
                id: UUID(),
                name: "Aletheia Sensor",
                serialNumber: "AL-2024-1847",
                batteryLevel: 78,
                signalStrength: .excellent,
                lastConnected: Date()
            )
            return manager
        }())
    }
}