//
//  myQuizModel.swift
//  myQuiz
//
//  Created by Aman Velani on 1/31/24.
//

import Foundation

class QuizModel: ObservableObject{
    var expression: String = "Expression" // Placeholder for the math expression
    var num1: Int?
    var num2: Int?
    @Published var totalRounds: Int = 0 { // Tracks the number of quiz rounds
            didSet {
                showExpression() // Update expression whenever totalRounds changes
            }
        }
    var solution: String { // Computed property to calculate the solution
            if let num1 = num1, let num2 = num2 {
                let sum = num1 + num2
                return "\(sum)" // Return sum as a string
            } else {
                return "Solution"
            }
        }
    
    func validateNumbers() -> Bool{
        guard let num1 = num1, let num2 = num2 else{
            return false;
        }
        return num1 != num2
    }
   
    func generateRandomNumber(){
        // Generate random numbers and validate them
        num1 = Int.random(in: 0...100)
        num2 = Int.random(in: 0...100)
        
        if !validateNumbers(){
            print("Validation failed! Regenrating numbers")
            generateRandomNumber()
        }
    }
    
    func showExpression(){
        // Update the expression with current numbers
        guard let num1 = num1, let num2 = num2 else { return }
        expression = "\(num1) + \(num2) = (?)" // Format expression string
    }

}
