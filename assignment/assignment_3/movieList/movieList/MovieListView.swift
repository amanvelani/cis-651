//
//  MovieListView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            List() {
                ForEach(viewModel.movies){ movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)){
                        MovieRow(movie: movie)
                    }
                }.onDelete(perform: deleteMovie)
            }
            .navigationTitle("Movies")
        }
        .onAppear {
            viewModel.fetchMovies()
        }
    }
    private func deleteMovie(at offsets: IndexSet) {
        viewModel.movies.remove(atOffsets: offsets)
        viewModel.saveMovies()
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

#Preview(){
    MovieListView()
}
