import SwiftUI

// MARK: - Recovery Flow Coordinator
/// Main coordinator that manages the entire recovery flow
/// Shows different screens based on the current step
struct RecoveryFlowCoordinator: View {
    // MARK: - Properties
    @StateObject private var recoveryManager = RecoveryManager()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            // Show different views based on current step
            Group {
                switch recoveryManager.currentStep {
                case .crashDetected:
                    CrashDetectedView(recoveryManager: recoveryManager)
                    
                case .resetNotice:
                    SensorResetNoticeView(recoveryManager: recoveryManager)
                    
                case .sensorSelection:
                    SensorSelectionView(recoveryManager: recoveryManager)
                    
                case .recovering:
                    DataRecoveryView(recoveryManager: recoveryManager)
                    
                case .result:
                    RecoveryResultView(recoveryManager: recoveryManager)
                }
            }
            .transition(.opacity)
            .animation(.easeInOut, value: recoveryManager.currentStep)
        }
    }
}

// MARK: - Preview
#Preview {
    RecoveryFlowCoordinator()
}