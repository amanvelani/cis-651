//
//  RuleView.swift
//  diceGame
//
//  Created by Aman Velani on 2/16/24.
//

import SwiftUI

// View for the game rules
struct RuleView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Scrollable rules content
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Game Rules")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    
                    Group {
                        ruleSectionTitle("Objective")
                        ruleSectionText("The goal of the game is to win money by rolling dice against the computer. Each player starts with $100. The game continues until either the user or the computer runs out of money.")
                        
                        ruleSectionTitle("Starting the Game")
                        ruleSectionText("Each player (the user and the computer) starts with $100. The initial bet for each round is set at $50 which can be changed by the slider")
                        
                        ruleSectionTitle("How to Play")
                        ruleSectionText("1. Placing Bets: Before rolling the dice, each user places a bet. The minimum bet is $1, and the maximum bet is the lower of the two players' remaining money.\n2. Rolling the Dice: Each player rolls two dice.\n3. Determining the Winner: The player with the higher total sum of their dice wins the round. If the total sums are equal, the round ends in a tie, and no money is exchanged.\n4. Winning Money: The winner of the round takes the bet amount from the loser's total money. In case of a tie, no money is exchanged.\n5. Game Over: The game ends when either player's money reaches $0. An alert is shown indicating who won the game. And a new round is started with the loser's account filled with $100")
                    }
                    
                    Group {
                        ruleSectionTitle("Resetting the Game")
                        ruleSectionText("Players can reset the game at any point. This action restores both players' money to $100")

                        
                        ruleSectionTitle("Strategies")
                        ruleSectionText("Wise betting is key. Consider your and your opponent's remaining money before deciding your bet. The game relies on luck, but managing your bets wisely can increase your chances of winning overall.")
                    }
                }
                .padding()
            }
        }
    }
    
    // Helper view for section titles
    private func ruleSectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    
    // Helper view for section body text
    private func ruleSectionText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
            .padding(.bottom, 10)
    }
}

struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        RuleView()
    }
}
