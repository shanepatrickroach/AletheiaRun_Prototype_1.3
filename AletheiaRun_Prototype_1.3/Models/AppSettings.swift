//
//  AppSettings.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    @Published var runRemindersEnabled: Bool = true
    @Published var achievementAlertsEnabled: Bool = true
    @Published var weeklyReportsEnabled: Bool = true
    
    @Published var sensorAutoConnect: Bool = true
    @Published var sensorVibrationFeedback: Bool = true
    @Published var sensorBatteryAlerts: Bool = true
    
    @Published var units: UnitsPreference = .imperial
    @Published var appearanceMode: AppearanceMode = .dark
    @Published var hapticFeedback: Bool = true
    
    @Published var shareDataForResearch: Bool = false
    @Published var analyticsEnabled: Bool = true
    
    enum UnitsPreference: String, CaseIterable {
        case imperial = "Imperial (mi, lbs)"
        case metric = "Metric (km, kg)"
    }
    
    enum AppearanceMode: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    
    // Save settings to UserDefaults
    func saveSettings() {
        // In a real app, save to UserDefaults or backend
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(units.rawValue, forKey: "units")
        // ... save other settings
    }
    
    // Load settings from UserDefaults
    func loadSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        if let unitsString = UserDefaults.standard.string(forKey: "units"),
           let savedUnits = UnitsPreference(rawValue: unitsString) {
            units = savedUnits
        }
        // ... load other settings
    }
}