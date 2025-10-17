//
//  RecoveryResultView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


import SwiftUI

// MARK: - Recovery Result View
/// Shows the final result of the recovery attempt
/// Different UI for success vs failure
struct RecoveryResultView: View {
    // MARK: - Properties
    @ObservedObject var recoveryManager: RecoveryManager
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Spacer()
                        .frame(height: Spacing.xxl)
                    
                    if let result = recoveryManager.recoveryResult {
                        if result.success {
                            successView(result)
                        } else {
                            failureView(result)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.m)
            }
            
            // Action buttons
            actionButtons
        }
    }
    
    // MARK: - Success View
    private func successView(_ result: RecoveryResult) -> some View {
        VStack(spacing: Spacing.xl) {
            // Success icon with animation
            ZStack {
                Circle()
                    .fill(Color.successGreen.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.successGreen)
            }
            
            // Title
            VStack(spacing: Spacing.s) {
                Text("Recovery Successful!")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Text("Your run data has been successfully recovered")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Recovered data summary
            recoveredDataCard(result)
            
            // What's next section
            whatsNextSection
        }
    }
    
    // MARK: - Failure View
    private func failureView(_ result: RecoveryResult) -> some View {
        VStack(spacing: Spacing.xl) {
            // Failure icon
            ZStack {
                Circle()
                    .fill(Color.errorRed.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.errorRed)
            }
            
            // Title
            VStack(spacing: Spacing.s) {
                Text("Recovery Failed")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Text("Unfortunately, we couldn't recover your run data")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Error details
            if let errorMessage = result.errorMessage {
                errorCard(errorMessage)
            }
            
            // Possible reasons section
            possibleReasonsSection
            
            // Tips for next time
            tipsSection
        }
    }
    
    // MARK: - Recovered Data Card
    private func recoveredDataCard(_ result: RecoveryResult) -> some View {
        VStack(spacing: Spacing.m) {
            // Header
            HStack {
                Text("Recovered Data")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.successGreen)
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Stats grid
            HStack(spacing: Spacing.xl) {
                if let distance = result.formattedDistance {
                    RecoverRunStatColumn(
                        icon: "figure.run",
                        value: distance,
                        label: "Distance"
                    )
                }
                
                if let duration = result.formattedDuration {
                    RecoverRunStatColumn(
                        icon: "timer",
                        value: duration,
                        label: "Duration"
                    )
                }
                
                if let dataPoints = result.dataPoints {
                    RecoverRunStatColumn(
                        icon: "waveform.path.ecg",
                        value: "\(dataPoints)",
                        label: "Data Points"
                    )
                }
            }
            
            // Additional info
            HStack(spacing: Spacing.xs) {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundColor(.infoBlue)
                
                Text("Your run has been saved to your library")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, Spacing.s)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.successGreen.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Error Card
    private func errorCard(_ message: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.errorRed)
            
            Text(message)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.m)
        .background(Color.errorRed.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.errorRed.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - What's Next Section
    private var whatsNextSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("What's Next?")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                NextStepRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Review Your Run",
                    description: "Check your Force Portrait and metrics"
                )
                
                NextStepRow(
                    icon: "note.text",
                    title: "Add Notes",
                    description: "Record how you felt during the run"
                )
                
                NextStepRow(
                    icon: "figure.run",
                    title: "Continue Training",
                    description: "Start your next run when ready"
                )
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
    
    // MARK: - Possible Reasons Section
    private var possibleReasonsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Why This Might Happen")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ReasonRow(text: "Data was cleared from sensor memory")
                ReasonRow(text: "Too much time passed since the crash (>24 hours)")
                ReasonRow(text: "Sensor battery died during storage")
                ReasonRow(text: "Connection was interrupted during recovery")
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
    
    // MARK: - Tips Section
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.warningYellow)
                
                Text("Tips for Next Time")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                TipRow(text: "Keep your device charged during runs")
                TipRow(text: "Ensure sensor battery is above 20%")
                TipRow(text: "Try recovery as soon as possible after a crash")
                TipRow(text: "Keep sensor within range of your device")
            }
        }
        .padding(Spacing.m)
        .background(Color.warningYellow.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: Spacing.m) {
            Divider()
                .background(Color.cardBorder)
            
            if let result = recoveryManager.recoveryResult, result.success {
                // Success buttons
                Button(action: {
                    // Navigate to run detail
                    recoveryManager.dismissRecovery()
                }) {
                    Text("View Recovered Run")
                        .font(.bodyLarge)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.medium)
                }
                
                Button(action: {
                    recoveryManager.dismissRecovery()
                }) {
                    Text("Return to Home")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                }
            } else {
                // Failure buttons
                Button(action: {
                    // Try again
                    withAnimation {
                        recoveryManager.currentStep = .sensorSelection
                    }
                }) {
                    Text("Try Again")
                        .font(.bodyLarge)
                        .foregroundColor(.backgroundBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.medium)
                }
                
                Button(action: {
                    recoveryManager.dismissRecovery()
                }) {
                    Text("Close")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                }
            }
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
    }
}

// MARK: - Stat Column Component
struct RecoverRunStatColumn: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.titleMedium)
                .foregroundColor(.primaryOrange)
            
            Text(value)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Next Step Row Component
struct NextStepRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            Image(systemName: icon)
                .font(.titleMedium)
                .foregroundColor(.primaryOrange)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Reason Row Component
struct ReasonRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.textTertiary)
            
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Tip Row Component
struct RecoverRunTipRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "checkmark")
                .font(.caption)
                .foregroundColor(.warningYellow)
            
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Preview
#Preview("Success") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        RecoveryResultView(recoveryManager: {
            let manager = RecoveryManager()
            manager.recoveryResult = RecoveryResult(
                success: true,
                distance: 1.23,
                duration: 627,
                dataPoints: 1254,
                errorMessage: nil
            )
            return manager
        }())
    }
}

#Preview("Failure") {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        RecoveryResultView(recoveryManager: {
            let manager = RecoveryManager()
            manager.recoveryResult = RecoveryResult(
                success: false,
                distance: nil,
                duration: nil,
                dataPoints: nil,
                errorMessage: "Unable to recover data. The sensor's temporary storage may have been cleared."
            )
            return manager
        }())
    }
}
