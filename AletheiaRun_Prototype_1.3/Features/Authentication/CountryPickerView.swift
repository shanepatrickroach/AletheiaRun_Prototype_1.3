//
//  CountryPickerView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//


import SwiftUI

struct CountryPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCountry: String
    @State private var searchText: String = ""
    
    let countries = [
        "United States", "Canada", "United Kingdom", "Australia", "Germany",
        "France", "Italy", "Spain", "Netherlands", "Belgium", "Switzerland",
        "Sweden", "Norway", "Denmark", "Finland", "Ireland", "Portugal",
        "Austria", "Poland", "Czech Republic", "Japan", "South Korea",
        "Singapore", "New Zealand", "Brazil", "Mexico", "Argentina",
        "Chile", "Colombia", "India", "China", "Thailand", "Vietnam",
        "Philippines", "Indonesia", "Malaysia", "South Africa", "Kenya",
        "Nigeria", "Egypt", "Israel", "United Arab Emirates", "Saudi Arabia"
    ].sorted()
    
    var filteredCountries: [String] {
        if searchText.isEmpty {
            return countries
        }
        return countries.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: Spacing.m) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textTertiary)
                        
                        TextField("Search countries", text: $searchText)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textTertiary)
                            }
                        }
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.l)
                    .padding(.vertical, Spacing.m)
                    
                    // Countries list
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredCountries, id: \.self) { country in
                                Button(action: {
                                    selectedCountry = country
                                    dismiss()
                                }) {
                                    HStack {
                                        Text(country)
                                            .font(.bodyMedium)
                                            .foregroundColor(.textPrimary)
                                        
                                        Spacer()
                                        
                                        if country == selectedCountry {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.primaryOrange)
                                        }
                                    }
                                    .padding(.horizontal, Spacing.l)
                                    .padding(.vertical, Spacing.m)
                                }
                                
                                Divider()
                                    .background(Color.cardBorder)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primaryOrange)
                    }
                }
            }
        }
    }
}

#Preview {
    CountryPickerView(selectedCountry: .constant("United States"))
}
