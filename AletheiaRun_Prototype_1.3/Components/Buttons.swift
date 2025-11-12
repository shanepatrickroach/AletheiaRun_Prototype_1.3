//
//  Buttons.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/3/25.
//

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    LinearGradient(
                        colors: isEnabled ? [.primaryOrange, .primaryLight] : [.textTertiary, .textTertiary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(30)
                .shadow(color: isEnabled ? .primaryOrange.opacity(0.4) : .clear, radius: 12, x: 0, y: 4)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.3)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isSelected: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .black : .primaryOrange)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    isSelected ? Color.primaryOrange : Color.white.opacity(0.1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
                )
                .cornerRadius(30)
        }
    }
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    let action: () -> Void
    var isActive: Bool = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isActive ? .black : .textTertiary)
                .frame(width: 50, height: 50)
                .background(isActive ? Color.primaryOrange : Color.white.opacity(0.1))
                .clipShape(Circle())
                .shadow(color: isActive ? .primaryOrange.opacity(0.4) : .clear, radius: 8, x: 0, y: 2)
        }
    }
}
