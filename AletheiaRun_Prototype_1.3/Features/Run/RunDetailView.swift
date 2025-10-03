//
//  RunDetailView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Run/RunDetailView.swift (NEW FILE - Basic version)

import SwiftUI

struct RunDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let run: Run
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Force Portrait Section
                        VStack(spacing: Spacing.m) {
                            Text("Force Portrait")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: CornerRadius.large)
                                    .fill(Color.backgroundBlack)
                                    .frame(height: 200)
                                
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 80))
                                    .foregroundColor(.primaryOrange.opacity(0.3))
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.large)
                                    .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Run Stats
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            Text("Run Details")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            VStack(spacing: Spacing.s) {
                                DetailRow(icon: "calendar", label: "Date", value: run.date.formatted(date: .long, time: .shortened), color: Color.primary)
                                DetailRow(icon: run.mode.icon, label: "Mode", value: run.mode.rawValue, color: Color.primary)
                                DetailRow(icon: run.terrain.icon, label: "Terrain", value: run.terrain.rawValue, color: Color.primary)
//                                DetailRow(icon: "ruler", label: "Distance", value: String(run.distance),color: Color.primary)
//                                DetailRow(icon: "clock", label: "Duration", value: run.formattedDuration, color: Color.primary)
//                                DetailRow(icon: "speedometer", label: "Pace", value: run.formattedPace + "/mi", color: Color.primary)
                                DetailRow(icon: "bolt.fill", label: "Efficiency", value: "\(Int(run.efficiency))%",color: Color.primary)
                            }
                            .padding(Spacing.m)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.large)
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Perspectives
                        VStack(alignment: .leading, spacing: Spacing.m) {
                            Text("Recorded Perspectives")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: Spacing.m) {
                                ForEach(Array(run.perspectives).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { perspective in
                                    VStack(spacing: Spacing.s) {
                                        ZStack {
                                            Circle()
                                                .fill(perspective.color.opacity(0.2))
                                                .frame(width: 60, height: 60)
                                            
                                            Image(systemName: perspective.icon)
                                                .font(.system(size: 28))
                                                .foregroundColor(perspective.color)
                                        }
                                        
                                        Text(perspective.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(Spacing.m)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.large)
                        }
                        .padding(.horizontal, Spacing.l)
                        
                        // Notes
                        if let notes = run.notes {
                            VStack(alignment: .leading, spacing: Spacing.m) {
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                
                                Text(notes)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                    .padding(Spacing.m)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.large)
                            }
                            .padding(.horizontal, Spacing.l)
                        }
                    }
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationTitle("Run Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
}

#Preview {
    RunDetailView(run: SampleData.generateRuns(count: 1)[0])
}
