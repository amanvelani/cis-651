//
//  ContentView.swift
//  myQuiz
//
//  Created by Aman Velani on 1/31/24.
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

struct myQuizView: View {
    // State and view model declarations
    @StateObject var viewModel = QuizViewModel()
    @State private var orientation = UIDeviceOrientation.unknown

    var body: some View {
        Group {
            // Device type and orientation-based layout decision
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
        }
        .onAppear {
            viewModel.onViewAppear()
        }
        .onRotate { newOrientation in
            orientation = newOrientation // Update orientation state on rotation
        }
    }
    
    // Layout specific to iPad devices
    private var ipadLayout: some View {
        VStack{
            quizTitle.padding(.bottom, 100)
            quizContent
            Spacer()
        }
    }

    // Layout for portrait mode
    private var portraitLayout: some View {
        VStack {
            quizTitle.padding(.bottom, 70)
            quizContent
            Spacer()
        }
        .padding()
    }

    // Layout for landscape mode
    private var landscapeLayout: some View {
        HStack {
            Spacer()
            quizContent
            Spacer()
        }
        .padding()
    }
    
    // Reusable view component displaying the quiz title
    private var quizTitle: some View {
        Text("myQuiz")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
    }

    // Main content of the quiz
    private var quizContent: some View {
        VStack {
            // Display the current quiz expression
            Text(viewModel.quizModel.expression)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.3))
                .cornerRadius(10)

            solutionSection // Solution visibility based on state
            
            actionButtons // Interactive buttons for user actions
            
            Spacer()
            
            // Display total count of quiz rounds
            Text("Total Counts: \(viewModel.quizModel.totalRounds)")
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }

    private var solutionSection: some View {
        Group {
            if viewModel.showSolution {
                Text(viewModel.solutionText)
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 2)
                    ).padding()
            } else {
                // Placeholder when solution is not shown
                Text("     ").font(.title2)
                    .foregroundColor(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 2)
                    ).padding()
            }
        }
    }
    
    // Buttons for user actions, with dynamic text for the play button
    private var actionButtons: some View {
        Group {
            Button(action: {
                viewModel.solveQuiz() // Trigger solution display
            }) {
                Text("Solve")
                    .font(.headline)
                    .padding()
                    .frame(width: 200)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle()).padding(.top, 20)

            Button(action: {
                viewModel.playAgain() // Reset or start quiz
            }) {
                Text(viewModel.firstTime ? "Play" : "Play Again")
                    .font(.headline)
                    .padding()
                    .frame(width: 200)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle()).padding(.top, 20)
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        myQuizView()
    }
}
