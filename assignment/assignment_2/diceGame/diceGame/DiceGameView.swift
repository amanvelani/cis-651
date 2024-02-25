//
//  DiceGameView.swift
//  diceGame
//
//  Created by Aman Velani on 2/5/24.
//


import SwiftUI

// Referance: https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-device-rotation
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

// Referance : https://stackoverflow.com/questions/57652242/how-to-detect-whether-targetenvironment-is-ipados-in-swiftui
// This extension is for getting the device information for creating view
extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

struct DiceGameView: View {
    // State and view model declarations
    @State private var diceView = DiceView()
    
    var body: some View {
        
        // Navigation view with a ZStack to allow for a gradient background
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
               DiceView()
            }
        }.navigationViewStyle(StackNavigationViewStyle()) // Force using a stack navigation view style

    }
}


struct DiceView: View {
    @State private var orientation = UIDeviceOrientation.unknown   
    @State private var userDice1: Int = 1 // User's first dice value
    @State private var userDice2: Int = 1 // User's second dice value
    @State private var computerDice1: Int = 1 // Computer's first dice value
    @State private var computerDice2: Int = 1 // Computer's second dice value
    @State private var betMoney = 50.0 // Bet money
    @State private var userMoneyRemaining: Double = 100 // User's money remaining
    @State private var computerMoneyRemaining: Double = 100 // Computer's money remaining
    @State private var noOfRounds: Int = 0 // Number of rounds played
    @State private var roundWinner: String = "" // Winner of the round
    @State private var showAlert = false // Show alert for game over
    @State private var isEditing = false // Slider editing state

    var body: some View {
        Group {
            if UIDevice.isIPad{
                ipadLayout
            }else{
                // Orientation-based layout for non-iPad devices
                if orientation.isPortrait{
                    portraitLayout
                } else if orientation.isLandscape {
                    landscapeLayout
                } else {
                    portraitLayout // Default to portrait layout
                }
            }
        }.onRotate { newOrientation in
            orientation = newOrientation // Update orientation state on rotation
        }
        
    }
// Layout for iPad devices
var ipadLayout: some View{
    VStack{

        diceGameTitle
        
        navigationViews
        
        Spacer()
        
        roundView
        
        moneyRemainingView
        
        diceImageViews
        
        rollButton.padding(20)
        
        betSlider
        
        resetButton
        
        Spacer()
    }.background(LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over"), message: Text(roundWinner.contains("Won") ? "You won the game!" : "Computer won the game!"), dismissButton: .default(Text("OK"), action: nextGame))
        }
}
// Layout for landscape mode
var landscapeLayout: some View{
    VStack{
        navigationViews
        
        moneyRemainingView
        
        HStack{
            diceImageViewsLandScape
        }
        
        
        HStack{
            resetButton
            rollButton
            roundView
        }
        
        betSlider
        
    }.background(LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over"), message: Text(roundWinner.contains("Won") ? "You won the game!" : "Computer won the game!"), dismissButton: .default(Text("OK"), action: nextGame))
        }
    
}
    
    // Layout for portrait mode
    var portraitLayout: some View {
            VStack(spacing: 20) {
                
                Spacer()

                diceGameTitle
                
                navigationViews
                
                roundView
                
                moneyRemainingView
                
                diceImageViews
                
                rollButton
                
                betSlider
                
                resetButton
                
                Spacer()
            }.background(LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Game Over"), message: Text(roundWinner.contains("Won") ? "You won the game!" : "Computer won the game!"), dismissButton: .default(Text("OK"), action: nextGame))
            }
    }
    // View for showing number of rounds
    var roundView: some View{
        VStack{
            Text("Round: \(noOfRounds)")
                .font(.title)
                .foregroundColor(.white)
        }
    }
    

    // View for showing the title of the game
    private var diceGameTitle: some View {
        Text("Dice Game")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
    }

