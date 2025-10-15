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
        .cornerRadius(