//
//  SortSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Library/SortSheet.swift (NEW FILE)

import SwiftUI

struct SortSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sortOption: RunSort
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.s) {
                        ForEach(RunSort.allCases, id: \.self) { option in
                            Button(action: {
                                sortOption = option
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: option.icon)
                                        .foregroundColor(sortOption == option ? .primaryOrange : .textSecondary)
                                        .frame(width: 24)
                                    
                                    Text(option.rawValue)
                                        .font(.bodyMedium)
                                        .foregroundColor(sortOption == option ? .primaryOrange : .textPrimary)
                                    
                                    Spacer()
                                    
                                    if sortOption == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.primaryOrange)
                                    }
                                }
                                .padding(Spacing.m)
                                .background(
                                    sortOption == option 
                                        ? Color.primaryOrange.opacity(0.1)
                                        : Color.cardBackground
                                )
                                .cornerRadius(CornerRadius.medium)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.l)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Sort By")
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
    SortSheet(sortOption: .constant(.dateNewest))
}