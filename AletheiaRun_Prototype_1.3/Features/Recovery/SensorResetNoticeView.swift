import SwiftUI

// MARK: - Sensor Reset Notice View
/// Warns the user that the sensor must be reset before recovery
/// Provides instructions and gets acknowledgment
struct SensorResetNoticeView: View {
    // MARK: - Properties
    @ObservedObject var recoveryManager: RecoveryManager
    @State private var hasReadInstructions = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Icon and title
                    titleSection
                    
                    // Warning message
                    warningCard
                    
                    // Instructions
                    instructionsSection
                    
                    // Important note
                    importantNote
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xl)
            }
            
            // Continue button
            continueButton
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                withAnimation {
                    recoveryManager.currentStep = .crashDetected
                }
            }) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.primaryOrange)
            }
            
            Spacer()
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.infoBlue.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "sensor.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.infoBlue)
            }
            
            Text("Sensor Reset Required")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Text("To recover your data, the sensor needs to be reset and reconnected")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Warning Card
    private var warningCard: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.titleMedium)
                .foregroundColor(.warningYellow)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Don't skip this step")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Text("Resetting the sensor is necessary to access the temporary data storage")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.warningYellow.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Instructions Section
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("How to reset your sensor:")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                InstructionStep(
                    number: 1,
                    title: "Remove the sensor",
                    description: "Take the sensor off from where it's currently attached"
                )
                
                InstructionStep(
                    number: 2,
                    title: "Press and hold",
                    description: "Press and hold the power button for 3 seconds until the LED blinks blue"
                )
                
                InstructionStep(
                    number: 3,
                    title: "Wait for reset",
                    description: "The sensor will vibrate once and the LED will turn solid green"
                )
                
                InstructionStep(
                    number: 4,
                    title: "Sensor is ready",
                    description: "The sensor is now reset and ready to reconnect"
                )
            }
            
            // Checkbox for reading instructions
            Button(action: { hasReadInstructions.toggle() }) {
                HStack(spacing: Spacing.s) {
                    Image(systemName: hasReadInstructions ? "checkmark.square.fill" : "square")
                        .font(.titleMedium)
                        .foregroundColor(hasReadInstructions ? .primaryOrange : .textTertiary)
                    
                    Text("I have reset my sensor")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
            }
            .padding(.top, Spacing.m)
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
            Image(systemName: "info.circle.fill")
                .foregroundColor(.infoBlue)
            
            Text("Data is stored temporarily on the sensor for up to 24 hours")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.s)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.cardBorder)
            
            Button(action: {
                withAnimation {
                    recoveryManager.acknowledgeReset()
                }
            }) {
                Text("Continue to Sensor Selection")
                    .font(.bodyLarge)
                    .foregroundColor(hasReadInstructions ? .backgroundBlack : .textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
                    .background(hasReadInstructions ? Color.primaryOrange : Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
            }
            .disabled(!hasReadInstructions)
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.m)
        }
        .background(Color.backgroundBlack)
    }
}

// MARK: - Instruction Step Component
struct InstructionStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            // Step number
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.backgroundBlack)
                .frame(width: 32, height: 32)
                .background(Color.primaryOrange)
                .cornerRadius(CornerRadius.small)
            
            // Content
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

// MARK: - Preview
#Preview {
    SensorResetNoticeView(recoveryManager: RecoveryManager())
}