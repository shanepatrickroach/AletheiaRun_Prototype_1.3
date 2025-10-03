//
//  PhysicalProfileStep.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/10/25.
//


// Features/Authentication/Steps/PhysicalProfileStep.swift (NEW)

import SwiftUI

struct PhysicalProfileStep: View {
    @Binding var profile: UserProfile
    
    // Local state for input
    @State private var heightFeet = 5
    @State private var heightInches = 8
    @State private var heightCentimeters = 173.0
    @State private var weightPounds = 150.0
    @State private var weightKilograms = 68.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Header
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Physical Profile")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Help us personalize your experience")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.xl)
                
                // Measurement System Selection
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Measurement System")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: Spacing.m) {
                        MeasurementSystemButton(
                            system: .imperial,
                            isSelected: profile.measurementSystem == .imperial
                        ) {
                            withAnimation {
                                profile.measurementSystem = .imperial
                                updateHeightWeight()
                            }
                        }
                        
                        MeasurementSystemButton(
                            system: .metric,
                            isSelected: profile.measurementSystem == .metric
                        ) {
                            withAnimation {
                                profile.measurementSystem = .metric
                                updateHeightWeight()
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Gender Selection
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Gender")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.s) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            GenderSelectionRow(
                                gender: gender,
                                isSelected: profile.gender == gender
                            ) {
                                profile.gender = gender
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Height Input
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Height")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    if profile.measurementSystem == .imperial {
                        heightImperialPicker
                    } else {
                        heightMetricPicker
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Weight Input
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Weight")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    if profile.measurementSystem == .imperial {
                        weightImperialPicker
                    } else {
                        weightMetricPicker
                    }
                }
                .padding(.horizontal, Spacing.l)
                
                // Average Weekly Mileage
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Average Weekly Mileage")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: Spacing.s) {
                        ForEach(AverageMileage.allCases, id: \.self) { mileage in
                            MileageSelectionRow(
                                mileage: mileage,
                                isSelected: profile.averageMileage == mileage
                            ) {
                                profile.averageMileage = mileage
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
            }
            .padding(.bottom, Spacing.xxxl)
        }
        .onAppear {
            loadInitialValues()
        }
    }
    
    // MARK: - Imperial Height Picker
    private var heightImperialPicker: some View {
        HStack(spacing: Spacing.m) {
            // Feet
            VStack(spacing: Spacing.xs) {
                Text("Feet")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Picker("Feet", selection: $heightFeet) {
                    ForEach(3...7, id: \.self) { feet in
                        Text("\(feet)").tag(feet)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 120)
                .clipped()
                .onChange(of: heightFeet) { _, newValue in
                    profile.height = Height.fromImperial(feet: newValue, inches: heightInches)
                }
            }
            
            // Inches
            VStack(spacing: Spacing.xs) {
                Text("Inches")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Picker("Inches", selection: $heightInches) {
                    ForEach(0...11, id: \.self) { inches in
                        Text("\(inches)").tag(inches)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 120)
                .clipped()
                .onChange(of: heightInches) { _, newValue in
                    profile.height = Height.fromImperial(feet: heightFeet, inches: newValue)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Metric Height Picker
    private var heightMetricPicker: some View {
        VStack(spacing: Spacing.xs) {
            Text("Centimeters")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Picker("Height", selection: $heightCentimeters) {
                ForEach(Array(stride(from: 140, through: 220, by: 1)), id: \.self) { cm in
                    Text("\(Int(cm)) cm").tag(Double(cm))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            .clipped()
            .onChange(of: heightCentimeters) { _, newValue in
                profile.height = Height(feet: nil, inches: nil, centimeters: newValue)
            }
        }
    }
    
    // MARK: - Imperial Weight Picker
    private var weightImperialPicker: some View {
        VStack(spacing: Spacing.xs) {
            Text("Pounds")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Picker("Weight", selection: $weightPounds) {
                ForEach(Array(stride(from: 80, through: 350, by: 1)), id: \.self) { lbs in
                    Text("\(Int(lbs)) lbs").tag(Double(lbs))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            .clipped()
            .onChange(of: weightPounds) { _, newValue in
                profile.weight = Weight.fromPounds(newValue)
            }
        }
    }
    
    // MARK: - Metric Weight Picker
    private var weightMetricPicker: some View {
        VStack(spacing: Spacing.xs) {
            Text("Kilograms")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Picker("Weight", selection: $weightKilograms) {
                ForEach(Array(stride(from: 35, through: 160, by: 1)), id: \.self) { kg in
                    Text("\(Int(kg)) kg").tag(Double(kg))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            .clipped()
            .onChange(of: weightKilograms) { _, newValue in
                profile.weight = Weight.fromKilograms(newValue)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func loadInitialValues() {
        if let feet = profile.height.feet {
            heightFeet = feet
        }
        if let inches = profile.height.inches {
            heightInches = inches
        }
        if let cm = profile.height.centimeters {
            heightCentimeters = cm
        }
        if let lbs = profile.weight.pounds {
            weightPounds = lbs
        }
        if let kg = profile.weight.kilograms {
            weightKilograms = kg
        }
    }
    
    private func updateHeightWeight() {
        if profile.measurementSystem == .imperial {
            // Convert from metric to imperial
            if let cm = profile.height.centimeters {
                let height = Height.fromCentimeters(cm)
                heightFeet = height.feet ?? 5
                                heightInches = height.inches ?? 8
                                profile.height = height
                            }
                            if let kg = profile.weight.kilograms {
                                let weight = Weight.fromKilograms(kg)
                                weightPounds = weight.pounds ?? 150
                                profile.weight = weight
                            }
                        } else {
                            // Convert from imperial to metric
                            let height = Height.fromImperial(feet: heightFeet, inches: heightInches)
                            heightCentimeters = height.centimeters ?? 173
                            profile.height = height
                            
                            let weight = Weight.fromPounds(weightPounds)
                            weightKilograms = weight.kilograms ?? 68
                            profile.weight = weight
                        }
                    }
                }

                // MARK: - Measurement System Button
                struct MeasurementSystemButton: View {
                    let system: MeasurementSystem
                    let isSelected: Bool
                    let action: () -> Void
                    
                    var body: some View {
                        Button(action: action) {
                            VStack(spacing: Spacing.s) {
                                Image(systemName: system == .imperial ? "ruler" : "ruler.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                                
                                Text(system.rawValue)
                                    .font(.bodyLarge)
                                    .foregroundColor(.textPrimary)
                                
                                Text(system == .imperial ? "ft, in, lbs" : "cm, kg")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.l)
                            .background(isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
                            .cornerRadius(CornerRadius.large)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.large)
                                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                            )
                        }
                    }
                }

                // MARK: - Gender Selection Row
                struct GenderSelectionRow: View {
                    let gender: Gender
                    let isSelected: Bool
                    let action: () -> Void
                    
                    var body: some View {
                        Button(action: action) {
                            HStack {
                                Image(systemName: genderIcon)
                                    .font(.system(size: 20))
                                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                                    .frame(width: 32)
                                
                                Text(gender.rawValue)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(Spacing.m)
                            .background(isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
                            .cornerRadius(CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                            )
                        }
                    }
                    
                    private var genderIcon: String {
                        switch gender {
                        case .male: return "figure.stand"
                        case .female: return "figure.stand.dress"
                        case .custom: return "person.fill.questionmark"
                        }
                    }
                }

                // MARK: - Mileage Selection Row
                struct MileageSelectionRow: View {
                    let mileage: AverageMileage
                    let isSelected: Bool
                    let action: () -> Void
                    
                    var body: some View {
                        Button(action: action) {
                            HStack {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 20))
                                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                                    .frame(width: 32)
                                
                                Text(mileage.rawValue)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(Spacing.m)
                            .background(isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
                            .cornerRadius(CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                            )
                        }
                    }
                }

                #Preview {
                    PhysicalProfileStep(profile: .constant(UserProfile()))
                }
