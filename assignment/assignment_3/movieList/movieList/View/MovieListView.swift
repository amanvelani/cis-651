//
//  MovieListView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

// View for Movie List
struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()

    // List View of Movies
    var body: some View {
        VStack{
            List() {
                ForEach(viewModel.moviesForCurrentPage){ movie in // Loop through movies
                    NavigationLink(destination: MovieDetailView(movieId: movie.id, viewModel: viewModel)){ // Navigate to Movie Detail View
                        MovieRow(movie: movie)
                    }
                }.onDelete(perform: deleteMovie)
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchMovies(hardFetch: true) // Hard fetch feature to fetch movies
                    }){
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Image("movieListApp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
            }
            // Pagination for Movies
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation {
                        viewModel.currentPageInView = max(viewModel.currentPageInView - 1, 1)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                    }
                    .padding()
                    .background(viewModel.currentPageInView > 1 ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: viewModel.currentPageInView > 1 ? 1 : 0)
                    )
                    .shadow(radius: 3)
                }
                .disabled(viewModel.currentPageInView <= 1)

                Text("Page \(viewModel.currentPageInView) of \(viewModel.totalNumberOfPagesInView)")
                    .fontWeight(.semibold)

                Button(action: {
                    withAnimation {
                        viewModel.currentPageInView = min(viewModel.currentPageInView + 1, viewModel.totalNumberOfPagesInView)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .background(viewModel.currentPageInView < viewModel.totalNumberOfPagesInView ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: viewModel.currentPageInView < viewModel.totalNumberOfPagesInView ? 1 : 0)
                    )
                    .shadow(radius: 3)
                }
                .disabled(viewModel.currentPageInView >= viewModel.totalNumberOfPagesInView)
            }
            .padding()

        }.onAppear {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID") // Remove last viewed movie
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie") // Remove last viewed movie
            viewModel.lastViewedMovieId = nil // Set last viewed movie to nil
            viewModel.fetchMovies(hardFetch : false) // Fetch movies if movies are not available
        }
    }
            
    // Logic to delete movie
    private func deleteMovie(at offsets: IndexSet) {
        // find the global index of the movie to delete
        let globalOffsets = offsets.map { ($0 + (viewModel.currentPageInView - 1) * viewModel.moviesPerPageInView) }
        let globalIndexSet = IndexSet(globalOffsets)

        let idsToDelete = globalIndexSet.compactMap { viewModel.movies[$0].id }

        // remove the movies from the view model
        viewModel.movies.remove(atOffsets: globalIndexSet)

        // save the movies after deletion
        viewModel.saveMovies()

        // if the last viewed movie is deleted, remove it from user defaults
        if let lastMovieId = viewModel.lastMovieId(), idsToDelete.contains(lastMovieId) {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie")
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            viewModel.lastViewedMovieId = nil
        }
        // update the current page if the last page is deleted
        viewModel.currentPageInView = min(viewModel.currentPageInView, viewModel.totalNumberOfPagesInView)
    }


}

// Custom view for Movie Row
struct MovieRow: View {
    let movie: MovieModel

    var body: some View {
        HStack {
            if let path = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w92\(path)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 75)
                        case .success(let image):
                            image.resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(width: 50, height: 75)
                                 .cornerRadius(8)
                        case .failure:
                            ProgressView()
                            .frame(width: 50, height: 75)
                        @unknown default:
                            EmptyView()
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.overview ?? "")
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
}
