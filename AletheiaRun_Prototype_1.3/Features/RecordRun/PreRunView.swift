//
//  PreRunView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Features/Run/PreRunView.swift

import SwiftUI

struct PreRunView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var selectedMode: RunMode = .run
    @State private var selectedTerrain: TerrainType = .road
    @State private var showingSensorList = false
    @State private var showingConfirmation = false
    @State private var navigateToActiveRun = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // MARK: - Sensor Connection Section
                    sensorConnectionSection
                    
                    // MARK: - Run Mode Selection
                    runModeSection
                    
                    // MARK: - Terrain Selection
                    terrainSection
                    
                    // MARK: - Start Button
                    if bluetoothManager.connectedSensor == nil {
                        PrimaryButton(
                            title: "Continue"
                            
                        ) {
                            showingConfirmation = true
                        }
                        .padding(.top, Spacing.m)
                    }
                }
                .padding(Spacing.m)
            }
            .background(Color.backgroundBlack)
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            .sheet(isPresented: $showingSensorList) {
                SensorListView(bluetoothManager: bluetoothManager)
            }
            .sheet(isPresented: $showingConfirmation) {
                PreRunConfirmationView(
                    configuration: RunConfiguration(
                        mode: selectedMode,
                        terrain: selectedTerrain,
                        sensorConnected: bluetoothManager.connectedSensor != nil,
                        sensorBattery: bluetoothManager.connectedSensor?.batteryLevel
                    ),
                    onConfirm: {
                        showingConfirmation = false
                        navigateToActiveRun = true
                    }
                )
            }
            .navigationDestination(isPresented: $navigateToActiveRun) {
                ActiveRunView(
                    configuration: RunConfiguration(
                        mode: selectedMode,
                        terrain: selectedTerrain,
                        sensorConnected: bluetoothManager.connectedSensor != nil,
                        sensorBattery: bluetoothManager.connectedSensor?.batteryLevel
                    ),
                    bluetoothManager: bluetoothManager
                )
            }
        }
    }
    
    // MARK: - Sensor Connection Section
    private var sensorConnectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Sensor")
                .font(Font.titleMedium)
                .foregroundColor(.textPrimary)
            
            if let sensor = bluetoothManager.connectedSensor {
                // Connected Sensor Card
                ConnectedSensorCard(
                    sensor: sensor,
                    onDisconnect: {
                        bluetoothManager.disconnect()
                    },
                    onRefreshBattery: {
                        bluetoothManager.updateBatteryLevel()
                    }
                )
            } else {
                // Connect Sensor Button
                Button(action: {
                    showingSensorList = true
                    bluetoothManager.startScanning()
                }) {
                    HStack {
                        Image(systemName: "sensor.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryOrange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Connect Sensor")
                                .font(Font.bodyLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("Tap to scan for nearby sensors")
                                .font(Font.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // MARK: - Run Mode Section
    private var runModeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Session Type")
                .font(Font.titleMedium)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.s) {
                ForEach(RunMode.allCases, id: \.self) { mode in
                    SelectionCard(
                        icon: mode.icon,
                        title: mode.rawValue,
                        description: mode.description,
                        isSelected: selectedMode == mode
                    ) {
                        selectedMode = mode
                    }
                }
            }
        }
    }
    
    // MARK: - Terrain Section
    private var terrainSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Terrain")
                .font(Font.titleMedium)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.s) {
                ForEach(TerrainType.allCases, id: \.self) { terrain in
                    SelectionCard(
                        icon: terrain.icon,
                        title: terrain.rawValue,
                        description: terrain.description,
                        isSelected: selectedTerrain == terrain
                    ) {
                        selectedTerrain = terrain
                    }
                }
            }
        }
    }
}

// MARK: - Connected Sensor Card
struct ConnectedSensorCard: View {
    let sensor: RunningSensor
    let onDisconnect: () -> Void
    let onRefreshBattery: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            HStack {
                // Sensor Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "sensor.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(sensor.name)
                            .font(Font.bodyLarge)
                            .foregroundColor(.textPrimary)
                        
                        // Connected indicator
                        Circle()
                            .fill(Color.successGreen)
                            .frame(width: 8, height: 8)
                    }
                    
                    Text("Connected")
                        .font(Font.caption)
                        .foregroundColor(.successGreen)
                }
                
                Spacer()
                
                Button(action: onDisconnect) {
                    Text("Disconnect")
                        .font(Font.caption)
                        .foregroundColor(.errorRed)
                }
            }
            
            Divider()
                .background(Color.cardBorder)
            
            // Battery Level
            HStack {
                Image(systemName: batteryIcon)
                    .foregroundColor(batteryColor)
                
                Text("Battery")
                    .font(Font.bodyMedium)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if let battery = sensor.batteryLevel {
                    Text("\(battery)%")
                        .font(Font.bodyLarge)
                        .foregroundColor(.textPrimary)
                } else {
                    Button(action: onRefreshBattery) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise")
                            Text("Check")
                        }
                        .font(Font.caption)
                        .foregroundColor(.primaryOrange)
                    }
                }
            }
            
            // Low battery warning
            if let battery = sensor.batteryLevel, battery < 20 {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.warningYellow)
                    
                    Text("Low battery - Consider charging your sensor")
                        .font(Font.caption)
                        .foregroundColor(.warningYellow)
                }
                .padding(Spacing.s)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.warningYellow.opacity(0.1))
                .cornerRadius(CornerRadius.small)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.successGreen.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var batteryIcon: String {
        guard let battery = sensor.batteryLevel else { return "battery.0" }
        
        switch battery {
        case 75...100: return "battery.100"
        case 50..<75: return "battery.75"
        case 25..<50: return "battery.50"
        case 10..<25: return "battery.25"
        default: return "battery.0"
        }
    }
    
    private var batteryColor: Color {
        guard let battery = sensor.batteryLevel else { return .textTertiary }
        
        if battery < 20 { return .errorRed }
        if battery < 50 { return .warningYellow }
        return .successGreen
    }
}

// MARK: - Selection Card
struct SelectionCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title)
                    .font(Font.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(Font.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    PreRunView()
}
