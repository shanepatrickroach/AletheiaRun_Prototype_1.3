//
//  NotesTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//


//
//  NotesTab.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Notes Tab
/// Allows coaches to add and view notes about a runner
struct NotesTab: View {
    let runner: Runner
    @ObservedObject var viewModel: CoachModeViewModel
    
    @State private var isEditing = false
    @State private var editedNotes: String
    
    init(runner: Runner, viewModel: CoachModeViewModel) {
        self.runner = runner
        self.viewModel = viewModel
        _editedNotes = State(initialValue: runner.notes)
    }
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header
            HStack {
                Text("Coach Notes")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if isEditing {
                    Button(action: saveNotes) {
                        Text("Save")
                            .font(.bodyMedium)
                            .foregroundColor(.primaryOrange)
                    }
                } else {
                    Button(action: { isEditing = true }) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.primaryOrange)
                    }
                }
            }
            
            // Notes Content
            if isEditing {
                notesEditor
            } else {
                notesDisplay
            }
            
            // Quick Templates
            if isEditing {
                quickTemplates
            }
        }
    }
    
    // MARK: - Notes Editor
    private var notesEditor: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Edit Notes")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            
            TextEditor(text: $editedNotes)
                .foregroundColor(.textPrimary)
                .font(.bodyMedium)
                .padding(Spacing.s)
                .frame(minHeight: 200)
                .background(Color.backgroundBlack)
                .cornerRadius(CornerRadius.small)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                )
            
            HStack {
                Text("\(editedNotes.count) characters")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                Spacer()
                
                Button(action: { 
                    editedNotes = runner.notes
                    isEditing = false 
                }) {
                    Text("Cancel")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Notes Display
    private var notesDisplay: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            if runner.notes.isEmpty {
                // Empty state
                VStack(spacing: Spacing.m) {
                    Image(systemName: "note.text")
                        .font(.system(size: 60))
                        .foregroundColor(.textTertiary)
                    
                    Text("No notes yet")
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Add notes about this athlete's progress, goals, or training plan")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { isEditing = true }) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Notes")
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.backgroundBlack)
                        .padding(.horizontal, Spacing.l)
                        .padding(.vertical, Spacing.s)
                        .background(Color.primaryOrange)
                        .cornerRadius(CornerRadius.large)
                    }
                    .padding(.top, Spacing.s)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xxl)
            } else {
                // Display notes
                Text(runner.notes)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Quick Templates
    private var quickTemplates: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Quick Templates")
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.s) {
                    TemplateButton(
                        title: "Training Goals",
                        icon: "target",
                        action: { addTemplate("Training Goals:\n- \n- \n- ") }
                    )
                    
                    TemplateButton(
                        title: "Injury Notes",
                        icon: "bandage.fill",
                        action: { addTemplate("Injury History:\n\nCurrent Status:\n\nPrecautions:") }
                    )
                    
                    TemplateButton(
                        title: "Race Plan",
                        icon: "flag.checkered",
                        action: { addTemplate("Race: \nDate: \nGoal Time: \n\nStrategy:\n") }
                    )
                    
                    TemplateButton(
                        title: "Weekly Review",
                        icon: "calendar.badge.clock",
                        action: { addTemplate("Week of \(Date().formatted(.dateTime.month().day())):\n\nHighlights:\n\nAreas to improve:\n") }
                    )
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Helper Methods
    private func saveNotes() {
        var updatedRunner = runner
        updatedRunner.notes = editedNotes
        viewModel.updateRunner(updatedRunner)
        isEditing = false
    }
    
    private func addTemplate(_ template: String) {
        if editedNotes.isEmpty {
            editedNotes = template
        } else {
            editedNotes += "\n\n" + template
        }
    }
}

// MARK: - Template Button
struct TemplateButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.primaryOrange)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
            .padding(.vertical, Spacing.m)
            .background(Color.backgroundBlack)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        ScrollView {
            NotesTab(
                runner: Runner.sampleRunners[0],
                viewModel: CoachModeViewModel()
            )
            .padding()
        }
    }
}