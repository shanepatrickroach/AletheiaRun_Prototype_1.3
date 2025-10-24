//
//  PainPointSideSelectionSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


// Features/Run/PainPointSideSelectionSheet.swift

import SwiftUI

/// Sheet for selecting which side(s) of the body the pain is on
struct PainPointSideSelectionSheet: View {
    let painPoint: PainPointType
    let onSelect: (PainPointSide) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                VStack(spacing: Spacing.xl) {
                    // Header
                    headerSection
                    
                    // Side selection buttons
                    sideSelectionButtons
                    
                    Spacer()
                }
                .padding(Spacing.m)
            }
            .navigationTitle("Select Side")
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
        VStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(painPoint.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: painPoint.bodyIcon)
                    .font(.system(size: 40))
                    .foregroundColor(painPoint.color)
            }
            
            Text(painPoint.displayName)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            
            Text("Which side is affected?")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Side Selection Buttons
    private var sideSelectionButtons: some View {
        VStack(spacing: Spacing.m) {
            ForEach(PainPointSide.allCases, id: \.self) { side in
                Button(action: {
                    onSelect(side)
                    dismiss()
                }) {
                    HStack(spacing: Spacing.m) {
                        // Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .fill(side.color.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: side.icon)
                                .font(.system(size: 24))
                                .foregroundColor(side.color)
                        }
                        
                        // Text
                        VStack(alignment: .leading, spacing: 4) {
                            Text(side.rawValue)
                                .font(.bodyLarge)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                            
                            Text(side.description)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Arrow
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(side.color.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Side Description Extension
extension PainPointSide {
    var description: String {
        switch self {
        case .left: return "Pain on the left side only"
        case .right: return "Pain on the right side only"
        case .both: return "Pain on both sides"
        }
    }
}

#Preview {
    PainPointSideSelectionSheet(
        painPoint: .patelloFemoral,
        onSelect: { _ in }
    )
}