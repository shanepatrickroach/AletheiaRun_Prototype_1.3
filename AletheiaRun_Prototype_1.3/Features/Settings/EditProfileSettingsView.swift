//
//  EditProfileView.swift
//  AletheiaRun_Prototype_1.3
//
//  Complete Edit Profile Screen
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    // State for all editable fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var birthdate: Date = Date()
    @State private var country: String = "United States"
    @State private var gender: Gender = .male
    
    // Physical profile
    @State private var measurementSystem: MeasurementSystem = .imperial
    @State private var heightFeet: Int = 5
    @State private var heightInches: Int = 8
    @State private var heightCentimeters: Int = 173
    @State private var weightPounds: Int = 150
    @State private var weightKilograms: Int = 68
    @State private var averageMileage: AverageMileage = .miles10to20
    
    // Running goals
    @State private var selectedGoals: Set<RunGoal> = []
    
    // UI state
    @State private var selectedSection: EditSection = .personal
    @State private var showingCountryPicker = false
    @State private var showingSaveAlert = false
    @State private var showingDiscardAlert = false
    @State private var hasUnsavedChanges = false
    
    enum EditSection: String, CaseIterable {
        case personal = "Personal"
        case physical = "Physical"
        case goals = "Goals"
        
        var icon: String {
            switch self {
            case .personal: return "person.fill"
            case .physical: return "figure.run"
            case .goals: return "target"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Section selector
                sectionSelector
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        switch selectedSection {
                        case .personal:
                            personalInfoSection
                        case .physical:
                            physicalProfileSection
                        case .goals:
                            runningGoalsSection
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
        }
        .navigationBarBackButtonHidden(hasUnsavedChanges)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                if hasUnsavedChanges {
                    Button("Cancel") {
                        showingDiscardAlert = true
                    }
                    .foregroundColor(.errorRed)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .foregroundColor(.primaryOrange)
                .fontWeight(.semibold)
                .disabled(!hasUnsavedChanges)
            }
        }
        .onAppear {
            
        }
        .alert("Save Changes?", isPresented: $showingSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                saveChanges()
                dismiss()
            }
        } message: {
            Text("Your profile will be updated with the new information.")
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Keep Editing", role: .cancel) {}
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
        .sheet(isPresented: $showingCountryPicker) {
            CountryPickerView(selectedCountry: $country)
        }
        
    }
    
    // MARK: - Section Selector
    private var sectionSelector: some View {
        HStack(spacing: 0) {
            ForEach(EditSection.allCases, id: \.self) { section in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedSection = section
                    }
                }) {
                    VStack(spacing: Spacing.xs) {
                        Image(systemName: section.icon)
                            .font(.title3)
                        
                        Text(section.rawValue)
                            .font(.caption)
                            .fontWeight(selectedSection == section ? .semibold : .regular)
                    }
                    .foregroundColor(selectedSection == section ? .primaryOrange : .textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.m)
//                    .background(
//                        selectedSection == section ?
//                            Color.primaryOrange.opacity(0.15) : Color.clear
//                    )
                }
            }
        }
        .background(Color.cardBackground)
    }
    
    // MARK: - Personal Info Section
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            SectionHeader(title: "Personal Information")
            
            VStack(spacing: Spacing.m) {
                // Profile photo (placeholder)
                VStack(spacing: Spacing.m) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.primaryOrange, .primaryLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Text(firstName.prefix(1).uppercased())
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.backgroundBlack)
                    }
                    
                    Button(action: {
                        // Change photo action
                    }) {
                        Text("Change Photo")
                            .font(.bodySmall)
                            .foregroundColor(.primaryOrange)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.m)
                
                // Name fields
                HStack(spacing: Spacing.m) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("First Name")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        TextField("First name", text: $firstName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(Spacing.m)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Last Name")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        TextField("Last name", text: $lastName)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(Spacing.m)
                            .background(Color.cardBackground)
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                    }
                }
                
                // Email (read-only)
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        Text(email)
                            .font(.bodyMedium)
                            .foregroundColor(.textTertiary)
                        
                        Spacer()
                        
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground.opacity(0.5))
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                    
                    Text("Email cannot be changed")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                
