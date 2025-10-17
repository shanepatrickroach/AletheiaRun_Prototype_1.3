//
//  RecoveryModels.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//

import Foundation

// MARK: - Recovery State
/// Tracks which step of the recovery flow the user is on
enum RecoveryStep {
    case crashDetected      // Initial notification
    case resetNotice        // Warning about sensor reset
    case sensorSelection    // Choose sensor to connect
    case recovering         // Waiting for data recovery
    case result             // Show success or failure
}

// MARK: - Sensor Model
/// Represents a nearby sensor that can be connected to
struct RecoverySensor: Identifiable {
    let id: UUID
    let name: String
    let serialNumber: String
    let batteryLevel: Int  // 0-100
    let signalStrength: SignalStrength
    let lastConnected: Date?
    
    /// Formatted battery string
    var batteryText: String {
        "\(batteryLevel)%"
    }
    
    /// Is this the sensor that was previously connected?
    var isPreviouslyConnected: Bool {
        lastConnected != nil
    }
}

// MARK: - Signal Strength
enum SignalStrength: Int {
    case weak = 1
    case fair = 2
    case good = 3
    case excellent = 4
    
    var icon: String {
        switch self {
        case .weak: return "wifi.circle"
        case .fair: return "wifi.circle.fill"
        case .good: return "antenna.radiowaves.left.and.right"
        case .excellent: return "antenna.radiowaves.left.and.right.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .weak: return "errorRed"
        case .fair: return "warningYellow"
        case .good: return "successGreen"
        case .excellent: return "successGreen"
        }
    }
    
    var title: String {
        switch self {
        case .weak: return "Weak"
        case .fair: return "Fair"
        case .good: return "Good"
        case .excellent: return "Excellent"
        }
    }
}

// MARK: - Recovery Result
/// Result of the data recovery attempt
struct RecoveryResult {
    let success: Bool
    let distance: Double?      // Recovered distance in miles
    let duration: TimeInterval? // Recovered duration in seconds
    let dataPoints: Int?       // Number of data points recovered
    let errorMessage: String?  // Error message if failed
    
    /// Formatted distance
    var formattedDistance: String? {
        guard let distance = distance else { return nil }
        return String(format: "%.2f mi", distance)
    }
    
    /// Formatted duration
    var formattedDuration: String? {
        guard let duration = duration else { return nil }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Crashed Run Info
/// Information about the run that crashed
struct CrashedRunInfo {
    let date: Date
    let estimatedDistance: Double?
    let estimatedDuration: TimeInterval?
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    var hasEstimates: Bool {
        estimatedDistance != nil || estimatedDuration != nil
    }
}

// MARK: - Recovery Manager
/// Manages the recovery flow state
class RecoveryManager: ObservableObject {
    @Published var currentStep: RecoveryStep = .crashDetected
    @Published var crashedRun: CrashedRunInfo?
    @Published var selectedSensor: RecoverySensor?
    @Published var availableSensors: [RecoverySensor] = []
    @Published var recoveryResult: RecoveryResult?
    @Published var isRecovering = false
    
    init() {
        // Simulate a crashed run from 5 minutes ago
        self.crashedRun = CrashedRunInfo(
            date: Date().addingTimeInterval(-300),
            estimatedDistance: 1.2,
            estimatedDuration: 600
        )
        
        // Generate sample sensors
        self.availableSensors = generateSampleSensors()
    }
    
    // MARK: - Flow Navigation
    
    func startRecovery() {
        currentStep = .resetNotice
    }
    
    func acknowledgeReset() {
        currentStep = .sensorSelection
    }
    
    func selectSensor(_ sensor: RecoverySensor) {
        selectedSensor = sensor
        currentStep = .recovering
        startRecoveryProcess()
    }
    
    func dismissRecovery() {
        // In real app, this would clean up and return to main app
        currentStep = .crashDetected
    }
    
    // MARK: - Recovery Process
    
    private func startRecoveryProcess() {
        isRecovering = true
        
        // Simulate recovery process (3 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isRecovering = false
            self?.completeRecovery()
        }
    }
    
    private func completeRecovery() {
        // 80% chance of success for demo
        let success = Bool.random() ? Bool.random() : true
        
        if success {
            recoveryResult = RecoveryResult(
                success: true,
                distance: 1.23,
                duration: 627,
                dataPoints: 1254,
                errorMessage: nil
            )
        } else {
            recoveryResult = RecoveryResult(
                success: false,
                distance: nil,
                duration: nil,
                dataPoints: nil,
                errorMessage: "Unable to recover data. The sensor's temporary storage may have been cleared."
            )
        }
        
        currentStep = .result
    }
    
    // MARK: - Sample Data
    
    private func generateSampleSensors() -> [RecoverySensor] {
        [
            RecoverySensor(
                id: UUID(),
                name: "Aletheia Sensor",
                serialNumber: "AL-2024-1847",
                batteryLevel: 78,
                signalStrength: .excellent,
                lastConnected: Date().addingTimeInterval(-300) // 5 min ago
            ),
            RecoverySensor(
                id: UUID(),
                name: "Aletheia Sensor",
                serialNumber: "AL-2024-2931",
                batteryLevel: 92,
                signalStrength: .good,
                lastConnected: nil
            ),
            RecoverySensor(
                id: UUID(),
                name: "Aletheia Sensor",
                serialNumber: "AL-2023-5628",
                batteryLevel: 45,
                signalStrength: .fair,
                lastConnected: Date().addingTimeInterval(-86400) // 1 day ago
            )
        ]
    }
}
