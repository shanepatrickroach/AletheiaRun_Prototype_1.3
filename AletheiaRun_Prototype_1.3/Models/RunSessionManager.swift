//
//  RunSessionManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/15/25.
//


//
//  RunSessionManager.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Models/RunSessionManager.swift

import Foundation
import Combine

class RunSessionManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var duration: TimeInterval = 0
    @Published var distance: Double = 0 // in miles
    @Published var currentPace: Double = 0 // minutes per mile
    
    // Live metrics (0-100)
    @Published var currentEfficiency = 0
    @Published var currentSway = 0
    @Published var currentImpact = 0
    @Published var currentBraking = 0
    
    // Configuration
    var configuration: RunConfiguration?
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    private var lastUpdateTime: Date?
    
    // Accumulated metrics for averaging
    private var efficiencyReadings: [Int] = []
    private var swayReadings: [Int] = []
    private var impactReadings: [Int] = []
    private var brakingReadings: [Int] = []
    
    // Post-run data
    var postRunSurvey: PostRunSurvey?
    
    // MARK: - Computed Properties
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var formattedPace: String {
        if distance == 0 { return "--:--" }
        
        let paceMinutes = (duration / 60) / distance
        let minutes = Int(paceMinutes)
        let seconds = Int((paceMinutes - Double(minutes)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var averageEfficiency: Int {
        guard !efficiencyReadings.isEmpty else { return 0 }
        return efficiencyReadings.reduce(0, +) / efficiencyReadings.count
    }
    
    var averageSway: Int {
        guard !swayReadings.isEmpty else { return 0 }
        return swayReadings.reduce(0, +) / swayReadings.count
    }
    
    var averageImpact: Int {
        guard !impactReadings.isEmpty else { return 0 }
        return impactReadings.reduce(0, +) / impactReadings.count
    }
    
    var averageBraking: Int {
        guard !brakingReadings.isEmpty else { return 0 }
        return brakingReadings.reduce(0, +) / brakingReadings.count
    }
    
    // MARK: - Public Methods
    
    /// Start the run session
    func startRun() {
        guard !isRunning else { return }
        
        isRunning = true
        isPaused = false
        startTime = Date()
        lastUpdateTime = Date()
        
        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
        
        // Start simulating sensor data (replace with actual sensor data)
        startSimulatedDataStream()
    }
    
    /// Pause the run session
    func pauseRun() {
        guard isRunning else { return }
        
        isRunning = false
        isPaused = true
        
        // Stop timer
        timer?.invalidate()
        timer = nil
        
        // Save paused time
        if let start = startTime {
            pausedTime = Date().timeIntervalSince(start) - pausedTime
        }
    }
    
    /// Resume the run session
    func resumeRun() {
        guard isPaused else { return }
        
        isRunning = true
        isPaused = false
        
        // Adjust start time to account for paused duration
        startTime = Date().addingTimeInterval(-duration)
        lastUpdateTime = Date()
        
        // Restart timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
    }
    
    /// End the run session
    func endRun() {
        isRunning = false
        isPaused = false
        
        // Stop timer
        timer?.invalidate()
        timer = nil
    }
    
    /// Complete the post-run survey
    func completeSurvey(_ survey: PostRunSurvey) {
        postRunSurvey = survey
        saveRunData()
    }
    
    /// Reset for new run
    func reset() {
        duration = 0
        distance = 0
        currentPace = 0
        currentEfficiency = 0
        currentSway = 0
        currentImpact = 0
        currentBraking = 0
        
        efficiencyReadings.removeAll()
        swayReadings.removeAll()
        impactReadings.removeAll()
        brakingReadings.removeAll()
        
        startTime = nil
        pausedTime = 0
        lastUpdateTime = nil
        postRunSurvey = nil
    }
    
    // MARK: - Private Methods
    
    private func updateMetrics() {
        guard let start = startTime else { return }
        
        // Update duration
        duration = Date().timeIntervalSince(start) - pausedTime
        
        // Update distance (simulated - replace with actual GPS/sensor data)
        // Assuming average running speed of 6 mph = 0.1 miles per minute
        let minutesElapsed = duration / 60
        distance = minutesElapsed * 0.1
        
        // Update pace
        if distance > 0 {
            currentPace = (duration / 60) / distance
        }
    }
    
    /// Simulate sensor data stream (replace with actual Bluetooth data parsing)
    private func startSimulatedDataStream() {
        // Simulate receiving sensor data every 2 seconds
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            guard let self = self, self.isRunning else {
                timer.invalidate()
                return
            }
            
            // Generate random metrics (replace with actual sensor data)
            self.currentEfficiency = Int.random(in: 70...95)
            self.currentSway = Int.random(in: 65...90)
            self.currentImpact = Int.random(in: 60...85)
            self.currentBraking = Int.random(in: 70...90)
            
            // Store for averaging
            self.efficiencyReadings.append(self.currentEfficiency)
            self.swayReadings.append(self.currentSway)
            self.impactReadings.append(self.currentImpact)
            self.brakingReadings.append(self.currentBraking)
        }
    }
    
    /// Save run data (implement persistence)
    private func saveRunData() {
        guard let config = configuration else { return }
        
//        // Create Run object
//        let run = Run(
//            id: UUID(),
//            date: startTime ?? Date(),
//            mode: config.mode.rawValue,
//            terrain: config.terrain.rawValue,
//            distance: distance,
//            duration: Int(duration),
//            efficiency: averageEfficiency,
//            sway: averageSway,
//            endurance: Int.random(in: 60...90), // Calculate from data
//            warmup: Int.random(in: 60...90), // Calculate from data
//            impact: averageImpact,
//            braking: averageBraking,
//            variation: Int.random(in: 60...90) // Calculate from data
//        )
//        
//        // TODO: Save to persistent storage (UserDefaults, SwiftData, or backend)
//        print("Run saved: \(run)")
//        print("Survey: \(String(describing: postRunSurvey))")
//        
        // TODO: Update achievements and challenges
        // GamificationManager.shared.checkAchievements(for: run)
    }
}