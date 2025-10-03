//
//  RunListView.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/13/25.
//


// Features/Library/RunListView.swift (NEW FILE)

import SwiftUI

struct RunListView: View {
    let runs: [Run]
    let onLikeTap: (Run) -> Void
    let onRunTap: (Run) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.m) {
                ForEach(runs) { run in
                    RunListCard(
                        run: run,
                        onLikeTap: {
                            onLikeTap(run)
                        }
                    )
                    .onTapGesture {
                        onRunTap(run)
                    }
                }
            }
            .padding(.horizontal, Spacing.l)
            .padding(.bottom, Spacing.xxxl)
        }
    }
}

// MARK: - Run List Card
struct RunListCard: View {
    let run: Run
    let onLikeTap: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Force Portrait Thumbnail
            ForcePortraitThumbnail(score: Double(run.metrics.efficiency))
            
            // Run Info
            VStack(alignment: .leading, spacing: Spacing.s) {
                // Header
                HStack {
                    // Mode Badge
                    HStack(spacing: 4) {
                        Image(systemName: run.mode.icon)
                            .font(.system(size: 10))
                        Text(run.mode.rawValue)
                            .font(.caption)
                    }
                    
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    
                    .cornerRadius(CornerRadius.small)
                    
                    // Terrain Badge
                    HStack(spacing: 4) {
                        Image(systemName: run.terrain.icon)
                            .font(.system(size: 10))
                        Text(run.terrain.rawValue)
                            .font(.caption)
                    }
                    
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, 4)
                    
                    .cornerRadius(CornerRadius.small)
                    
                    Spacer()
                    
                    // Like Button
                    Button(action: onLikeTap) {
                        Image(systemName: run.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(run.isLiked ? .errorRed : .textTertiary)
                    }
                }
                
                // Stats
                HStack(spacing: Spacing.l) {
                    StatLabel(icon: "ruler", value: String(run.distance))
                    StatLabel(icon: "clock", value: String(run.duration))
                    StatLabel(icon: "speedometer", value: "run.pace" + "/mi")
                }
                
                // Perspectives
                HStack(spacing: Spacing.xs) {
                    ForEach(Array(run.perspectives).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { perspective in
                        Image(systemName: perspective.icon)
                            .font(.system(size: 12))
                            .foregroundColor(perspective.color)
                    }
                    
                    Spacer()
                    
                    // Date
                    Text(run.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.large)
    }
}

struct StatLabel: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.textTertiary)
            
            Text(value)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Force Portrait Thumbnail
struct ForcePortraitThumbnail: View {
    let score: Double
    
    private var scoreColor: Color {
        if score >= 80 { return .successGreen }
        if score >= 60 { return .warningYellow }
        return .errorRed
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.backgroundBlack)
                .frame(width: 90, height: 75)
            
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 32))
                .foregroundColor(.primaryOrange.opacity(0.3))
            
            // Score overlay
            VStack(spacing: 2) {
                Spacer()
                Text("\(Int(score))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(scoreColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.backgroundBlack.opacity(0.8))
                    .cornerRadius(4)
            }
            .padding(4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    RunListView(
        runs: SampleData.generateRuns(count: 10),
        onLikeTap: { _ in },
        onRunTap: { _ in }
    )
    .background(Color.backgroundBlack)
}
