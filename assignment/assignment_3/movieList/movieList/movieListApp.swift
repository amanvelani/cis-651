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
    @State private var navigationPath = NavigationPath()

    var body: some Scene {
           WindowGroup {
               NavigationStack(path: $navigationPath) {
                    MovieListView(viewModel: viewModel)
                    .navigationDestination(for: MovieModel.self) { movie in
                        MovieDetailView(movieId: movie.id, viewModel: viewModel)
                    }
                }.onAppear {
                    if let lastMovie = viewModel.loadLastViewedMovie() {
                        navigationPath.append(lastMovie)
                    }
               }

           }
       }
}
