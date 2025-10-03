//
//  PreRunConfirmationView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Features/Run/PreRunConfirmationView.swift

import SwiftUI

struct PreRunConfirmationView: View {
    let configuration: RunConfiguration
    let onConfirm: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var hasConfirmedPlacement = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // MARK: - Header
                        VStack(spacing: Spacing.s) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Ready to Start")
                                .font(Font.titleLarge)
                                .foregroundColor(.textPrimary)
                            
                            Text("Review your settings before starting")
                                .font(Font.bodyMedium)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, Spacing.xl)
                        
                        // MARK: - Configuration Summary
                        configurationSummary
                        
                        // MARK: - Sensor Placement Reminder
                        sensorPlacementReminder
                        
                        // MARK: - Placement Confirmation Checkbox
                        placementConfirmation
                        
                        // MARK: - Important Tips
                        importantTips
                        
                        // MARK: - Start Button
                        PrimaryButton(
                            title: "Start Session"
                        ) {
                            onConfirm()
                        }
                        .disabled(!hasConfirmedPlacement)
                        .opacity(hasConfirmedPlacement ? 1.0 : 0.5)
                        
                    }
                    .padding(Spacing.m)
                }
            }
            .navigationTitle("Confirm Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
    
    // MARK: - Configuration Summary
    private var configurationSummary: some View {
        VStack(spacing: Spacing.m) {
            Text("Session Settings")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                // Session Type
                SettingRow(
                    icon: configuration.mode.icon,
                    title: "Session Type",
                    value: configuration.mode.rawValue
                )
                
                Divider()
                    .background(Color.cardBorder)
                    .padding(.leading, 50)
                
                // Terrain
                SettingRow(
                    icon: configuration.terrain.icon,
                    title: "Terrain",
                    value: configuration.terrain.rawValue
                )
                
                Divider()
                    .background(Color.cardBorder)
                    .padding(.leading, 50)
                
                // Sensor
                HStack(spacing: Spacing.m) {
                    Image(systemName: "sensor.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.primaryOrange)
                        .frame(width: 30)
                    
                    Text("Sensor")
                        .font(Font.bodyMedium)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.successGreen)
                            .frame(width: 8, height: 8)
                        
                        Text("Connected")
                            .font(Font.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        if let battery = configuration.sensorBattery {
                            Text("(\(battery)%)")
                                .font(Font.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(Spacing.m)
            }
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Sensor Placement Reminder
    private var sensorPlacementReminder: some View {
        VStack(spacing: Spacing.m) {
            Text("Sensor Placement")
                .font(Font.headline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: Spacing.m) {
                // Illustration placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Color.cardBackground)
                        .frame(height: 200)
                    
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 80))
                            .foregroundColor(.primaryOrange.opacity(0.5))
                        
                        Text("Sensor Position")
                            .font(Font.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: Spacing.s) {
                    InstructionRow(
                        number: 1,
                        text: "Place sensor on your lower back (sacrum)"
                    )
                    
                    InstructionRow(
                        number: 2,
                        text: "Secure with the elastic band or clip"
                    )
                    
                    InstructionRow(
                        number: 3,
                        text: "Ensure sensor is centered and secure"
                    )
                }
                .padding(Spacing.m)
                .background(Color.infoBlue.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
            }
        }
    }
    
    // MARK: - Placement Confirmation
    private var placementConfirmation: some View {
        Button(action: {
            hasConfirmedPlacement.toggle()
        }) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(hasConfirmedPlacement ? Color.primaryOrange : Color.cardBorder, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if hasConfirmedPlacement {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primaryOrange)
                    }
                }
                
                Text("I confirm the sensor is properly placed and secured")
                    .font(Font.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(hasConfirmedPlacement ? Color.primaryOrange : Color.cardBorder, lineWidth: hasConfirmedPlacement ? 2 : 1)
            )
        }
    }
    
    // MARK: - Important Tips
    private var importantTips: some View {
        VStack(spacing: Spacing.m) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.warningYellow)
                
                Text("Tips for Best Results")
                    .font(Font.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                TipRow(text: "Keep your phone nearby (within 30 feet)")
                TipRow(text: "Your screen can turn off - data is still recording")
                TipRow(text: "Try to maintain consistent form throughout")
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
}

// MARK: - Setting Row
struct SettingRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)
                .frame(width: 30)
            
            Text(title)
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(Font.bodyMedium)
                .foregroundColor(.textPrimary)
        }
        .padding(Spacing.m)
    }
}

// MARK: - Instruction Row
struct InstructionRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange)
                    .frame(width: 24, height: 24)
                
                Text("\(number)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Text(text)
                .font(Font.bodyMedium)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Tip Row
struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s) {
            Text("•")
                .foregroundColor(.textSecondary)
            
            Text(text)
                .font(Font.bodySmall)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PreRunConfirmationView(
        configuration: RunConfiguration(
            mode: .run,
            terrain: .road,
            sensorConnected: true,
            sensorBattery: 85
        ),
        onConfirm: {}
    )
}
