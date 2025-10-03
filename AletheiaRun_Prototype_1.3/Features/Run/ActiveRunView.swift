//
//  ActiveRunView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/8/25.
//


// Features/Run/ActiveRunView.swift

import SwiftUI

struct ActiveRunView: View {
    let configuration: RunConfiguration
    @ObservedObject var bluetoothManager: BluetoothManager
    
    @StateObject private var runSession = RunSessionManager()
    @State private var showingEndConfirmation = false
    @State private var navigateToSurvey = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: - Header
                header
                
                Spacer()
                
                // MARK: - Main Metrics Display
                if runSession.isRunning {
                    metricsDisplay
                } else {
                    readyToStartView
                }
                
                Spacer()
                
                // MARK: - Control Buttons
                controlButtons
            }
            .padding(Spacing.m)
        }
        .navigationBarBackButtonHidden(true)
        .alert("End Session?", isPresented: $showingEndConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("End Session", role: .destructive) {
                runSession.endRun()
                navigateToSurvey = true
            }
        } message: {
            Text("Are you sure you want to end this session? Your data will be saved.")
        }
        .navigationDestination(isPresented: $navigateToSurvey) {
            PostRunSurveyView(runSession: runSession)
        }
        .onAppear {
            runSession.configuration = configuration
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: Spacing.s) {
            HStack {
                // Session Type Badge
                HStack(spacing: 6) {
                    Image(systemName: configuration.mode.icon)
                        .font(.system(size: 14))
                    Text(configuration.mode.rawValue)
                        .font(Font.caption)
                }
                .foregroundColor(.primaryOrange)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xs)
                .background(Color.primaryOrange.opacity(0.2))
                .cornerRadius(CornerRadius.small)
                
                Spacer()
                
                // Sensor Status
                sensorStatus
            }
            
            // Duration
            Text(runSession.formattedDuration)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .monospacedDigit()
        }
    }
    
    // MARK: - Sensor Status
    private var sensorStatus: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(bluetoothManager.connectedSensor != nil ? Color.successGreen : Color.errorRed)
                .frame(width: 8, height: 8)
            
            Image(systemName: "sensor.fill")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.xs)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.small)
    }
    
    // MARK: - Ready to Start View
    private var readyToStartView: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.primaryOrange.opacity(0.5))
            
            Text("Ready to Start")
                .font(Font.titleLarge)
                .foregroundColor(.textPrimary)
            
            Text("Tap the play button when you're ready to begin your \(configuration.mode.rawValue.lowercased()) session")
                .font(Font.bodyMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
    
    // MARK: - Metrics Display
    private var metricsDisplay: some View {
        VStack(spacing: Spacing.xl) {
            
            // MARK: - Primary Metrics
            HStack(spacing: Spacing.l) {
                MetricDisplay(
                    title: "Distance",
                    value: String(format: "%.2f", runSession.distance),
                    unit: "mi",
                    icon: "road.lanes"
                )
                
                MetricDisplay(
                    title: "Pace",
                    value: runSession.formattedPace,
                    unit: "min/mi",
                    icon: "speedometer"
                )
            }
            
            // MARK: - Live Force Portrait Preview (Placeholder)
            liveForcePortraitPreview
            
            // MARK: - Secondary Metrics Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.m) {
                SmallMetricCard(
                    title: "Efficiency",
                    value: runSession.currentEfficiency,
                    color: metricColor(for: runSession.currentEfficiency)
                )
                
                SmallMetricCard(
                    title: "Impact",
                    value: runSession.currentImpact,
                    color: metricColor(for: runSession.currentImpact)
                )
                
                SmallMetricCard(
                    title: "Sway",
                    value: runSession.currentSway,
                    color: metricColor(for: runSession.currentSway)
                )
                
                SmallMetricCard(
                    title: "Braking",
                    value: runSession.currentBraking,
                    color: metricColor(for: runSession.currentBraking)
                )
            }
        }
    }
    
    // MARK: - Live Force Portrait Preview
    private var liveForcePortraitPreview: some View {
        VStack(spacing: Spacing.s) {
            Text("Live Analysis")
                .font(Font.caption)
                .foregroundColor(.textSecondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.cardBackground)
                    .frame(height: 120)
                
                // Animated waveform placeholder
                HStack(spacing: 4) {
                    ForEach(0..<20, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.primaryOrange.opacity(0.7))
                            .frame(width: 6, height: CGFloat.random(in: 20...80))
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.05),
                                value: runSession.isRunning
                            )
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Control Buttons
    private var controlButtons: some View {
        VStack(spacing: Spacing.m) {
            
            // MARK: - Primary Control Button
            if runSession.isRunning {
                // Pause Button
                Button(action: {
                    runSession.pauseRun()
                }) {
                    HStack {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 24))
                        Text("Pause")
                            .font(Font.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.l)
                    .background(Color.warningYellow)
                    .cornerRadius(CornerRadius.medium)
                }
            } else if runSession.isPaused {
                // Resume Button
                Button(action: {
                    runSession.resumeRun()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                        Text("Resume")
                            .font(Font.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.l)
                    .background(Color.successGreen)
                    .cornerRadius(CornerRadius.medium)
                }
            } else {
                // Start Button
                Button(action: {
                    runSession.startRun()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                        Text("Start")
                            .font(Font.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.l)
                    .background(Color.primaryOrange)
                    .cornerRadius(CornerRadius.medium)
                }
            }
            
            // MARK: - End Session Button
            if runSession.isRunning || runSession.isPaused {
                Button(action: {
                    showingEndConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("End Session")
                    }
                    
                    .font(Font.bodyMedium)
                                            .foregroundColor(.errorRed)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, Spacing.m)
                                            .background(Color.errorRed.opacity(0.1))
                                            .cornerRadius(CornerRadius.medium)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                                    .stroke(Color.errorRed, lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                            }
                            
                            // MARK: - Helper Functions
                            private func metricColor(for value: Int) -> Color {
                                switch value {
                                case 80...100: return .successGreen
                                case 60..<80: return .warningYellow
                                default: return .errorRed
                                }
                            }
                        }

                        // MARK: - Metric Display
                        struct MetricDisplay: View {
                            let title: String
                            let value: String
                            let unit: String
                            let icon: String
                            
                            var body: some View {
                                VStack(spacing: Spacing.s) {
                                    Image(systemName: icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(.primaryOrange)
                                    
                                    Text(title)
                                        .font(Font.caption)
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                                        Text(value)
                                            .font(.system(size: 36, weight: .bold, design: .rounded))
                                            .foregroundColor(.textPrimary)
                                            .monospacedDigit()
                                        
                                        Text(unit)
                                            .font(Font.bodySmall)
                                            .foregroundColor(.textSecondary)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.medium)
                            }
                        }

                        // MARK: - Small Metric Card
                        struct SmallMetricCard: View {
                            let title: String
                            let value: Int
                            let color: Color
                            
                            var body: some View {
                                VStack(spacing: Spacing.s) {
                                    Text(title)
                                        .font(Font.caption)
                                        .foregroundColor(.textSecondary)
                                    
                                    Text("\(value)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(color)
                                        .monospacedDigit()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                                        .stroke(color.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }

                        #Preview {
                            NavigationStack {
                                ActiveRunView(
                                    configuration: RunConfiguration(
                                        mode: .run,
                                        terrain: .road,
                                        sensorConnected: true,
                                        sensorBattery: 85
                                    ),
                                    bluetoothManager: BluetoothManager()
                                )
                            }
                        }
