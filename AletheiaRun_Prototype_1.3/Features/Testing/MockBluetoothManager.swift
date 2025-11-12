//
//  MockBluetoothManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/7/25.
//


//
//  MockBluetoothManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//  Mock Bluetooth Manager for Testing Different Sensor States
//

import Foundation
import CoreBluetooth
import Combine
import SwiftUI

// MARK: - Mock Bluetooth Manager
class MockBluetoothManager: BluetoothManager {
    
    // Test scenarios
    enum TestScenario {
        case bluetoothOff           // Bluetooth disabled
        case scanning               // Currently scanning
        case noSensorsFound         // Scan complete, no sensors
        case multipleSensors        // Multiple sensors found
        case connecting             // Connecting to sensor
        case connected              // Successfully connected
        case connectionFailed       // Connection failed
        case weakSignal            // Sensors with weak signal
        case lowBattery            // Sensors with low battery
    }
    
    // Current test scenario
    var currentScenario: TestScenario = .multipleSensors {
        didSet {
            updateStateForScenario()
        }
    }
    
    // MARK: - Initialization
    override init() {
        super.init()
        // Set initial state
        updateStateForScenario()
    }
    
    // MARK: - Update State Based on Scenario
    private func updateStateForScenario() {
        switch currentScenario {
        case .bluetoothOff:
            isBluetoothEnabled = false
            connectionState = .disconnected
            availableSensors = []
            connectedSensor = nil
            
        case .scanning:
            isBluetoothEnabled = true
            connectionState = .scanning
            availableSensors = []
            connectedSensor = nil
            
        case .noSensorsFound:
            isBluetoothEnabled = true
            connectionState = .disconnected
            availableSensors = []
            connectedSensor = nil
            
        case .multipleSensors:
            isBluetoothEnabled = true
            connectionState = .disconnected
            availableSensors = mockSensors
            connectedSensor = nil
            
        case .connecting:
            isBluetoothEnabled = true
            connectionState = .connecting
            availableSensors = mockSensors
            connectedSensor = nil
            
        case .connected:
            isBluetoothEnabled = true
            connectionState = .connected
            availableSensors = mockSensors
            let sensor = mockSensors.first!
            var connectedSensorCopy = sensor
            connectedSensorCopy.isConnected = true
            connectedSensor = connectedSensorCopy
            
            // Mark first sensor as connected
            if !availableSensors.isEmpty {
                availableSensors[0].isConnected = true
            }
            
        case .connectionFailed:
            isBluetoothEnabled = true
            connectionState = .failed(BluetoothError.connectionFailed)
            availableSensors = mockSensors
            connectedSensor = nil
            
        case .weakSignal:
            isBluetoothEnabled = true
            connectionState = .disconnected
            availableSensors = weakSignalSensors
            connectedSensor = nil
            
        case .lowBattery:
            isBluetoothEnabled = true
            connectionState = .disconnected
            availableSensors = lowBatterySensors
            connectedSensor = nil
        }
    }
    
    // MARK: - Override Methods for Testing
    
    override func startScanning() {
        connectionState = .scanning
        availableSensors = []
        
        // Simulate scanning delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            // Return to previous state after scan
            if self.currentScenario == .noSensorsFound {
                self.connectionState = .disconnected
                self.availableSensors = []
            } else if self.currentScenario == .multipleSensors {
                self.connectionState = .disconnected
                self.availableSensors = self.mockSensors
            }
        }
    }
    
    override func stopScanning() {
        if connectionState == .scanning {
            connectionState = .disconnected
        }
    }
    
    override func connect(to sensor: RunningSensor) {
        connectionState = .connecting
        
        // Simulate connection delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            if self.currentScenario == .connectionFailed {
                self.connectionState = .failed(BluetoothError.connectionFailed)
            } else {
                self.connectionState = .connected
                var connectedSensorCopy = sensor
                connectedSensorCopy.isConnected = true
                self.connectedSensor = connectedSensorCopy
                
                // Mark sensor as connected in list
                if let index = self.availableSensors.firstIndex(where: { $0.id == sensor.id }) {
                    self.availableSensors[index].isConnected = true
                }
            }
        }
    }
    
    override func disconnect() {
        connectedSensor = nil
        connectionState = .disconnected
        
        // Mark all sensors as disconnected
        for index in availableSensors.indices {
            availableSensors[index].isConnected = false
        }
    }
    
    // MARK: - Mock Sensor Data
    
    private var mockSensors: [RunningSensor] {
        [
            RunningSensor(
                id: UUID(),
                name: "Aletheia Sensor Pro",
                rssi: -35,
                batteryLevel: 85,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Aletheia Sensor Mini",
                rssi: -45,
                batteryLevel: 62,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "My Running Sensor",
                rssi: -55,
                batteryLevel: 98,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Coach's Sensor",
                rssi: -42,
                batteryLevel: 71,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Backup Sensor",
                rssi: -65,
                batteryLevel: 45,
                isConnected: false,
                peripheral: nil
            )
        ]
    }
    
    private var weakSignalSensors: [RunningSensor] {
        [
            RunningSensor(
                id: UUID(),
                name: "Distant Sensor",
                rssi: -85,
                batteryLevel: 50,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Far Away Sensor",
                rssi: -92,
                batteryLevel: 70,
                isConnected: false,
                peripheral: nil
            )
        ]
    }
    
    private var lowBatterySensors: [RunningSensor] {
        [
            RunningSensor(
                id: UUID(),
                name: "Low Battery Sensor",
                rssi: -40,
                batteryLevel: 8,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Dying Sensor",
                rssi: -45,
                batteryLevel: 3,
                isConnected: false,
                peripheral: nil
            ),
            RunningSensor(
                id: UUID(),
                name: "Critical Battery",
                rssi: -38,
                batteryLevel: 1,
                isConnected: false,
                peripheral: nil
            )
        ]
    }
}

