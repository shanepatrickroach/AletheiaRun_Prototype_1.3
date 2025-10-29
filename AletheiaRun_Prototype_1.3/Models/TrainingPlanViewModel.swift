//
//  TrainingPlanViewModel.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

//
//  TrainingPlanViewModel.swift
//  AletheiaRun_Prototype_1.3
//
//  Created by Shane Roach on 10/22/25.
//

import Combine
import Foundation

// MARK: - Training Plan View Model
class TrainingPlanViewModel: ObservableObject {
    @Published var currentPlan: TrainingPlan?
    
    @Published var selectedMetricFilter: ExerciseMetric?
    @Published var selectedLevelFilter: ExerciseLevel?
    @Published var optimalDifficultySort: ExerciseLevel?
    

    // Generate a training plan based on current metrics
    func generatePlan(
        metrics: [ExerciseMetric: Int],
        painPoints: [PainPoint] = []
    ) {

        var selectedExercises: [Exercise] = []

        // For each metric, select appropriate level exercises
        for (metric, score) in metrics {
            let level = ExerciseLevel.forScore(score)
            let availableExercises = Exercise.sampleLibrary.filter {
                $0.targetMetric == metric && $0.level == level
            }

            // Add 1-2 exercises per metric
            if let exercise = availableExercises.randomElement() {
                selectedExercises.append(exercise)
            }
        }

        // Add pain-specific exercises
        // In a real app, would have pain-specific exercise library

        self.currentPlan = TrainingPlan(
            exercises: selectedExercises,
            targetedMetrics: metrics,
            painPoints: painPoints
        )

       

    }

    // Mark exercise as completed
    func completeExercise(_ exercise: Exercise) {
        guard var plan = currentPlan else { return }

        if let index = plan.exercises.firstIndex(where: { $0.id == exercise.id }
        ) {
            var updatedExercise = exercise
            updatedExercise.isCompleted = true
            updatedExercise.lastCompletedDate = Date()

            var updatedExercises = plan.exercises
            updatedExercises[index] = updatedExercise

            currentPlan = TrainingPlan(
                id: plan.id,
                generatedDate: plan.generatedDate,
                exercises: updatedExercises,
                targetedMetrics: plan.targetedMetrics,
                painPoints: plan.painPoints
            )
        }
    }

    // Reset exercise completion
    func resetExercise(_ exercise: Exercise) {
        guard var plan = currentPlan else { return }

        if let index = plan.exercises.firstIndex(where: { $0.id == exercise.id }
        ) {
            var updatedExercise = exercise
            updatedExercise.isCompleted = false
            updatedExercise.lastCompletedDate = nil

            var updatedExercises = plan.exercises
            updatedExercises[index] = updatedExercise

            currentPlan = TrainingPlan(
                id: plan.id,
                generatedDate: plan.generatedDate,
                exercises: updatedExercises,
                targetedMetrics: plan.targetedMetrics,
                painPoints: plan.painPoints
            )
        }
    }

    // Filter exercises
    var filteredExercises: [Exercise] {
        guard let plan = currentPlan else { return [] }

        return plan.exercises.filter { exercise in
            let matchesMetric =
                selectedMetricFilter == nil
                || exercise.targetMetric == selectedMetricFilter
            let matchesLevel =
                selectedLevelFilter == nil
                || exercise.level == selectedLevelFilter
            return matchesMetric && matchesLevel
        }
    }
    
    
    var sortedExercises: [Exercise] {
        guard let plan = currentPlan else { return [] }
        
        
        return plan.exercises.sorted { $0.difficultyRating < $1.difficultyRating }
    }
}
