//
//  AletheiaApp.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/3/25.
//

import SwiftUI

@main
struct AletheiaApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    
    init() {
            print("🟦 APP LAUNCHED - Creating AuthenticationManager")
        }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
