//
//  ForcePortraitThumbnail.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/21/25.
//

import SwiftUI

// MARK: - Force Portrait Thumbnail
/// Displays a small Force Portrait visualization with color-coded score
/// Used in run cards, interval cards, and calendar views
struct ForcePortraitThumbnail: View {
    let score: Int
    let size: CGSize
    
    // Convenience initializers for common sizes
    init(score: Int) {
        self.score = score
        self.size = CGSize(width: 90, height: 75)
    }
    
    init(score: Int, width: CGFloat, height: CGFloat) {
        self.score = score
        self.size = CGSize(width: width, height: height)
    }
    
    init(score: Int, size: CGSize) {
        self.score = score
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.backgroundBlack)
            
            // Placeholder Force Portrait (will be replaced with actual image)
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: size.height * 0.4))
                .foregroundColor(scoreColor.opacity(0.8))
            
            // Border with score color
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .stroke(scoreColor.opacity(0.5), lineWidth: 2)
        }
        .frame(width: size.width, height: size.height)
    }
    
    private var scoreColor: Color {
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .warningYellow
        } else {
            return .errorRed
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.backgroundBlack.ignoresSafeArea()
        
        VStack(spacing: Spacing.m) {
            Text("Force Portrait Thumbnails")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.m) {
                VStack {
                    ForcePortraitThumbnail(score: 92)
                    Text("High (92)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                VStack {
                    ForcePortraitThumbnail(score: 68)
                    Text("Medium (68)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                VStack {
                    ForcePortraitThumbnail(score: 45)
                    Text("Low (45)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding()
    }
}