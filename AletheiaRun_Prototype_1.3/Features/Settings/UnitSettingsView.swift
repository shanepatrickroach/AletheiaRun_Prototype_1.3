import SwiftUI

// MARK: - Units Settings View
struct UnitSettingsView: View {
    @State private var selectedSystem: UnitSystemType = .imperial
    
    var body: some View {
        ZStack {
            Color.backgroundBlack.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Unit system selector
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text("Measurement System")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        VStack(spacing: Spacing.m) {
                            // Imperial option
                            UnitSystemCard(
                                system: .imperial,
                                isSelected: selectedSystem == .imperial,
                                action: { selectedSystem = .imperial }
                            )
                            
                            // Metric option
                            UnitSystemCard(
                                system: .metric,
                                isSelected: selectedSystem == .metric,
                                action: { selectedSystem = .metric }
                            )
                        }
                    }
                    
                    // Preview card
                    VStack(alignment: .leading, spacing: Spacing.m) {
                        Text("Preview")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        
                        VStack(spacing: 0) {
                            PreviewRow(
                                label: "Distance",
                                value: selectedSystem == .imperial ? "5.00 mi" : "8.05 km"
                            )
                            
                            Divider().background(Color.cardBorder)
                            
                            PreviewRow(
                                label: "Pace",
                                value: selectedSystem == .imperial ? "8:30 /mi" : "5:17 /km"
                            )
                            
                            Divider().background(Color.cardBorder)
                            
                            PreviewRow(
                                label: "Height",
                                value: selectedSystem == .imperial ? "5' 10\"" : "178 cm"
                            )
                            
                            Divider().background(Color.cardBorder)
                            
                            PreviewRow(
                                label: "Weight",
                                value: selectedSystem == .imperial ? "165 lbs" : "75 kg"
                            )
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(CornerRadius.small)
                    }
                    .padding(Spacing.m)
                    .background(Color.cardBackground)
                    .cornerRadius(CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.m)
            }
        }
        .navigationTitle("Units")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Unit System Type
enum UnitSystemType {
    case imperial
    case metric
    
    var displayName: String {
        switch self {
        case .imperial: return "Imperial"
        case .metric: return "Metric"
        }
    }
    
    var description: String {
        switch self {
        case .imperial: return "Miles, feet, pounds"
        case .metric: return "Kilometers, centimeters, kilograms"
        }
    }
    
    var icon: String {
        switch self {
        case .imperial: return "ruler"
        case .metric: return "ruler.fill"
        }
    }
}

// MARK: - Unit System Card Component
struct UnitSystemCard: View {
    let system: UnitSystemType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.m) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryOrange.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: system.icon)
                        .font(.titleMedium)
                        .foregroundColor(isSelected ? .primaryOrange : .textTertiary)
                }
                
                // Text
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(system.displayName)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(system.description)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.titleMedium)
                        .foregroundColor(.primaryOrange)
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

// MARK: - Preview Row Component
struct PreviewRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.s)
    }
}


// MARK: - Preview
#Preview("Units") {
    NavigationView {
        UnitSettingsView()
    }
}
