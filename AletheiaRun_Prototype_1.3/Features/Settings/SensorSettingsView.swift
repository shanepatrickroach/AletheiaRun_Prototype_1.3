//
//  SensorSettingsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/SensorSettingsView.swift

import SwiftUI

struct SensorSettingsView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var autoConnect = true
    @State private var batteryAlerts = true
    @State private var calibrationReminders = true
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "sensor.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryOrange)
                        
                        Text("Sensor Settings")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Manage your Aletheia sensor")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Connected Sensor
                    if let sensor = bluetoothManager.connectedSensor {
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            Text("Connected Sensor")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.m)
                            
                            ConnectedSensorCard(
                                sensor: sensor,
                                onDisconnect: {
                                    bluetoothManager.disconnect()
                                },
                                onRefreshBattery: {
                                    bluetoothManager.updateBatteryLevel()
                                }
                            )
                            .padding(.horizontal, Spacing.m)
                        }
                    } else {
                        // Connect Sensor Button
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            Text("Sensor Connection")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.m)
                            
                            Button(action: {
                                // Navigate to sensor pairing
                            }) {
                                HStack {
                                    Image(systemName: "sensor.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primaryOrange)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Connect Sensor")
                                            .font(.bodyLarge)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text("Pair your Aletheia sensor")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.textTertiary)
                                }
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.medium)
                            }
                            .padding(.horizontal, Spacing.m)
                        }
                    }
                    
                    // Sensor Preferences
                    SettingsToggleSection(title: "Preferences") {
                        SettingsToggle(
                            icon: "link",
                            title: "Auto-Connect",
                            description: "Automatically connect to your sensor",
                            isOn: $autoConnect
                        )
                        
                        SettingsToggle(
                            icon: "battery.25",
                            title: "Battery Alerts",
                            description: "Notify when battery is below 20%",
                            isOn: $batteryAlerts
                        )
                        
                        SettingsToggle(
                            icon: "gyroscope",
                            title: "Calibration Reminders",
                            description: "Remind to calibrate before runs",
                            isOn: $calibrationReminders
                        )
                    }
                    
                    // Sensor Info
                    SettingsSection(title: "Sensor Information") {
                        SettingsActionRow(
                            icon: "info.circle",
                            title: "Sensor Guide",
                            description: "Learn how to use your sensor",
                            action: { }
                        )
                        
                        SettingsActionRow(
                            icon: "arrow.triangle.2.circlepath",
                            title: "Firmware Update",
                            description: "Check for sensor updates",
                            action: { }
                        )
                    }
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("Sensor Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SensorSettingsView()
    }
}