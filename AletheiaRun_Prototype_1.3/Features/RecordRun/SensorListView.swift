//
//  SensorListView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Features/Run/SensorListView.swift

import SwiftUI

struct SensorListView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    
                    // MARK: - Bluetooth Status
                    if !bluetoothManager.isBluetoothEnabled {
                        bluetoothDisabledView
                    } else {
//                        // MARK: - Scanning Indicator
//                        if bluetoothManager.connectionState == .scanning {
//                            scanningIndicator
//                        }
                        
                        // MARK: - Sensors List
                        if bluetoothManager.availableSensors.isEmpty {
                            if bluetoothManager.connectionState == .scanning {
                                searchingView
                            } else {
                                noSensorsView
                            }
                        } else {
                            sensorsList
                        }
                    }
                    
                    
                    
                    Spacer()
                }
                .padding(Spacing.m)
            }
            .navigationTitle("Connect Sensor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        bluetoothManager.stopScanning()
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if bluetoothManager.isBluetoothEnabled {
                        Button(action: {
                            bluetoothManager.startScanning()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.clockwise")
                                Text("Scan")
                            }
                            .foregroundColor(.primaryOrange)
                        }
                        .disabled(bluetoothManager.connectionState == .scanning)
                    }
                }
            }
        }
    }
    
    // MARK: - Bluetooth Disabled View
    private var bluetoothDisabledView: some View {
        VStack(spacing: Spacing.l) {
            Image(systemName: "bluetooth.slash")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text("Bluetooth is Off")
                .font(Font.titleMedium)
                .foregroundColor(.textPrimary)
            
            Text("Please enable Bluetooth in Settings to connect to your sensor")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            Button(action: {
                if let url = URL(string: "App-Prefs:root=Bluetooth") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Open Settings")
                    .font(Font.bodyMedium)
                    .foregroundColor(.primaryOrange)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.m)
                    .background(Color.primaryOrange.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Scanning Indicator
    private var scanningIndicator: some View {
        HStack(spacing: Spacing.m) {
            RotatingArc()
                .tint(.primaryOrange)
            
            Text("Scanning for sensors...")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    // MARK: - Searching View
    private var searchingView: some View {
        VStack(spacing: Spacing.l) {
            RotatingArc()
                .tint(.primaryOrange)
            
            Text("Looking for sensors nearby...")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - No Sensors View
    private var noSensorsView: some View {
        VStack(spacing: Spacing.l) {
            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text("No Sensors Found")
                .font(Font.titleMedium)
                .foregroundColor(.textPrimary)
            
            Text("Make sure your sensor is:\n• Powered on\n• Within range\n• Not connected to another device")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            Button(action: {
                bluetoothManager.startScanning()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Scan Again")
                }
                .font(Font.bodyMedium)
                .foregroundColor(.primaryOrange)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.m)
                .background(Color.primaryOrange.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Sensors List
    private var sensorsList: some View {
        ScrollView {
            VStack(spacing: Spacing.m) {
                Text("Available Sensors")
                    .font(Font.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(bluetoothManager.availableSensors) { sensor in
                    SensorRow(
                        sensor: sensor,
                        isConnecting: bluetoothManager.connectionState == .connecting,
                        onConnect: {
                            bluetoothManager.connect(to: sensor)
                            
                            // Dismiss after successful connection
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                if bluetoothManager.connectionState == .connected {
                                    dismiss()
                                }
                            }
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Sensor Row
struct SensorRow: View {
    let sensor: RunningSensor
    let isConnecting: Bool
    let onConnect: () -> Void
    
    var body: some View {
        Button(action: onConnect) {
            HStack(spacing: Spacing.m) {
                // Sensor Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "sensor.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
                
                // Sensor Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(sensor.name)
                        .font(Font.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: Spacing.s) {
                        // Signal Strength
                        signalStrengthIndicator
                        
//                        // Battery Level
//                        if let battery = sensor.batteryLevel {
//                            Text("•")
//                                .foregroundColor(.textTertiary)
//                            
//                            HStack(spacing: 4) {
//                                Image(systemName: "battery.100")
//                                    .foregroundColor(.textTertiary)
//                                Text("\(battery)%")
//                            }
//                            .font(Font.caption)
//                            .foregroundColor(.textSecondary)
//                        }
                    }
                }
                
                Spacer()
                
                // Connect Button or Status
                if sensor.isConnected {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.successGreen)
                            .frame(width: 8, height: 8)
                        
                        Text("Connected")
                            .font(Font.caption)
                            .foregroundColor(.successGreen)
                    }
                } else if isConnecting {
                    RotatingArc(size: 20)
                        
                        .tint(.primaryOrange)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(sensor.isConnected ? Color.successGreen.opacity(0.3) : Color.cardBorder, lineWidth: sensor.isConnected ? 2 : 1)
            )
        }
        .disabled(sensor.isConnected || isConnecting)
    }
    
    private var signalStrengthIndicator: some View {
        HStack(spacing: 2) {
            ForEach(0..<signalBars, id: \.self) { _ in
                Rectangle()
                    .fill(signalColor)
                    .frame(width: 3, height: 8)
            }
            ForEach(0..<(4 - signalBars), id: \.self) { _ in
                Rectangle()
                    .fill(Color.textTertiary.opacity(0.3))
                    .frame(width: 3, height: 8)
            }
        }
    }
    
    private var signalBars: Int {
        // RSSI ranges: -30 to -90 (higher is better)
        switch sensor.rssi {
        case -30 ... -1: return 4
        case -50 ..< -30: return 3
        case -70 ..< -50: return 2
        case -90 ..< -70: return 1
        default: return 0
        }
    }
    
    private var signalColor: Color {
        switch signalBars {
        case 4: return .successGreen
        case 3: return .successGreen
        case 2: return .warningYellow
        default: return .errorRed
        }
    }
}

#Preview {
    SensorListView(bluetoothManager: BluetoothManager())
}
