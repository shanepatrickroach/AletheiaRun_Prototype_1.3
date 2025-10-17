//
//  SensorSettingsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/SensorSettingsView.swift

import SwiftUI


// MARK: - Sensor Settings View
struct SensorSettingsView: View {
    @State private var connectedSensors: [SensorDevice] = SensorDevice.mockSensors
    @State private var showingRenameSheet: SensorDevice?
    @State private var showingForgetAlert: SensorDevice?
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Info banner
                    infoBanner
                    
                    // Connected sensors
                    if !connectedSensors.isEmpty {
                        connectedSensorsSection
                    }
                    
                    // Add sensor button
//                    addSensorButton
                    
                    // Help section
                    helpSection
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.m)
            }
        }
        .navigationTitle("Sensor Settings")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $showingRenameSheet) { sensor in
            RenameSensorSheet(sensor: sensor) { newName in
                if let index = connectedSensors.firstIndex(where: { $0.id == sensor.id }) {
                    connectedSensors[index].name = newName
                }
            }
        }
        .alert(item: $showingForgetAlert) { sensor in
            Alert(
                title: Text("Forget Sensor?"),
                message: Text("Are you sure you want to remove \"\(sensor.name)\" from your devices?"),
                primaryButton: .destructive(Text("Forget")) {
                    connectedSensors.removeAll { $0.id == sensor.id }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - Info Banner
    private var infoBanner: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: "info.circle.fill")
                .font(.titleMedium)
                .foregroundColor(.infoBlue)
            
            Text("Manage your Aletheia sensors and customize their names for easy identification")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.infoBlue.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.infoBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Connected Sensors Section
    private var connectedSensorsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Sensors")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.m) {
                ForEach(connectedSensors) { sensor in
                    SettingsSensorCard(
                        sensor: sensor,
                        onRename: { showingRenameSheet = sensor },
                        onForget: { showingForgetAlert = sensor }
                    )
                }
            }
        }
    }
    
    // MARK: - Add Sensor Button
    private var addSensorButton: some View {
        Button(action: {
            // Add new sensor
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.titleMedium)
                
                Text("Add New Sensor")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primaryOrange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.primaryOrange.opacity(0.1))
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.primaryOrange, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Help Section
    private var helpSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Need Help?")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                HelpLinkRow(
                    icon: "book.fill",
                    title: "Sensor Setup Guide",
                    action: {}
                )
                
                HelpLinkRow(
                    icon: "questionmark.circle.fill",
                    title: "Troubleshooting",
                    action: {}
                )
                
                HelpLinkRow(
                    icon: "message.fill",
                    title: "Contact Support",
                    action: {}
                )
            }
        }
    }
}

// MARK: - Sensor Device Model
struct SensorDevice: Identifiable {
    let id: UUID
    var name: String
    let serialNumber: String
    let batteryLevel: Int
    let isConnected: Bool
    let lastConnected: Date
    
    var batteryIcon: String {
        if batteryLevel > 75 { return "battery.100" }
        else if batteryLevel > 50 { return "battery.75" }
        else if batteryLevel > 25 { return "battery.25" }
        else { return "battery.0" }
    }
    
    var batteryColor: Color {
        if batteryLevel > 50 { return .successGreen }
        else if batteryLevel > 20 { return .warningYellow }
        else { return .errorRed }
    }
    
    static let mockSensors = [
        SensorDevice(
            id: UUID(),
            name: "My Running Sensor",
            serialNumber: "AL-2024-1847",
            batteryLevel: 78,
            isConnected: true,
            lastConnected: Date()
        ),
        SensorDevice(
            id: UUID(),
            name: "Backup Sensor",
            serialNumber: "AL-2024-2931",
            batteryLevel: 45,
            isConnected: false,
            lastConnected: Date().addingTimeInterval(-86400)
        )
    ]
}

// MARK: - Sensor Card Component
struct SettingsSensorCard: View {
    let sensor: SensorDevice
    let onRename: () -> Void
    let onForget: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(sensor.isConnected ? Color.successGreen.opacity(0.2) : Color.textTertiary.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image("AletheiaIcon_Primary")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .font(.titleMedium)
                        .foregroundColor(sensor.isConnected ? .successGreen : .textTertiary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(sensor.name)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(sensor.serialNumber)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Connection status
                HStack(spacing: Spacing.xxs) {
                    Circle()
                        .fill(sensor.isConnected ? Color.successGreen : Color.textTertiary)
                        .frame(width: 8, height: 8)
                    
                    Text(sensor.isConnected ? "Connected" : "Offline")
                        .font(.caption)
                        .foregroundColor(sensor.isConnected ? .successGreen : .textTertiary)
                }
            }
            
            Divider().background(Color.cardBorder)
            
            // Details
            HStack(spacing: Spacing.xl) {
                // Battery
                HStack(spacing: Spacing.xs) {
                    Image(systemName: sensor.batteryIcon)
                        .foregroundColor(sensor.batteryColor)
                    
                    Text("\(sensor.batteryLevel)%")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                // Last connected
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "clock")
                        .foregroundColor(.textTertiary)
                    
                    Text(timeAgo(sensor.lastConnected))
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            
            Divider().background(Color.cardBorder)
            
            // Actions
            HStack(spacing: Spacing.m) {
                // Rename button
                Button(action: onRename) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Rename")
                    }
                    .font(.bodySmall)
                    .foregroundColor(.primaryOrange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.primaryOrange.opacity(0.1))
                    .cornerRadius(CornerRadius.small)
                }
                
                // Forget button
                Button(action: onForget) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Forget")
                    }
                    .font(.bodySmall)
                    .foregroundColor(.errorRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s)
                    .background(Color.errorRed.opacity(0.1))
                    .cornerRadius(CornerRadius.small)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(sensor.isConnected ? Color.successGreen.opacity(0.5) : Color.cardBorder, lineWidth: sensor.isConnected ? 2 : 1)
        )
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

// MARK: - Rename Sensor Sheet
struct RenameSensorSheet: View {
    let sensor: SensorDevice
    let onSave: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var newName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    // Sensor icon
                    ZStack {
                        Circle()
                            .fill(Color.primaryOrange.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image("AletheiaIcon_Primary")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .font(.system(size: 40))
                            
                            .foregroundColor(.primaryOrange)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Current name
                    VStack(spacing: Spacing.xs) {
                        Text("Current Name")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(sensor.name)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                    }
                    
                    // Name input
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("New Name")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        TextField("Enter sensor name", text: $newName)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(Spacing.m)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        if !newName.isEmpty {
                            onSave(newName)
                            dismiss()
                        }
                    }) {
                        Text("Save")
                            .font(.bodyLarge)
                            .foregroundColor(.backgroundBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.m)
                            .background(newName.isEmpty ? Color.textTertiary : Color.primaryOrange)
                            .cornerRadius(CornerRadius.medium)
                    }
                    .disabled(newName.isEmpty)
                    .padding(.horizontal, Spacing.m)
                    
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .padding(.vertical, Spacing.s)
                    }
                    .padding(.bottom, Spacing.xl)
                }
            }
            .navigationTitle("Rename Sensor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            newName = sensor.name
        }
    }
}

// MARK: - Help Link Row Component
struct HelpLinkRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.infoBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.small)
        }
    }
}


#Preview("Sensor") {
    NavigationView {
        SensorSettingsView()
    }
}
