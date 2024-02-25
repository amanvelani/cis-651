//
//  movieListApp.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

@main
struct movieListApp: App {
    func performInitialSetup() {
            let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZGQ3NGE4NWZlNjUxNjYwZDkzNDVjZjkwMzFhNDBjNiIsInN1YiI6IjY1ZDkyODdiNDJmMTlmMDE4NjFhMTdjMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MaDPNnG-XtXpg9uybZ0GTc7meGuMTVADgKnXxcfGAbw"
            if let tokenData = token.data(using: .utf8) {
                let status = KeychainHelper.save(key: "bearerToken", data: tokenData)
                print(status == noErr ? "Token successfully saved" : "Failed to save token")
            }
    }
    
    var body: some Scene {
        WindowGroup {
            MovieListView().onAppear {
                performInitialSetup()
            }
        }
    }
}
