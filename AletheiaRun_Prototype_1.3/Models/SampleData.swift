//
//  SampleData.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//

import Foundation

struct SampleData {

    static let runs: [Run] = generateRuns(count: 30)



    static func generateRuns(count: Int = 60) -> [Run] {
        var runs: [Run] = []
        let calendar = Calendar.current

        for i in 0..<count {
            let daysAgo = count - i - 1
            let date = calendar.date(
                byAdding: .day, value: -daysAgo, to: Date())!

            // Random values
            let distance = Double.random(in: 2.0...12.0)
            let minutesPerMile = Double.random(in: 7.0...10.0)
            let duration = distance * minutesPerMile * 60

            let paceMinutes = Int(minutesPerMile)
            let paceSeconds = Int(
                (minutesPerMile - Double(paceMinutes)) * 60)
            let pace = String(format: "%d:%02d", paceMinutes, paceSeconds)

            // Random perspectives (sometimes not all)
            var perspectives: Set<PerspectiveType> = []
            if Bool.random() { perspectives.insert(.top) }
            if Bool.random() { perspectives.insert(.side) }
            if Bool.random() { perspectives.insert(.rear) }
            if perspectives.isEmpty { perspectives = [.top, .side, .rear] }  // At least one

            let run = Run(
                date: date,
                mode: RunMode.allCases.randomElement()!,
                terrain: TerrainType.allCases.randomElement()!,
                distance: distance,
                duration: duration,

                metrics: RunMetrics(
                    efficiency: Int.random(in: 50...95),
                    braking: Int.random(in: 50...95),
                    impact: Int.random(in: 50...95),
                    sway: Int.random(in: 50...95),
                    variation: Int.random(in: 50...95),
                    warmup: Int.random(in: 50...95),
                    endurance: Int.random(in: 50...95)
                ),
                gaitCycleMetrics: randomGaitCycleMetrics(),
                perspectives: perspectives,
                isLiked: Bool.random() && Bool.random()
                

            )

            runs.append(run)
        }

        return runs.sorted { $0.date > $1.date }
    }

    static func populateCalendarWithSampleData() -> CalendarViewModel {
        let viewModel = CalendarViewModel()
        viewModel.runs = generateRuns()
        return viewModel
    }

    
    
    
    
    static func randomGaitCycleMetrics() -> GaitCycleMetrics {
        // Generate base percentages
        let baseLanding = Double.random(in: 5...18)
        let baseStabilizing = Double.random(in: 5...25)
        let baseLaunching = Double.random(in: 5...18)
        let baseFlying = 100 - baseLanding - baseStabilizing - baseLaunching
        
        // Add slight asymmetry between legs (realistic)
        let asymmetryFactor = Double.random(in: -2...2)
        
        let leftLeg = LegGaitCycle(
            landing: baseLanding + asymmetryFactor,
            stabilizing: baseStabilizing - asymmetryFactor * 0.5,
            launching: baseLaunching + asymmetryFactor * 0.3,
            flying: baseFlying - asymmetryFactor * 0.8
        )
        
        let rightLeg = LegGaitCycle(
            landing: baseLanding - asymmetryFactor,
            stabilizing: baseStabilizing + asymmetryFactor * 0.5,
            launching: baseLaunching - asymmetryFactor * 0.3,
            flying: baseFlying + asymmetryFactor * 0.8
        )
        
        return GaitCycleMetrics(
            leftLeg: leftLeg,
            rightLeg: rightLeg,
            contactTime: Double.random(in: 220...280),
            flightTime: Double.random(in: 80...120),
            cadence: Int.random(in: 160...185)
        )
    }

}
