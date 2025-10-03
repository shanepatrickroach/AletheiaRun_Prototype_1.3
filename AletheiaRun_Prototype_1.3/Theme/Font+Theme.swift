//
//  Font+Theme.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/3/25.
//

import SwiftUI

extension Font {
    // MARK: - Display
    static let displayLarge = Font.system(size: 42, weight: .bold)
    static let displayMedium = Font.system(size: 36, weight: .bold)
    
    // MARK: - Title
    static let titleLarge = Font.system(size: 32, weight: .bold)
    static let titleMedium = Font.system(size: 28, weight: .semibold)
    static let titleSmall = Font.system(size: 24, weight: .semibold)
    
    // MARK: - Headline
    static let headline = Font.system(size: 20, weight: .semibold)
    
    // MARK: - Body
    static let bodyLarge = Font.system(size: 18, weight: .medium)
    static let bodyMedium = Font.system(size: 16, weight: .medium)
    static let bodySmall = Font.system(size: 14, weight: .regular)
    
    // MARK: - Caption
    static let caption = Font.system(size: 12, weight: .regular)
}
