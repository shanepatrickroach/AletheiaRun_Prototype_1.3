//
//  SampleData.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/6/25.
//

import Foundation

struct SampleData {
    
    static let runs: [Run] = generateRuns(count: 30)

//    static let runs: [Run] = createSampleRuns()

    //    static func createSampleRuns() -> [Run] {
    //        let calendar = Calendar.current
    //        var runs: [Run] = []
    //
    //        // Create runs for the past 30 days
    //        for i in 0..<30 {
    //            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
    //
    //            // Skip some days randomly to make it realistic
    //            if Int.random(in: 0...2) == 0 {
    //                continue
    //            }
    //
    //            let run = Run(
    //                date: date,
    //                mode: RunMode.allCases.randomElement() ?? .run,
    //                terrain: TerrainType.allCases.randomElement() ?? .road,
    //                distance: Double.random(in: 2.0...10.0),
    //                duration: Double.random(in: 1200...3600),
    //                metrics: RunMetrics(
    //                    efficiency: Int.random(in: 50...95),
    //                    sway: Int.random(in: 50...95),
    //                    endurance: Int.random(in: 50...95),
    //                    warmup: Int.random(in: 50...95),
    //                    impact: Int.random(in: 50...95),
    //                    braking: Int.random(in: 50...95),
    //                    variation: Int.random(in: 50...95)
    //                )
    //            )
    //
    //            runs.append(run)
    //        }
    //
    //        return runs.sorted { $0.date > $1.date }
    //    }

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
                    sway: Int.random(in: 50...95),
                    endurance: Int.random(in: 50...95),
                    warmup: Int.random(in: 50...95),
                    impact: Int.random(in: 50...95),
                    braking: Int.random(in: 50...95),
                    variation: Int.random(in: 50...95)
                ),
                perspectives: perspectives,
                isLiked: Bool.random() && Bool.random()  // ~25% chance

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

}
