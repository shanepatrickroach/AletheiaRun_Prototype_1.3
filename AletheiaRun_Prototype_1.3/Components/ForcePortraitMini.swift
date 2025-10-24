import SwiftUI

struct ForcePortraitMini: View {
    let run: Run
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black
            
            // Force Portrait Image
            Image("ForcePortrait")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 80)
                .opacity(0.9)
            
            // Optional: Add a subtle overlay based on metrics
            LinearGradient(
                colors: [
                    overlayColor.opacity(0.2),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    // Color overlay based on performance
    var overlayColor: Color {
        let score = run.metrics.overallScore
        if score >= 80 {
            return .successGreen
        } else if score >= 60 {
            return .primaryOrange
        } else {
            return .errorRed
        }
    }
}

#Preview {
    ZStack {
        Color.backgroundBlack
        
        ForcePortraitMini(run: Run(
            date: Date(),
            mode: .run,
            terrain: .road,
            distance: 5.0,
            duration: 1800,
            metrics: RunMetrics(
                efficiency: 85,
                braking: 72,
                impact: 80,
                sway: 75,
                variation: 65,
                warmup: 70,
                endurance: 78
            )
        ))
        .frame(width: 100, height: 80)
    }
}
