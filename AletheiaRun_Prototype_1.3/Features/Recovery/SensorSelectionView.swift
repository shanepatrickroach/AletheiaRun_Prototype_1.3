import SwiftUI

// MARK: - Sensor Selection View
/// Shows a list of available sensors in the area
/// User selects which sensor to connect to for recovery
struct SensorSelectionView: View {
    // MARK: - Properties
    @ObservedObject var recoveryManager: RecoveryManager
    @State private var isScanning = true
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Content
            if recoveryManager.availableSensors.isEmpty && isScanning {
                scanningView
            } else if recoveryManager.availableSensors.isEmpty {
                noSensorsView
            } else {
                sensorListView
            }
        }
        .onAppear {
            // Simulate scanning for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isScanning = false
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Back button
            HStack {
                Button(action: {
                    withAnimation {
                        recoveryManager.currentStep = .resetNotice
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
            
            // Title
            Text("Select Sensor")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Text("Choose the sensor you want to recover data from")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.backgroundBlack)
    }
    
    // MARK: - Scanning View
    private var scanningView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // Scanning animation
            ZStack {
                Circle()
                    .stroke(Color.primaryOrange.opacity(0.2), lineWidth: 2)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.primaryOrange, lineWidth: 3)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(isScanning ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1.5)
                            .repeatForever(autoreverses: false),
                        value: isScanning
                    )
                
                Image(systemName: "sensor.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(spacing: Spacing.s) {
                Text("Scanning for sensors...")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("Make sure your sensor is powered on and nearby")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            Spacer()
        }
    }
    
    // MARK: - No Sensors View
    private var noSensorsView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "sensor.slash")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: Spacing.s) {
                Text("No Sensors Found")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("Make sure your sensor is:\n• Powered on\n• Within range\n• Reset and ready to connect")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            Spacer()
            
            // Retry button
            Button(action: {
                withAnimation {
                    isScanning = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isScanning = false
                    }
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Scan Again")
                }
                .font(.bodyLarge)
                .foregroundColor(.backgroundBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.m)
                .background(Color.primaryOrange)
                .cornerRadius(CornerRadius.medium)
            }
            .padding(.horizontal, Spacing.m)
            .padding(.bottom, Spacing.xl)
        }
    }
    
    // MARK: - Sensor List View
    private var sensorListView: some View {
        ScrollView {
            VStack(spacing: Spacing.m) {
                // Info banner
                infoBanner
                
                // Sensors list
                ForEach(recoveryManager.availableSensors) { sensor in
                    SensorCard(sensor: sensor) {
                        withAnimation {
                            recoveryManager.selectSensor(sensor)
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, Spacing.m)
        }
    }
    
    // MARK: - Info Banner
    private var infoBanner: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.infoBlue)
            
            Text("Tap the sensor you were using during your run")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.s)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

// MARK: - Sensor Card Component
struct SensorCard: View {
    let sensor: RecoverySensor
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: Spacing.m) {
                HStack(spacing: Spacing.m) {
                    // Sensor icon
                    ZStack {
                        Circle()
                            .fill(Color.primaryOrange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "sensor.fill")
                            .font(.titleMedium)
                            .foregroundColor(.primaryOrange)
                    }
                    
                    // Sensor info
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        HStack(spacing: Spacing.xs) {
                            Text(sensor.name)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .fontWeight(.semibold)
                            
                            // Previously connected badge
                            if sensor.isPreviouslyConnected {
                                Text("Last Used")
                                    .font(.caption)
                                    .foregroundColor(.successGreen)
                                    .padding(.horizontal, Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(Color.successGreen.opacity(0.15))
                                    .cornerRadius(CornerRadius.small)
                            }
                        }
                        
                        Text(sensor.serialNumber)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.bodySmall)
                        .foregroundColor(.textTertiary)
                }
                
                Divider()
                    .background(Color.cardBorder)
                
                // Sensor details
                HStack(spacing: Spacing.xl) {
                    // Battery
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: batteryIcon(sensor.batteryLevel))
                            .foregroundColor(batteryColor(sensor.batteryLevel))
                        
                        Text(sensor.batteryText)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    // Signal strength
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: sensor.signalStrength.icon)
                            .foregroundColor(signalColor(sensor.signalStrength))
                        
                        Text(sensor.signalStrength.title)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Last connected
                    if let lastConnected = sensor.lastConnected {
                        Text(timeAgo(lastConnected))
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        sensor.isPreviouslyConnected ? Color.primaryOrange.opacity(0.5) : Color.cardBorder,
                        lineWidth: sensor.isPreviouslyConnected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Functions
    
    private func batteryIcon(_ level: Int) -> String {
        if level > 75 { return "battery.100" }
        else if level > 50 { return "battery.75" }
        else if level > 25 { return "battery.25" }
        else { return "battery.0" }
    }
    
    private func batteryColor(_ level: Int) -> Color {
        if level > 50 { return .successGreen }
        else if level > 20 { return .warningYellow }
        else { return .errorRed }
    }
    
    private func signalColor(_ strength: SignalStrength) -> Color {
        switch strength {
        case .weak: return .errorRed
        case .fair: return .warningYellow
        case .good, .excellent: return .successGreen
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let days = seconds / 86400
            return "\(days)d ago"
        }
    }
}

// MARK: - Preview
#Preview("With Sensors") {
    SensorSelectionView(recoveryManager: RecoveryManager())
}

#Preview("Scanning") {
    SensorSelectionView(recoveryManager: {
        let manager = RecoveryManager()
        manager.availableSensors = []
        return manager
    }())
}
