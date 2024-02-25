//
//  AuthorView.swift
//  diceGame
//
//  Created by Aman Velani on 2/5/24.
//

import SwiftUI

// view for the author's profile
struct AuthorView: View {
    var isLandscape: Bool
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Enhanced background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .yellow]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                    title
                    
                if isLandscape{
                    HStack{
                        image
                        name
                    }
                }else{
                    VStack{
                        image
                        name
                    }
                }
                    
                    authorSection();
                    // Alert button
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Connect with me")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Ensures button width consistency
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("LinkedIn Link"), message: Text("https://www.linkedin.com/in/amanvelani/"), dismissButton: .default(Text("OK")))
                    }

                    Spacer()
                    // Dismiss button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Dismiss")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Ensures button width consistency
                            .background(Color.gray)
                            .cornerRadius(10)
                    }

                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .padding(.horizontal)
                .navigationBarTitle("Profile", displayMode: .inline)
            }
        }
        var title : some View{
            VStack(alignment: .leading, spacing: 20) { // Adjusted spacing for a cleaner look
                Text("About Me")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        var image : some View{
            Image("Aman_Velani")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 10) // Added shadow for depth
                .padding()

        }
    
        var name : some View{
            Text("Aman Velani")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()

        }
        
    }

    private func authorSection() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Graduate Student in Computer Science at Syracuse University with a strong foundation in algorithms, operating systems, and computer security.Skilled in a variety of programming languages including Java, Python, C, Solidity, Swift, and SQL, with a passion for blockchain technology and cybersecurity.")
                .foregroundColor(.white)
        }
        .padding(.bottom, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
    }



