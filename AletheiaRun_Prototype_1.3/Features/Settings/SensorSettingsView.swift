//
//  SensorSettingsView.swift (SIMPLIFIED VERSION)
//  AletheiaRun_Prototype_1.3
//
//  Updated by AI Assistant
//

import SwiftUI

// MARK: - Sensor Settings View
struct SensorSettingsView: View {
    @State private var connectedSensors: [SensorDevice] = SensorDevice.mockSensors
    @State private var showingRenameSheet: SensorDevice?
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Connected sensors
                    if !connectedSensors.isEmpty {
                        connectedSensorsSection
                    }
                    
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
    }
    
    // MARK: - Connected Sensors Section
    private var connectedSensorsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("My Sensors")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                ForEach(connectedSensors) { sensor in
                    SimpleSensorCard(
                        sensor: sensor,
                        onRename: { showingRenameSheet = sensor }
                    )
                }
            }
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

// MARK: - Simple Sensor Card Component (NEW - SIMPLIFIED)
struct SimpleSensorCard: View {
    let sensor: SensorDevice
    let onRename: () -> Void
    
    var body: some View {
        Button(action: onRename) {
            HStack(spacing: Spacing.m) {
                // Sensor icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "sensor")
                        .font(.title3)
                        .foregroundColor(.primaryOrange)
                }
                
                // Sensor info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(sensor.name)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(sensor.serialNumber)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Edit icon
                Image(systemName: "pencil.circle.fill")
                    .font(.title3)
                    .foregroundColor(.primaryOrange)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
                        
                        Image(systemName: "sensor")
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
