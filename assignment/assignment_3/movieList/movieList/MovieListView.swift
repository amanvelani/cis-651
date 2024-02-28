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
        VStack{
            List() {
                ForEach(viewModel.movies){ movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id, viewModel: viewModel)){
                        MovieRow(movie: movie)
                    }
                }.onDelete(perform: deleteMovie)
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchMovies(hardFetch: true)
                    }){
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }.onAppear {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie")
            viewModel.lastViewedMovieId = nil
            viewModel.fetchMovies(hardFetch : false)
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
