//
//  movieListApp.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

@main
struct movieListApp: App {
    @StateObject var viewModel = MovieViewModel()
    @State private var navigatingToDetail = false

    init() {
           _navigatingToDetail = State(initialValue: UserDefaults.standard.integer(forKey: "LastViewedMovieID") != 0)
    }

    
    func performInitialSetup() {
            let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZGQ3NGE4NWZlNjUxNjYwZDkzNDVjZjkwMzFhNDBjNiIsInN1YiI6IjY1ZDkyODdiNDJmMTlmMDE4NjFhMTdjMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MaDPNnG-XtXpg9uybZ0GTc7meGuMTVADgKnXxcfGAbw"
            if let tokenData = token.data(using: .utf8) {
                let status = KeychainHelper.save(key: "bearerToken", data: tokenData)
                print(status == noErr ? "Token successfully saved" : "Failed to save token")
            }
    }
    
    var body: some Scene {
           WindowGroup {
               NavigationView {
                   if navigatingToDetail, let movie = viewModel.loadLastViewedMovie(){
                       MovieDetailView(movie: movie, viewModel: viewModel, navigatingToDetail: $navigatingToDetail)
                   } else {
                       MovieListView(navigatingToDetail: $navigatingToDetail)
                   }
               }.onAppear {
                   performInitialSetup()
                   let lastId = viewModel.lastMovieId()
                   if lastId != nil {
                       navigatingToDetail = true
                   }else{
                       navigatingToDetail = false
                   }
                   print("Navigating to Detail: \(navigatingToDetail)")
               }

           }
       }
}
