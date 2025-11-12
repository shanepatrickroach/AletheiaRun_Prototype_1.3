//
//  RunShareSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/5/25.
//


//
//  RunShareSheet.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by AI Assistant
//

import SwiftUI
import UIKit

/// Share sheet for sharing run data and Force Portrait
struct RunShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    let run: Run
    
    @State private var shareOption: ShareOption = .portraitWithMetrics
    @State private var selectedPerspective: PerspectiveType = .top
    @State private var includeStats: Bool = true
    @State private var customMessage: String = ""
    @State private var isGeneratingImage: Bool = false
    @State private var showingSuccessAlert: Bool = false
    @State private var generatedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundBlack.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Header
                        headerSection
                        
                        // Share options
                        shareOptionsSection
                        
                        // Perspective selector (if portrait only)
                        if shareOption == .portraitOnly {
                            perspectiveSelector
                        }
                        
                        // Stats toggle
                        //statsToggle
                        
                        // Preview
                        //sharePreviewSection
                        
                        // Custom message
                        //customMessageSection
                        
                        // Social media options
                        socialMediaSection
                        
                        // Download option
                        downloadSection
                    }
                    .padding(.horizontal, Spacing.m)
                    .padding(.vertical, Spacing.l)
                }
            }
            .navigationTitle("Share Run")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
        .alert("Shared Successfully!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your run has been shared successfully!")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Spacing.m) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 40))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(spacing: Spacing.xs) {
                Text("Share Your Run")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text(run.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
        }
    }
    
    // MARK: - Share Options Section
    private var shareOptionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("What to Share")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                ShareOptionButton(
                    option: .portraitWithMetrics,
                    isSelected: shareOption == .portraitWithMetrics,
                    action: { shareOption = .portraitWithMetrics }
                )
                
                ShareOptionButton(
                    option: .portraitOnly,
                    isSelected: shareOption == .portraitOnly,
                    action: { shareOption = .portraitOnly }
                )
                
                
            }
        }
    }
    
    // MARK: - Perspective Selector
    private var perspectiveSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Choose Perspective")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.m) {
                ForEach(PerspectiveType.allCases) { perspective in
                    RunDetailSharePerspectiveButton(
                        perspective: perspective,
                        isSelected: selectedPerspective == perspective,
                        isAvailable: run.perspectives.contains(perspective),
                        action: { selectedPerspective = perspective }
                    )
                }
            }
        }
    }
    
    // MARK: - Stats Toggle
    private var statsToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Include Run Statistics")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Distance, pace, and duration")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $includeStats)
                .labelsHidden()
                .tint(.primaryOrange)
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    // MARK: - Share Preview Section
    private var sharePreviewSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Preview")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            SharePreviewCard(
                run: run,
                shareOption: shareOption,
                selectedPerspective: selectedPerspective,
                includeStats: includeStats
            )
        }
    }
    
    // MARK: - Custom Message Section
    private var customMessageSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Add a Message (Optional)")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            TextEditor(text: $customMessage)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .frame(height: 100)
                .padding(Spacing.s)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if customMessage.isEmpty {
                            Text("e.g., Just crushed this run! 🏃‍♂️")
                                .font(.bodyMedium)
                                .foregroundColor(.textTertiary)
                                .padding(.top, Spacing.s)
                                .padding(.leading, Spacing.s + 4)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
        }
    }
    
    // MARK: - Social Media Section
    private var socialMediaSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Share To")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.s) {
                SocialMediaButton(
                    platform: .strava,
                    action: { shareToStrava() }
                )
                
                SocialMediaButton(
                    platform: .instagram,
                    action: { shareToInstagram() }
                )
                
                SocialMediaButton(
                    platform: .facebook,
                    action: { shareToFacebook() }
                )
                
                SocialMediaButton(
                    platform: .x,
                    action: { shareToX() }
                )
            }
        }
    }
    
    // MARK: - Download Section
    private var downloadSection: some View {
        VStack(spacing: Spacing.m) {
            Button(action: downloadImage) {
                HStack {
                    if isGeneratingImage {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .backgroundBlack))
                    } else {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title3)
                        
                        Text("Download Image")
                            .font(.bodyLarge)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.backgroundBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.m)
                .background(
                    LinearGradient(
                        colors: [Color.primaryOrange, Color.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(CornerRadius.medium)
                .shadow(color: Color.primaryOrange.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .disabled(isGeneratingImage)
            
            Text("Image will be saved to your Photos")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
    }
    
    // MARK: - Share Actions
    
    private func shareToStrava() {
        // Generate image first
        generateShareImage { image in
            // In real app, use Strava API or share sheet
            let message = buildShareMessage()
            shareToSocialMedia(platform: "Strava", message: message, image: image)
        }
    }
    
    private func shareToInstagram() {
        generateShareImage { image in
            guard let image = image else { return }
            
            // Instagram sharing requires saving to camera roll first
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            // Try to open Instagram with the image
            if let instagramURL = URL(string: "instagram://app") {
                if UIApplication.shared.canOpenURL(instagramURL) {
                    UIApplication.shared.open(instagramURL)
                    showingSuccessAlert = true
                } else {
                    // Instagram not installed
                    shareViaSystemSheet(image: image)
                }
            }
        }
    }
    
    private func shareToFacebook() {
        generateShareImage { image in
            let message = buildShareMessage()
            
            // Try Facebook app, fallback to web
            if let facebookURL = URL(string: "fb://") {
                if UIApplication.shared.canOpenURL(facebookURL) {
                    // Facebook app is installed
                    shareViaSystemSheet(image: image, text: message)
                } else {
                    // Open Facebook web
                    if let webURL = URL(string: "https://www.facebook.com") {
                        UIApplication.shared.open(webURL)
                    }
                }
            }
            
            showingSuccessAlert = true
        }
    }
    
    private func shareToX() {
        generateShareImage { image in
            let message = buildShareMessage()
            
            // X (Twitter) sharing
            if let xURL = URL(string: "twitter://") {
                if UIApplication.shared.canOpenURL(xURL) {
                    // X app is installed
                    shareViaSystemSheet(image: image, text: message)
                } else {
                    // Open X web with pre-filled tweet
                    let tweetText = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let webURL = URL(string: "https://twitter.com/intent/tweet?text=\(tweetText)") {
                        UIApplication.shared.open(webURL)
                    }
                }
            }
            
            showingSuccessAlert = true
        }
    }
    
    private func downloadImage() {
        isGeneratingImage = true
        
        generateShareImage { image in
            guard let image = image else {
                isGeneratingImage = false
                return
            }
            
            // Save to photo library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isGeneratingImage = false
                showingSuccessAlert = true
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func generateShareImage(completion: @escaping (UIImage?) -> Void) {
        // In real app, render the SharePreviewCard as an image
        // For now, return a placeholder
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // This is where you'd convert your SwiftUI view to UIImage
            // Using ImageRenderer (iOS 16+) or UIGraphicsImageRenderer
            
            let renderer = ImageRenderer(content: 
                SharePreviewCard(
                    run: run,
                    shareOption: shareOption,
                    selectedPerspective: selectedPerspective,
                    includeStats: includeStats
                )
                .frame(width: 400, height: 600)
            )
            
            if let image = renderer.uiImage {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    private func buildShareMessage() -> String {
        var message = customMessage
        
        if message.isEmpty {
            message = "Just completed a \(String(format: "%.1f", run.distance)) mile run!"
        }
        
        if includeStats {
            let pace = formatPace()
            message += "\n📊 Pace: \(pace)/mile"
            message += "\n⭐️ Score: \(run.metrics.overallScore)/100"
        }
        
        message += "\n\n#AletheiaRun #RunningMotivation"
        
        return message
    }
    
    private func formatPace() -> String {
        let totalMinutes = run.duration / 60
        let paceMinutesPerMile = totalMinutes / run.distance
        let minutes = Int(paceMinutesPerMile)
        let seconds = Int((paceMinutesPerMile - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func shareViaSystemSheet(image: UIImage?, text: String? = nil) {
        var itemsToShare: [Any] = []
        
        if let text = text {
            itemsToShare.append(text)
        }
        
        if let image = image {
            itemsToShare.append(image)
        }
        
        let activityVC = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func shareToSocialMedia(platform: String, message: String, image: UIImage?) {
        // Generic share function
        shareViaSystemSheet(image: image, text: message)
    }
}

// MARK: - Share Option Enum
enum ShareOption {
    case portraitWithMetrics
    case portraitOnly
   
    
    var title: String {
        switch self {
        case .portraitWithMetrics: return "Force Portrait + Metrics"
        case .portraitOnly: return "Force Portrait Only"
        
        }
    }
    
    var description: String {
        switch self {
        case .portraitWithMetrics: return "Share your complete run analysis"
        case .portraitOnly: return "Share just your Force Portrait visualization"
        
        }
    }
    
    var icon: String {
        switch self {
        case .portraitWithMetrics: return "chart.bar.doc.horizontal"
        case .portraitOnly: return "waveform.path.ecg"
        
        }
    }
}

// MARK: - Social Media Platform
enum SocialMediaPlatform {
    case strava
    case instagram
    case facebook
    case x
    
    var name: String {
        switch self {
        case .strava: return "Strava"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .x: return "X (Twitter)"
        }
    }
    
    var icon: String {
        switch self {
        case .strava: return "strava"
        case .instagram: return "instagram"
        case .facebook: return "facebook"
        case .x: return "twitter"
        }
    }
    
    var color: Color {
        switch self {
        case .strava: return Color(hex: "FC4C02")
        case .instagram: return Color(hex: "E4405F")
        case .facebook: return Color(hex: "1877F2")
        case .x: return Color(hex: "1DA1F2")
        }
    }
}

// MARK: - Share Option Button
struct ShareOptionButton: View {
    let option: ShareOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryOrange.opacity(0.2) : Color.cardBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: option.icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(option.title)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(option.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.primaryOrange)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Perspective Button
struct RunDetailSharePerspectiveButton: View {
    let perspective: PerspectiveType
    let isSelected: Bool
    let isAvailable: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryOrange.opacity(0.2) : Color.cardBackground)
                        .frame(width: 60, height: 60)
                    
                    Image(perspective.icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? Color.primaryOrange : .textSecondary)
                }
                
                Text(perspective.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            }
            .opacity(isAvailable ? 1.0 : 0.5)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? Color.primaryOrange : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
        .disabled(!isAvailable)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Social Media Button
struct SocialMediaButton: View {
    let platform: SocialMediaPlatform
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    Circle()
                        .fill(platform.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(platform.icon)
                        .font(.title3)
                        .foregroundColor(platform.color)
                }
                
                Text("Share to \(platform.name)")
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.m)
            .background(Color.cardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Share Preview Card
struct SharePreviewCard: View {
    let run: Run
    let shareOption: ShareOption
    let selectedPerspective: PerspectiveType
    let includeStats: Bool
    
    var body: some View {
        VStack(spacing: Spacing.m) {
            // Header with logo/branding
            HStack {
                Text("ALETHEIA")
                    .font(.headline)
                    .foregroundColor(.primaryOrange)
                
                Spacer()
                
                Text(run.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
//            // Force Portrait (if included)
//            if shareOption != .statsOnly {
//                VStack(spacing: Spacing.s) {
//                    // Force Portrait placeholder
//                    ZStack {
//                        RoundedRectangle(cornerRadius: CornerRadius.medium)
//                            .fill(Color.backgroundBlack)
//                            .frame(height: 200)
//                        
//                        VStack(spacing: Spacing.m) {
//                            Image(systemName: "waveform.path.ecg")
//                                .font(.system(size: 60))
//                                .foregroundColor(.primaryOrange)
//                            
//                            if shareOption == .portraitOnly {
//                                Text("\(selectedPerspective.rawValue) View")
//                                    .font(.caption)
//                                    .foregroundColor(.textSecondary)
//                            }
//                        }
//                    }
//                    .overlay(
//                        RoundedRectangle(cornerRadius: CornerRadius.medium)
//                            .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
//                    )
//                }
//            }
            
            // Stats (if included)
            if includeStats {
                HStack(spacing: Spacing.m) {
                    StatPreview(
                        icon: "figure.run",
                        value: String(format: "%.1f", run.distance),
                        label: "miles"
                    )
                    
                    StatPreview(
                        icon: "timer",
                        value: formatDuration(),
                        label: "time"
                    )
                    
                    StatPreview(
                        icon: "speedometer",
                        value: formatPace(),
                        label: "pace"
                    )
                }
            }
            
            // Metrics (if portrait with metrics)
            if shareOption == .portraitWithMetrics {
                VStack(spacing: Spacing.xs) {
                    HStack {
                        Text("Performance")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("\(run.metrics.overallScore)")
                            .font(.headline)
                            .foregroundColor(.primaryOrange)
                    }
                    
                    // Top 3 metrics
                    ForEach([
                        ("Efficiency", run.metrics.efficiency),
                        ("Endurance", run.metrics.endurance),
                        ("Impact", run.metrics.impact)
                    ], id: \.0) { metric in
                        HStack {
                            Text(metric.0)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Spacer()
                            
                            Text("\(metric.1)")
                                .font(.caption)
                                .foregroundColor(.textPrimary)
                                .fontWeight(.medium)
                        }
                    }
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
    
    private func formatDuration() -> String {
        let hours = Int(run.duration) / 3600
        let minutes = (Int(run.duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    private func formatPace() -> String {
        let totalMinutes = run.duration / 60
        let paceMinutesPerMile = totalMinutes / run.distance
        let minutes = Int(paceMinutesPerMile)
        let seconds = Int((paceMinutesPerMile - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Stat Preview Component
struct StatPreview: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.primaryOrange)
            
            Text(value)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    let sampleRun = Run(
        date: Date(),
        mode: .run,
        terrain: .road,
        distance: 5.2,
        duration: 2400,
        metrics: RunMetrics(
            efficiency: 85,
            braking: 78,
            impact: 82,
            sway: 75,
            variation: 88,
            warmup: 80,
            endurance: 77
        ),
        gaitCycleMetrics: GaitCycleMetrics(),
        perspectives: [.top, .side, .rear]
    )
    
    RunShareSheet(run: sampleRun)
}
