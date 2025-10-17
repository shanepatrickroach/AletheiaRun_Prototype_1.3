
import SwiftUI

// MARK: - Edit Profile View (Placeholder)
struct EditProfileView: View {
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryOrange)
                }
                
                // Title and message
                VStack(spacing: Spacing.m) {
                    Text("Edit Profile")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Edit your personal information, physical profile, and running goals")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                }
                
                // Preview features
                VStack(alignment: .leading, spacing: Spacing.s) {
                    EditProfileFeatureRow(text: "Update name and contact info")
                    EditProfileFeatureRow(text: "Change profile photo")
                    EditProfileFeatureRow(text: "Edit height and weight")
                    EditProfileFeatureRow(text: "Adjust running goals")
                }
                .padding(Spacing.m)
                .background(Color.cardBackground)
                .cornerRadius(CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
                .padding(.horizontal, Spacing.m)
                
                Spacer()
                
                // Coming soon badge
                Text("Profile editing coming soon")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.bottom, Spacing.xl)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Feature Row Component
struct EditProfileFeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(.primaryOrange)
            
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EditProfileView()
    }
}
