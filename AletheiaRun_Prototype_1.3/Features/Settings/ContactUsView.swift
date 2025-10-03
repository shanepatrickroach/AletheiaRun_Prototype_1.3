//
//  ContactUsView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/ContactUsView.swift

import SwiftUI

struct ContactUsView: View {
    @State private var subject = ""
    @State private var message = ""
    @State private var selectedTopic: ContactTopic = .general
    @State private var showingSuccessAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    enum ContactTopic: String, CaseIterable {
        case general = "General Question"
        case technical = "Technical Issue"
        case sensor = "Sensor Problem"
        case billing = "Billing Question"
        case feature = "Feature Request"
        case other = "Other"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryOrange)
                        
                        Text("Contact Us")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("We typically respond within 24 hours")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Contact Form
                    VStack(spacing: Spacing.m) {
                        // Topic Picker
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Topic")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Menu {
                                ForEach(ContactTopic.allCases, id: \.self) { topic in
                                    Button(topic.rawValue) {
                                        selectedTopic = topic
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedTopic.rawValue)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textTertiary)
                                }
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.small)
                            }
                        }
                        
                        // Subject
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Subject")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            TextField("Brief description", text: $subject)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .padding(Spacing.m)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.small)
                        }
                        
                        // Message
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Message")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            TextEditor(text: $message)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .frame(height: 150)
                                .padding(Spacing.s)
                                .background(Color.cardBackground)
                                .cornerRadius(CornerRadius.small)
                        }
                        
//                        // Send Button
//                        PrimaryButton(
//                            title: "Send Message",
//                            icon: "paperplane.fill"
//                        ) {
//                            sendMessage()
//                        }
                        .disabled(subject.isEmpty || message.isEmpty)
                        .opacity((subject.isEmpty || message.isEmpty) ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text("Other Ways to Reach Us")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, Spacing.m)
                        
                        VStack(spacing: Spacing.s) {
                            ContactMethodRow(
                                icon: "envelope",
                                title: "Email",
                                value: "support@aletheia.run",
                                action: {
                                    if let url = URL(string: "mailto:support@aletheia.run") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            )
                            
                            ContactMethodRow(
                                icon: "bubble.left.and.bubble.right",
                                title: "Live Chat",
                                value: "Available Mon-Fri, 9AM-5PM EST",
                                action: {
                                    // Open live chat
                                }
                            )
                            
                            ContactMethodRow(
                                icon: "phone",
                                title: "Phone",
                                value: "+1 (555) 123-4567",
                                action: {
                                    if let url = URL(string: "tel:+15551234567") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, Spacing.m)
                    }
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Message Sent!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("We've received your message and will respond within 24 hours.")
        }
    }
    
    private func sendMessage() {
        // TODO: Implement actual message sending
        showingSuccessAlert = true
    }
}

// MARK: - Contact Method Row
struct ContactMethodRow: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryOrange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text(value)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
        }
    }
}

#Preview {
    NavigationStack {
        ContactUsView()
    }
}
