import SwiftUI

// MARK: - Crash Detected View
/// Initial screen that notifies the user about a crashed run
/// Gives them the option to recover or dismiss
struct CrashDetectedView: View {
    // MARK: - Properties
    @ObservedObject var recoveryManager: RecoveryManager
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Spacing.xxl) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.warningYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.warningYellow)
            }
            
            // Title and message
            VStack(spacing: Spacing.m) {
                Text("Run Interrupted")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                
                Text("It looks like the app stopped unexpectedly during your last run. Would you like to try to recover your data?")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            // Run info card (if available)
            if let crashedRun = recoveryManager.crashedRun,
               crashedRun.hasEstimates {
                crashedRunInfoCard(crashedRun)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: Spacing.m) {
                // Recover button
                Button(action: {
                    withAnimation {
                        recoveryManager.startRecovery()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Recover Run Data")
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.backgroundBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(Color.primaryOrange)
                    .cornerRadius(CornerRadius.medium)
                }
                
                // Dismiss button
                Button(action: {
                    recoveryManager.dismissRecovery()
                }) {
                    Text("Skip Recovery")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s)
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.bottom, Spacing.xl)
        }
    }
    
    // MARK: - Crashed Run Info Card
    private func crashedRunInfoCard(_ crashedRun: CrashedRunInfo) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Incomplete Run")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            HStack(spacing: Spacing.xl) {
                // Date
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Started")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                    
                    Text(crashedRun.formattedDate)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                // Distance estimate
                if let distance = crashedRun.estimatedDistance {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Estimated")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        
                        Text(String(format: "~%.2f mi", distance))
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Duration estimate
                if let duration = crashedRun.estimatedDuration {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Duration")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        
                        let minutes = Int(duration) / 60
                        Text("~\(minutes) min")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, Spacing.m)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        CrashDetectedView(recoveryManager: RecoveryManager())
    }
}