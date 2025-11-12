//
//  BluetoothManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//

// Models/BluetoothManager.swift

import Foundation
import CoreBluetooth
import Combine

// MARK: - Sensor Model
struct RunningSensor: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int // Signal strength
    var batteryLevel: Int? // 0-100
    var isConnected: Bool
    var peripheral: CBPeripheral?
    
    
    
    static let mockSensors = [
        RunningSensor(
            id: UUID(),
            name: "My Running Sensor",
            rssi: 80,
        
            batteryLevel: 78,
            isConnected: true,
            peripheral: nil
            
        ),
        RunningSensor(
            id: UUID(),
            name: "Backup Sensor",
            
            rssi: 80,
            batteryLevel: 45,
            isConnected: false,
            peripheral: nil
        )
    ]
}

// MARK: - Connection State
enum SensorConnectionState: Equatable {
    case disconnected
    case scanning
    case connecting
    case connected
    case failed(Error)
    
    static func == (lhs: SensorConnectionState, rhs: SensorConnectionState) -> Bool {
            switch (lhs, rhs) {
            case (.disconnected, .disconnected),
                 (.scanning, .scanning),
                 (.connecting, .connecting),
                 (.connected, .connected):
                return true
            case (.failed, .failed):
                return true // treat all .failed as equal
            default:
                return false
            }
        }
}

// MARK: - Bluetooth Manager
class BluetoothManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var connectionState: SensorConnectionState = .disconnected
    @Published var availableSensors: [RunningSensor] = RunningSensor.mockSensors
    @Published var connectedSensor: RunningSensor?
    @Published var isBluetoothEnabled = true
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    
    // Service and Characteristic UUIDs (replace with your actual sensor UUIDs)
    private let sensorServiceUUID = CBUUID(string: "180D") // Example: Heart Rate Service
    private let batteryServiceUUID = CBUUID(string: "180F") // Battery Service
    private let dataCharacteristicUUID = CBUUID(string: "2A37") // Example characteristic
    
    // MARK: - Initialization
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public Methods
    
    /// Start scanning for sensors
    func startScanning() {
        guard isBluetoothEnabled else {
            connectionState = .failed(BluetoothError.bluetoothOff)
            return
        }
        
        connectionState = .scanning
        availableSensors.removeAll()
        discoveredPeripherals.removeAll()
        
        centralManager?.scanForPeripherals(
            withServices: nil, // Set to [sensorServiceUUID] to filter
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
        
        // Stop scanning after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopScanning()
        }
    }
    
    /// Stop scanning for sensors
    func stopScanning() {
        centralManager?.stopScan()
        if connectionState == .scanning {
            connectionState = .disconnected
        }
    }
    
    /// Connect to a specific sensor
    func connect(to sensor: RunningSensor) {
        guard let peripheral = sensor.peripheral else { return }
        
        connectionState = .connecting
        centralManager?.connect(peripheral, options: nil)
    }
    
    /// Disconnect from current sensor
    func disconnect() {
        if let peripheral = connectedSensor?.peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
        connectedSensor = nil
        connectionState = .disconnected
    }
    
    /// Request battery level update
    func updateBatteryLevel() {
        guard let peripheral = connectedSensor?.peripheral else { return }
        
        // Find battery characteristic and read value
        for service in peripheral.services ?? [] {
            if service.uuid == batteryServiceUUID {
                for characteristic in service.characteristics ?? [] {
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }
}



// MARK: - CBCentralManagerDelegate
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothEnabled = central.state == .poweredOn
        
        if !isBluetoothEnabled {
            connectionState = .disconnected
            availableSensors.removeAll()
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String: Any],
                       rssi RSSI: NSNumber) {
        
        let sensorName = peripheral.name ?? "Unknown Sensor"
        
        // Filter for sensors (adjust this based on your sensor's name pattern)
        guard sensorName.lowercased().contains("aletheia") ||
              sensorName.lowercased().contains("sensor") ||
              sensorName.lowercased().contains("run") else {
            return
        }
        
        let sensor = RunningSensor(
            id: peripheral.identifier,
            name: sensorName,
            rssi: RSSI.intValue,
            batteryLevel: nil,
            isConnected: false,
            peripheral: peripheral
        )
        
        discoveredPeripherals[peripheral.identifier] = peripheral
        
        if !availableSensors.contains(where: { $0.id == sensor.id }) {
            availableSensors.append(sensor)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                       didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices([sensorServiceUUID, batteryServiceUUID])
        
        if let index = availableSensors.firstIndex(where: { $0.id == peripheral.identifier }) {
            availableSensors[index].isConnected = true
            connectedSensor = availableSensors[index]
        }
        
        connectionState = .connected
    }
    
    func centralManager(_ central: CBCentralManager,
                       didFailToConnect peripheral: CBPeripheral,
                       error: Error?) {
        connectionState = .failed(error ?? BluetoothError.connectionFailed)
    }
    
    func centralManager(_ central: CBCentralManager,
                       didDisconnectPeripheral peripheral: CBPeripheral,
                       error: Error?) {
        connectedSensor = nil
        connectionState = .disconnected
        
        if let index = availableSensors.firstIndex(where: { $0.id == peripheral.identifier }) {
            availableSensors[index].isConnected = false
        }
    }
}

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral,
                   didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                   didDiscoverCharacteristicsFor service: CBService,
                   error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            // Subscribe to notifications for sensor data
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            // Read battery level
            if service.uuid == batteryServiceUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                   didUpdateValueFor characteristic: CBCharacteristic,
                   error: Error?) {
        
        // Handle battery level
        if characteristic.service?.uuid == batteryServiceUUID,
           let data = characteristic.value,
           let batteryLevel = data.first {
            
            if var sensor = connectedSensor {
                sensor.batteryLevel = Int(batteryLevel)
                connectedSensor = sensor
                
                if let index = availableSensors.firstIndex(where: { $0.id == sensor.id }) {
                    availableSensors[index].batteryLevel = Int(batteryLevel)
                }
            }
        }
        
        // Handle sensor data (implement based on your sensor's data format)
        // This is where you'd parse incoming running data
    }
}

// MARK: - Bluetooth Errors
enum BluetoothError: LocalizedError {
    case bluetoothOff
    case connectionFailed
    case sensorNotFound
    
    var errorDescription: String? {
        switch self {
        case .bluetoothOff:
            return "Bluetooth is turned off. Please enable it in Settings."
        case .connectionFailed:
            return "Failed to connect to sensor."
        case .sensorNotFound:
            return "No sensors found nearby."
        }
    }
}
