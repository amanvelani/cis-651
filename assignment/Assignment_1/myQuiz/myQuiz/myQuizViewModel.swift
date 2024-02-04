//
//  myQuizViewModel.swift
//  myQuiz
//
//  Created by Aman Velani on 1/31/24.
//

import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var quizModel = QuizModel()
    @Published var showSolution = true
    @Published var firstTime = true
    @Published var solutionText: String = ""

    func solveQuiz() {
        // Validate the numbers before showing solution
        guard quizModel.validateNumbers() else{
            // Provide feedback based on the state of the quiz
            if(quizModel.totalRounds == 0){
                solutionText = "Press on play!"
            }else{
                solutionText = "Error! Invalid numbers...."
            }
            return
        }
        // Update solution text and make it visible
        solutionText = quizModel.solution
        showSolution = true
    }

    func playAgain() {
        // Generate a new set of numbers for the quiz
        quizModel.generateRandomNumber()
        // Check if generated numbers are valid
        guard quizModel.validateNumbers() else{
            print("Error: Failed to generate random numbers....")
            return
        }
        // Reset solution visibility and update rounds
        showSolution = false
        quizModel.totalRounds += 1
        firstTime = false
    }

    func onViewAppear() {
        // Initial setup when the view appears
        solutionText = quizModel.solution
    }
}