    // View for showing the navigation buttons
    var navigationViews: some View{
        VStack {
            HStack{
                NavigationLink(destination: RuleView()) {
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                NavigationLink {
                    AuthorView(isLandscape: orientation.isLandscape)
                } label: {
                    
                    Image(systemName: "person.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
            }
        }
    }
    
    // View for showing the remaining money for user and computer
    var moneyRemainingView: some View {
        HStack {
            Text("User: $\(userMoneyRemaining, specifier: "%.2f")")
                .foregroundColor(.white)
            Spacer()
            Text("Computer: $\(computerMoneyRemaining, specifier: "%.2f")")
                .foregroundColor(.white)
        }
    }
    

    // View for showing the versus text and dice images
    struct VersusView: View {
        let roundWinner: String

        var body: some View {
            Text(roundWinner.isEmpty ? "Versus" : roundWinner)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fontWidth(.condensed)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        var diceImageViews: some View {
            HStack {
                VStack {
                    DiceImageView(diceValue: userDice1, diceValue2: userDice2)
                }
                Spacer()
                VersusView(roundWinner: roundWinner)
                            .padding(.horizontal)
                
                Spacer()
                VStack {
                    DiceImageView(diceValue: computerDice1, diceValue2: computerDice2)
                }
            }
        }
    
        var diceImageViewsLandScape: some View {
            HStack {
                VStack {
                    DiceImageViewLandScape(diceValue: userDice1, diceValue2: userDice2)
                }
                VersusView(roundWinner: roundWinner)
                VStack {
                    DiceImageViewLandScape(diceValue: computerDice1, diceValue2: computerDice2)
                }
            }
    }
    
    // View for showing the roll button
    var rollButton: some View {
        Button(action: rollDice) {
            Text("Roll Dice")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
    }
    
    // View for showing the bet slider
    var betSlider: some View {
        return VStack {
            Slider(
                value: $betMoney,
                in: 1...100,
                step: 1
            ) {
                Text("Bet")
            } minimumValueLabel: {
                Text("1")
            } maximumValueLabel: {
                Text("100")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            let actualBetMoney = (betMoney / 100) * min(userMoneyRemaining, computerMoneyRemaining)

            Text("$\(actualBetMoney, specifier: "%.2f")")
                .foregroundColor(isEditing ? .red : .blue)
        }
    }

    // View for showing the reset button
    var resetButton: some View {
        Button("Reset Game") {
            resetGame()
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
    
    // Function to roll the dice and calculate the winner
    func rollDice() {
        withAnimation(Animation.easeInOut(duration: 0.5)){
            userDice1 = Int.random(in: 1...6)
            userDice2 = Int.random(in: 1...6)
            computerDice1 = Int.random(in: 1...6)
            computerDice2 = Int.random(in: 1...6)
            
            let userTotal = userDice1 + userDice2
            let computerTotal = computerDice1 + computerDice2
            let actualBetMoney = (betMoney / 100) * userMoneyRemaining

            if userTotal > computerTotal {
                userMoneyRemaining += actualBetMoney
                computerMoneyRemaining -= actualBetMoney
                roundWinner = "You Won"
            } else if computerTotal > userTotal {
                userMoneyRemaining -= actualBetMoney
                computerMoneyRemaining += actualBetMoney
                roundWinner = "You Lost"
            } else {
                roundWinner = " It's a tie "
            }
        
            userMoneyRemaining = max(userMoneyRemaining, 0)
            computerMoneyRemaining = max(computerMoneyRemaining, 0)
            
            if userMoneyRemaining <= 0 || computerMoneyRemaining <= 0 {
                showAlert = true
                nextGame()
            }
        }
    }
    
    // Function to reset the game
    func resetGame() {
        userMoneyRemaining = 100
        computerMoneyRemaining = 100
        betMoney = 50
        noOfRounds = 0
    }
    
    // Function to start the next game
    func nextGame(){
        if userMoneyRemaining > 100{
            userMoneyRemaining = userMoneyRemaining
            computerMoneyRemaining = 100
        }
        else {
            computerMoneyRemaining = computerMoneyRemaining
            userMoneyRemaining = 100
        }
        betMoney = 50
        noOfRounds += 1
        roundWinner = "Versus"
    }
}


// View for showing Dice
struct DiceImageView: View {
    let diceValue: Int
    let diceValue2: Int
    var body: some View {
        VStack {
            Image("Dice\(diceValue)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            Image("Dice\(diceValue2)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
        }
    }
}

struct DiceImageViewLandScape: View {
    let diceValue: Int
    let diceValue2: Int
    var body: some View {
        VStack {
            Image("Dice\(diceValue)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
            Image("Dice\(diceValue2)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
        }
    }
}


#Preview(body: {
    DiceGameView()
})