//                // Birthdate
//                VStack(alignment: .leading, spacing: Spacing.xs) {
//                    Text("Date of Birth")
//                        .font(.caption)
//                        .foregroundColor(.textSecondary)
//                    
//                    DatePicker(
//                        "",
//                        selection: $birthdate,
//                        in: ...Date(),
//                        displayedComponents: .date
//                    )
//                    .datePickerStyle(.compact)
//                    .labelsHidden()
//                    .accentColor(.primaryOrange)
//                    .padding(Spacing.m)
//                    .background(Color.cardBackground)
//                    .cornerRadius(CornerRadius.small)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: CornerRadius.small)
//                            .stroke(Color.cardBorder, lineWidth: 1)
//                    )
//                }
                
                // Gender
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Gender")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { genderOption in
                            Text(genderOption.rawValue).tag(genderOption)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.primaryOrange)
                    .preferredColorScheme(.dark)
                }
                
                // Country
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Country")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Button(action: {
                        showingCountryPicker = true
                    }) {
                        HStack {
                            Text(country)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                        .padding(Spacing.m)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.small)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Physical Profile Section
    private var physicalProfileSection: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            SectionHeader(title: "Physical Profile")
            
            VStack(spacing: Spacing.m) {
                // Measurement system
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Measurement System")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Picker("System", selection: $measurementSystem) {
                        Text("Imperial (ft, lbs)").tag(MeasurementSystem.imperial)
                        Text("Metric (cm, kg)").tag(MeasurementSystem.metric)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.primaryOrange)
                    .onChange(of: measurementSystem) { newSystem in
                        convertMeasurements(to: newSystem)
                    }
                }
                
                // Height
                if measurementSystem == .imperial {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Height")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: Spacing.m) {
                            // Feet picker
                            VStack(spacing: Spacing.xxs) {
                                Picker("Feet", selection: $heightFeet) {
                                    ForEach(4...7, id: \.self) { feet in
                                        Text("\(feet)").tag(feet)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .preferredColorScheme(.dark)
                                .frame(height: 120)
                                
                                Text("feet")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            // Inches picker
                            VStack(spacing: Spacing.xxs) {
                                Picker("Inches", selection: $heightInches) {
                                    ForEach(0...11, id: \.self) { inches in
                                        Text("\(inches)").tag(inches)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                                .preferredColorScheme(.dark)
                                
                                Text("inches")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Height")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        VStack(spacing: Spacing.xxs) {
                            Picker("Height", selection: $heightCentimeters) {
                                ForEach(140...220, id: \.self) { cm in
                                    Text("\(cm)").tag(cm)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            .preferredColorScheme(.dark)
                            
                            Text("centimeters")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
//                
                // Weight
                if measurementSystem == .imperial {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        VStack(spacing: Spacing.xxs) {
                            Picker("Weight", selection: $weightPounds) {
                                ForEach(80...300, id: \.self) { lbs in
                                    Text("\(lbs)").tag(lbs)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            
                            Text("pounds")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        VStack(spacing: Spacing.xxs) {
                            Picker("Weight", selection: $weightKilograms) {
                                ForEach(40...150, id: \.self) { kg in
                                    Text("\(kg)").tag(kg)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            
                            Text("kilograms")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
//                // Average weekly mileage
//                VStack(alignment: .leading, spacing: Spacing.xs) {
//                    Text("Average Weekly Mileage")
//                        .font(.caption)
//                        .foregroundColor(.textSecondary)
//                    
//                    VStack(spacing: Spacing.s) {
//                        ForEach(AverageMileage.allCases, id: \.self) { mileage in
//                            Button(action: {
//                                averageMileage = mileage
//                            }) {
//                                HStack {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(mileage.rawValue)
//                                            .font(.bodyMedium)
//                                            .foregroundColor(.textPrimary)
//                                        
//                                        Text(mileage.description)
//                                            .font(.caption)
//                                            .foregroundColor(.textSecondary)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    ZStack {
//                                        Circle()
//                                            .strokeBorder(
//                                                averageMileage == mileage ? Color.primaryOrange : Color.cardBorder,
//                                                lineWidth: 2
//                                            )
//                                            .frame(width: 24, height: 24)
//                                        
//                                        if averageMileage == mileage {
//                                            Circle()
//                                                .fill(Color.primaryOrange)
//                                                .frame(width: 12, height: 12)
//                                        }
//                                    }
//                                }
//                                .padding(Spacing.m)
//                                .background(Color.cardBackground)
//                                .cornerRadius(CornerRadius.small)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: CornerRadius.small)
//                                        .stroke(
//                                            averageMileage == mileage ? Color.primaryOrange : Color.cardBorder,
//                                            lineWidth: averageMileage == mileage ? 2 : 1
//                                        )
//                                )
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                }
            }
        }
    }
    
    // MARK: - Running Goals Section
    private var runningGoalsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            SectionHeader(title: "Running Goals")
            
            Text("Select all that apply")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: Spacing.s) {
                ForEach(RunGoal.allCases, id: \.self) { goal in
                    Button(action: {
                        if selectedGoals.contains(goal) {
                            selectedGoals.remove(goal)
                        } else {
                            selectedGoals.insert(goal)
                        }
                    }) {
                        HStack(spacing: Spacing.m) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        selectedGoals.contains(goal) ?
                                            Color.primaryOrange.opacity(0.2) :
                                            Color.cardBackground
                                    )
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: goal.icon)
                                    .font(.title3)
                                    .foregroundColor(
                                        selectedGoals.contains(goal) ?
                                            .primaryOrange : .textSecondary
                                    )
                            }
                            
                            // Text
                            VStack(alignment: .leading, spacing: 4) {
                                Text(goal.rawValue)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Text(goal.description)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Checkmark
                            Image(systemName: selectedGoals.contains(goal) ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundColor(
                                    selectedGoals.contains(goal) ?
                                        .primaryOrange : .cardBorder
                                )
                        }
                        .padding(Spacing.m)
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .stroke(
                                    selectedGoals.contains(goal) ?
                                        Color.primaryOrange : Color.cardBorder,
                                    lineWidth: selectedGoals.contains(goal) ? 2 : 1
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadCurrentUserData() {
       
        
    }
    
    private func convertMeasurements(to system: MeasurementSystem) {
        
    }
    
    private func saveChanges() {
        
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.textPrimary)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EditProfileView()
            .environmentObject(AuthenticationManager())
    }
}
