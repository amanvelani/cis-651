//
//  movieListApp.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//
import SwiftUI

@main
struct movieListApp: App {
    @StateObject var viewModel = MovieViewModel() // ViewModel for managing movie data
    @State private var navigationPath = NavigationPath() // Navigation state management

    var body: some Scene {
           WindowGroup {
               NavigationStack(path: $navigationPath) { // Manage navigation for movie views
                    MovieListView(viewModel: viewModel) // Initial movie list view
                    .navigationDestination(for: MovieModel.self) { movie in // Destination for selected movie
                        MovieDetailView(movieId: movie.id, viewModel: viewModel) // Detail view for selected movie
                    }
                }.onAppear { // Actions when view appears
                    if let lastMovie = viewModel.loadLastViewedMovie() { // Check for last viewed movie
                        navigationPath.append(lastMovie) // Navigate to last viewed movie
                    }
               }
           }
       }
}

