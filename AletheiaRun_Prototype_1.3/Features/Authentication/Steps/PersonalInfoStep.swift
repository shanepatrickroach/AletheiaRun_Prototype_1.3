//
//  PersonalInfoStep.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct PersonalInfoStep: View {
    @Binding var profile: UserProfile
    
    @State private var showingCountryPicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Header
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Personal Information")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Tell us a bit about yourself")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.xl)
                
                // First Name
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("First Name")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    CustomTextField(
                        placeholder: "person",
                        text: $profile.firstName,
                        icon: "envelope"
                    )
                    .textInputAutocapitalization(.words)
                }
                .padding(.horizontal, Spacing.l)
                
                // Last Name
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Last Name")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    CustomTextField(
                        placeholder: "Last Name",
                        text: $profile.lastName,
                        icon: "person.fill"
                    )
                    .textInputAutocapitalization(.words)
                }
                .padding(.horizontal, Spacing.l)
                
                // Birthdate
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Date of Birth")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    DatePicker(
                        "",
                        selection: $profile.birthdate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                }
                .padding(.horizontal, Spacing.l)
                
                // Country
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Country")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Button(action: {
                        showingCountryPicker = true
                    }) {
                        HStack {
                            Image(systemName: "flag")
                                .foregroundColor(.primaryOrange)
                            
                            Text(profile.country)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textTertiary)
                        }
                        .padding(Spacing.m)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.medium)
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, Spacing.xxxl)
        }
        .sheet(isPresented: $showingCountryPicker) {
            CountryPickerView(selectedCountry: $profile.country)
        }
    }
}

#Preview {
    PersonalInfoStep(profile: .constant(UserProfile()))
}
