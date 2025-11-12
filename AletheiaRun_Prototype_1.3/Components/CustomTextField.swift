//
//  CustomTextFields.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/7/25.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    let placeholderColor: Color = .gray // Add a color property if you want

    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
                .frame(width: 24)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(placeholderColor)
                        .font(.bodyMedium)
                }
                TextField("", text: $text)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .autocorrectionDisabled()
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}


// MARK: - Custom Secure Field
struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    let placeholderColor: Color = .gray
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
                .frame(width: 24)
            
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(placeholderColor)
                        .font(.bodyMedium)
                }
                
                SecureField(placeholder, text: $text)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .autocorrectionDisabled()
            }
        }
        .padding(Spacing.m)
        .background(Color.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Password Strength Indicator
struct PasswordStrengthIndicator: View {
    let strength: PasswordStrength
    
    enum PasswordStrength {
        case weak
        case medium
        case strong
        
        var color: Color {
            switch self {
            case .weak: return .errorRed
            case .medium: return .warningYellow
            case .strong: return .successGreen
            }
        }
        
        var text: String {
            switch self {
            case .weak: return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
        
        var level: Int {
            switch self {
            case .weak: return 1
            case .medium: return 2
            case .strong: return 3
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < strength.level ? strength.color : Color.cardBorder)
                        .frame(height: 4)
                }
            }
            
            Text("Password strength: \(strength.text)")
                .font(.caption)
                .foregroundColor(strength.color)
        }
    }
}

#Preview("Text Field") {
    VStack {
        CustomTextField(
            placeholder: "Enter email",
            text: .constant("test@example.com"),
            icon: "envelope"
        )
        
        CustomSecureField(
            placeholder: "Enter password",
            text: .constant("password123"),
            icon: "lock"
        )
    }
    .padding()
    .background(Color.backgroundBlack)
}
