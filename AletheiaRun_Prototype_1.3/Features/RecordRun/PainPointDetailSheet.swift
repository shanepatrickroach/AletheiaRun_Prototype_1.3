//
//  PainPointDetailSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


// Features/Run/PainPointDetailSheet.swift

import SwiftUI

/// Detailed information sheet for a specific pain point
struct PainPointDetailSheet: View {
    let painPoint: PainPointType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Header
                    headerSection
                    
                    // Description
                    descriptionSection
                    
                    // Common causes
                    causesSection
                    
                    // Treatments
                    //treatmentsSection
                    
                    // Related metrics
                    //relatedMetricsSection
                }
                .padding(Spacing.m)
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.backgroundBlack)
            .navigationTitle("Pain Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(painPoint.color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: painPoint.bodyIcon)
                    .font(.system(size: 32))
                    .foregroundColor(painPoint.color)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(painPoint.displayName)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text(painPoint.shortDescription)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("About This Condition")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(painPoint.fullDescription)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    // MARK: - Causes Section
    private var causesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Common Causes")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(painPoint.commonCauses, id: \.self) { cause in
                    HStack(alignment: .top, spacing: Spacing.s) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.warningYellow)
                            .font(.system(size: 16))
                        
                        Text(cause)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    // MARK: - Treatments Section
    private var treatmentsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("What You Should Do")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(painPoint.treatments) { treatment in
                    TreatmentRow(treatment: treatment)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
    
    // MARK: - Related Metrics Section
    private var relatedMetricsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Related Running Metrics")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text("Improving these metrics may help prevent this pain:")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: Spacing.xs) {
                ForEach(painPoint.relatedMetrics, id: \.self) { metric in
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.primaryOrange)
                        
                        Text(metric)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.s)
                    .background(Color.cardBackground.opacity(0.5))
                    .cornerRadius(CornerRadius.small)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Treatment Row
struct TreatmentRow: View {
    let treatment: Treatment
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s) {
            Image(systemName: treatment.icon)
                .foregroundColor(treatment.color)
                .font(.system(size: 16))
            
            Text(treatment.text)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(Spacing.s)
        .background(treatment.color.opacity(0.1))
        .cornerRadius(CornerRadius.small)
    }
}

#Preview {
    PainPointDetailSheet(painPoint: .patelloFemoral)
}
