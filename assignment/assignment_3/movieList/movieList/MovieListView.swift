//
//  MovieListView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()
    @Binding var navigatingToDetail: Bool  // Add this line


    var body: some View {
        VStack{
            List() {
                ForEach(viewModel.movies){ movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel, navigatingToDetail: $navigatingToDetail)){
                        MovieRow(movie: movie)
                    }
                }.onDelete(perform: deleteMovie)
            }
            .navigationTitle("Movies")
            
        }.onAppear {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            viewModel.lastViewedMovieId = nil
            navigatingToDetail = false
            viewModel.fetchMovies()
        }
    }
    private func deleteMovie(at offsets: IndexSet) {
        let idsToDelete = offsets.compactMap { viewModel.movies[$0].id }
        viewModel.movies.remove(atOffsets: offsets)
        viewModel.saveMovies()
            
        if let lastMovieId = viewModel.lastMovieId(), idsToDelete.contains(lastMovieId) {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie")
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            viewModel.lastViewedMovieId = nil
        }
    }

}

struct MovieRow: View {
    let movie: MovieModel

    var body: some View {
        HStack {
            if let path = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w92\(path)") {
                AsyncImage(url: url)
                    .frame(width: 50, height: 75)
                    .cornerRadius(8)
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
