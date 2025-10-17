//
//  AboutView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/AboutView.swift

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // App Icon and Info
                    VStack(spacing: Spacing.m) {
                        // App Icon placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [.primaryOrange.opacity(0.5), .black],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Image("LogoGradient")
                                .resizable()
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .frame(width:80, height: 80)
                               
                        }
                        
                        Text("Aletheia Run")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("Version 1.0.0 (Build 1)")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Description
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text("About Aletheia")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        Text("Aletheia uses Force Portrait technology to analyze your running biomechanics. Our advanced sensor captures detailed data about your form, helping you run more efficiently and reduce injury risk.")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.m)
                    
                    // Links
                    SettingsSection(title: "Learn More") {
                        SettingsActionRow(
                            icon: "globe",
                            title: "Website",
                            description: "Visit aletheia.run",
                            action: { openURL("https://aletheia.run") }
                        )
                        
                        SettingsActionRow(
                            icon: "doc.text",
                            title: "Terms of Service",
                            description: "Read our terms",
                            action: { }
                        )
                        
                        SettingsActionRow(
                            icon: "hand.raised",
                            title: "Privacy Policy",
                            description: "How we protect your data",
                            action: { }
                        )
                        
                        SettingsActionRow(
                            icon: "doc.badge.gearshape",
                            title: "Licenses",
                            description: "Open source acknowledgments",
                            action: { }
                        )
                    }
                    
                    // Credits
                    VStack(spacing: Spacing.s) {
                        Text("Made with ❤️ for runners")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("© 2025 Aletheia Run. All rights reserved.")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.top, Spacing.m)
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
