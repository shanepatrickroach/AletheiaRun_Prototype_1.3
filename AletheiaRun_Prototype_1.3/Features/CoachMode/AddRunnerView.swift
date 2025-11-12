//
//  AddRunnerView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

//
//  AddRunnerView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Add Runner View
/// Modal view for adding a new runner to coach mode
struct AddRunnerView: View {
    @ObservedObject var viewModel: CoachModeViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var notes = ""
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header Icon
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.primaryOrange)
                            .padding(.top, Spacing.xl)

                        // Form Fields
                        VStack(spacing: Spacing.m) {
                            

                            FormField(
                                label: "Email",
                                placeholder: "athlete@email.com",
                                text: $email,
                                keyboardType: .emailAddress
                            )


                        }
                        .padding(.horizontal, Spacing.m)

                        // Action Buttons
                        VStack(spacing: Spacing.m) {
                            Button(action: addRunner) {
                                Text("Add Athlete")
                                    .font(.bodyLarge)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.backgroundBlack)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Spacing.m)
                                    .background(
                                        canAdd
                                            ? Color.primaryOrange
                                            : Color.textTertiary
                                    )
                                    .cornerRadius(CornerRadius.large)
                            }
                            .disabled(!canAdd)

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
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: - Computed Properties
    private var canAdd: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && isValidEmail(email)
    }

    // MARK: - Methods
    private func addRunner() {
        let newRunner = Runner(
            firstName: firstName.trimmingCharacters(
                in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased(),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        viewModel.addRunner(newRunner)
        dismiss()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Form Field Component
struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var placeholderColor: Color = .gray

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .font(.bodyMedium)
                        .padding(Spacing.m)
                }

                TextField("", text: $text)
                    .foregroundColor(.textPrimary)
                    .font(.bodyMedium)
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                    .keyboardType(keyboardType)
                    .autocapitalization(
                        keyboardType == .emailAddress ? .none : .words
                    )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddRunnerView(viewModel: CoachModeViewModel())
}