// MARK: - Test Scenario Selector View
struct SensorTestScenarioSelector: View {
    @ObservedObject var mockManager: MockBluetoothManager
    @State private var showingSensorList = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.m) {
                        Text("Select Test Scenario")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                            .padding(.top, Spacing.xl)
                        
                        Text("Choose a scenario to test different sensor states")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.l)
                            .padding(.bottom, Spacing.m)
                        
                        // Scenario buttons
                        VStack(spacing: Spacing.s) {
                            ScenarioButton(
                                title: "Bluetooth Off",
                                description: "Tests when Bluetooth is disabled",
                                icon: "bluetooth.slash",
                                color: .errorRed,
                                action: {
                                    mockManager.currentScenario = .bluetoothOff
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Scanning",
                                description: "Shows scanning animation",
                                icon: "arrow.clockwise",
                                color: .primaryOrange,
                                action: {
                                    mockManager.currentScenario = .scanning
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "No Sensors Found",
                                description: "Tests empty state after scan",
                                icon: "magnifyingglass",
                                color: .textSecondary,
                                action: {
                                    mockManager.currentScenario = .noSensorsFound
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Multiple Sensors",
                                description: "Shows list of 5 sensors",
                                icon: "sensor.fill",
                                color: .successGreen,
                                action: {
                                    mockManager.currentScenario = .multipleSensors
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Connecting",
                                description: "Shows connection in progress",
                                icon: "ellipsis",
                                color: .warningYellow,
                                action: {
                                    mockManager.currentScenario = .connecting
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Connected",
                                description: "Shows connected sensor",
                                icon: "checkmark.circle.fill",
                                color: .successGreen,
                                action: {
                                    mockManager.currentScenario = .connected
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Connection Failed",
                                description: "Tests failed connection state",
                                icon: "xmark.circle.fill",
                                color: .errorRed,
                                action: {
                                    mockManager.currentScenario = .connectionFailed
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Weak Signal",
                                description: "Shows sensors with poor signal",
                                icon: "wifi.slash",
                                color: .warningYellow,
                                action: {
                                    mockManager.currentScenario = .weakSignal
                                    showingSensorList = true
                                }
                            )
                            
                            ScenarioButton(
                                title: "Low Battery",
                                description: "Shows sensors with low battery",
                                icon: "battery.25",
                                color: .errorRed,
                                action: {
                                    mockManager.currentScenario = .lowBattery
                                    showingSensorList = true
                                }
                            )
                        }
                        .padding(.horizontal, Spacing.m)
                    }
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationTitle("Sensor Testing")
            .sheet(isPresented: $showingSensorList) {
                SensorListView(bluetoothManager: mockManager)
            }
        }
    }
}

// MARK: - Scenario Button Component
struct ScenarioButton: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(title)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
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
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview Provider
#Preview("Test Scenario Selector") {
    SensorTestScenarioSelector(mockManager: MockBluetoothManager())
}

#Preview("Bluetooth Off") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .bluetoothOff
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("Scanning") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .scanning
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("No Sensors") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .noSensorsFound
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("Multiple Sensors") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .multipleSensors
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("Connected") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .connected
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("Weak Signal") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .weakSignal
    return SensorListView(bluetoothManager: mockManager)
}

#Preview("Low Battery") {
    let mockManager = MockBluetoothManager()
    mockManager.currentScenario = .lowBattery
    return SensorListView(bluetoothManager: mockManager)
}
