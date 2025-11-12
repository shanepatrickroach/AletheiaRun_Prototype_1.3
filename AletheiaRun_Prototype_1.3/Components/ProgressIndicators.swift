//
//  ProgressIndicators.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 11/6/25.
//
import SwiftUI

struct RotatingArc: View {
    @State private var rotation: Angle = .degrees(0)
    var color: Color = .primaryOrange
    var size: CGFloat = 40

    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(rotation)
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = .degrees(360)
                }
            }
    }
}
