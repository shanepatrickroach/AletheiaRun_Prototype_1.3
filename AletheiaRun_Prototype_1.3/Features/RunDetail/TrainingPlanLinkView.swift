//
//  TrainingPlanLinkView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/23/25.
//


//
//  TrainingPlanLinkView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import SwiftUI

// MARK: - Training Plan Link View
/// Embedded view in RunDetail that links to the full Training Plan
struct TrainingPlanLinkView: View {
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.s) {
                HStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(.primaryOrange)
                    
                    Text("Training Plan")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                Text("Personalized exercises to improve your metrics")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Feature Cards
            VStack(spacing: Spacing.s) {
                TrainingPlanLinkFeatureRow(
                    icon: "target",
                    title: "Metric-Based",
                    description: "Exercises tailored to your current performance levels"
                )
                
                TrainingPlanLinkFeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Dynamic Evolution",
                    description: "Plan adjusts as your metrics improve"
                )
                
                TrainingPlanLinkFeatureRow(
                    icon: "bandage.fill",
                    title: "Pain Point Focus",
                    description: "Addresses your specific areas of concern"
                )
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
            
            // Link to full Training Plan
            NavigationLink(destination: TrainingPlanView(isEmbedded: true)) {
                HStack {
                    Text("View Full Training Plan")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.backgroundBlack)
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.m)
                .background(Color.primaryOrange)
                .cornerRadius(CornerRadius.large)
            }
            
            // Info Banner
            HStack(spacing: Spacing.s) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.infoBlue)
                
                Text("Your plan is generated based on your latest run metrics and evolves with your progress")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.s)
            .background(Color.infoBlue.opacity(0.1))
            .cornerRadius(CornerRadius.small)
        }
    }
}

// MARK: - Feature Row
struct TrainingPlanLinkFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
                    .font(.bodyMedium)
            }
            
            // Text
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            TrainingPlanLinkView()
                .padding()
        }
    }
}
