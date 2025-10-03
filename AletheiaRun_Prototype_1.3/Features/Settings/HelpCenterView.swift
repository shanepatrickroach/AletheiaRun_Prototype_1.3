//
//  HelpCenterView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/9/25.
//


// Features/Profile/Settings/HelpCenterView.swift

import SwiftUI

struct HelpCenterView: View {
    @State private var searchText = ""
    
    let helpTopics = [
        HelpTopic(
            icon: "sensor.fill",
            title: "Sensor Setup",
            description: "Learn how to pair and position your sensor",
            articles: ["Pairing Your Sensor", "Sensor Placement Guide", "Troubleshooting Connection"]
        ),
        HelpTopic(
            icon: "figure.run",
            title: "Recording Runs",
            description: "Everything about tracking your sessions",
            articles: ["Starting a Run", "Understanding Metrics", "Post-Run Analysis"]
        ),
        HelpTopic(
            icon: "waveform.path.ecg",
            title: "Force Portraits",
            description: "Understanding your running biomechanics",
            articles: ["What is a Force Portrait?", "Reading Your Portrait", "Improving Your Form"]
        ),
        HelpTopic(
            icon: "trophy.fill",
            title: "Achievements",
            description: "How achievements and challenges work",
            articles: ["Earning Achievements", "Active Challenges", "Streak System"]
        ),
        HelpTopic(
            icon: "gearshape.fill",
            title: "Account & Settings",
            description: "Managing your account and preferences",
            articles: ["Updating Profile", "Notification Settings", "Privacy Options"]
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    // Header
                    VStack(spacing: Spacing.s) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryOrange)
                        
                        Text("How Can We Help?")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textTertiary)
                        
                        TextField("Search help articles", text: $searchText)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.m)
                    
                    // Help Topics
                    VStack(spacing: Spacing.m) {
                        ForEach(helpTopics) { topic in
                            HelpTopicCard(topic: topic)
                        }
                    }
                    .padding(.horizontal, Spacing.m)
                    
                    // Contact Support
                    VStack(spacing: Spacing.m) {
                        Text("Still need help?")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
//                        PrimaryButton(
//                            title: "Contact Support",
//                            icon: "envelope.fill"
//                        ) {
//                            // Open contact support
//                        }
                        .padding(.horizontal, Spacing.m)
                    }
                    .padding(.top, Spacing.m)
                }
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Help Topic Model
struct HelpTopic: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let articles: [String]
}

// MARK: - Help Topic Card
struct HelpTopicCard: View {
    let topic: HelpTopic
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: Spacing.m) {
                    Image(systemName: topic.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(topic.title)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text(topic.description)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(Spacing.m)
            }
            
            // Articles List
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.cardBorder)
                    
                    ForEach(topic.articles, id: \.self) { article in
                        Button(action: {
                            // Open article
                        }) {
                            HStack {
                                Text(article)
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(.textTertiary)
                            }
                            .padding(Spacing.m)
                            .padding(.leading, 56)
                        }
                        
                        if article != topic.articles.last {
                            Divider()
                                .background(Color.cardBorder)
                                .padding(.leading, 56)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
