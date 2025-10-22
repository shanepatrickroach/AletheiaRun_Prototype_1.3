//
//  EditRunnerView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Edit Runner View
/// Modal view for editing an existing runner's information
struct EditRunnerView: View {
    let runner: Runner
    @ObservedObject var viewModel: CoachModeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var notes: String
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(runner: Runner, viewModel: CoachModeViewModel) {
        self.runner = runner
        self.viewModel = viewModel
        _firstName = State(initialValue: runner.firstName)
        _lastName = State(initialValue: runner.lastName)
        _email = State(initialValue: runner.email)
        _notes = State(initialValue: runner.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        VStack(spacing: Spacing.m) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryOrange.opacity(0.2))
                                
                                Text(runner.initials)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.primaryOrange)
                            }
                            .frame(width: 80, height: 80)
                            
                            Text("Edit Athlete")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(.top, Spacing.xl)
                        
                        // Form Fields
                        VStack(spacing: Spacing.m) {
                            FormField(
                                label: "First Name",
                                placeholder: "Enter first name",
                                text: $firstName
                            )
                            
                            FormField(
                                label: "Last Name",
                                placeholder: "Enter last name",
                                text: $lastName
                            )
                            
                            FormField(
                                label: "Email",
                                placeholder: "athlete@email.com",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            
                            // Notes field
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Notes")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                
                                TextEditor(text: $notes)
                                    .foregroundColor(.textPrimary)
                                    .font(.bodyMedium)
                                    .padding(Spacing.s)
                                    .frame(height: 120)
                                    .background(Color.cardBackground)
                                    .cornerRadius(CornerRadius.small)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.small)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, Spacing.m)
                        
                        // Action Buttons
                        VStack(spacing: Spacing.m) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(.bodyLarge)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.backgroundBlack)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Spacing.m)
                                    .background(canSave ? Color.primaryOrange : Color.textTertiary)
                                    .cornerRadius(CornerRadius.large)
                            }
                            .disabled(!canSave)
                            
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(.horizontal, Spacing.m)
                    }
                    .padding(.bottom, Spacing.xxl)
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var canSave: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidEmail(email) &&
        hasChanges
    }
    
    private var hasChanges: Bool {
        firstName != runner.firstName ||
        lastName != runner.lastName ||
        email != runner.email ||
        notes != runner.notes
    }
    
    // MARK: - Methods
    private func saveChanges() {
        var updatedRunner = runner
        updatedRunner.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedRunner.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedRunner.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        updatedRunner.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateRunner(updatedRunner)
        dismiss()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Preview
#Preview {
    EditRunnerView(
        runner: Runner.sampleRunners[0],
        viewModel: CoachModeViewModel()
    )
}