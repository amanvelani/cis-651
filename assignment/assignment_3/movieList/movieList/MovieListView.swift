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
                ForEach(viewModel.moviesForCurrentPage){ movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id, viewModel: viewModel)){
                        MovieRow(movie: movie)
                    }
                }.onDelete(perform: deleteMovie)
            }
            .navigationTitle("Movies").padding([.top], 10)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchMovies(hardFetch: true)
                    }){
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Image("movieListApp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                }
            }
            
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
                        RoundedRectangle(cornerRadius: 10) // Use the same corner radius as the background
                            .stroke(Color.blue, lineWidth: viewModel.currentPageInView < viewModel.totalNumberOfPagesInView ? 1 : 0)
                    )
                    .shadow(radius: 3)
                }
                .disabled(viewModel.currentPageInView >= viewModel.totalNumberOfPagesInView)
            }
            .padding()

        }.onAppear {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie")
            viewModel.lastViewedMovieId = nil
            viewModel.fetchMovies(hardFetch : false)
        }
    }
            
            
    private func deleteMovie(at offsets: IndexSet) {
        let globalOffsets = offsets.map { ($0 + (viewModel.currentPageInView - 1) * viewModel.moviesPerPageInView) }
        let globalIndexSet = IndexSet(globalOffsets)

        let idsToDelete = globalIndexSet.compactMap { viewModel.movies[$0].id }

        viewModel.movies.remove(atOffsets: globalIndexSet)

        viewModel.saveMovies()

        if let lastMovieId = viewModel.lastMovieId(), idsToDelete.contains(lastMovieId) {
            UserDefaults.standard.removeObject(forKey: "LastViewedMovie")
            UserDefaults.standard.removeObject(forKey: "LastViewedMovieID")
            viewModel.lastViewedMovieId = nil
        }
        viewModel.currentPageInView = min(viewModel.currentPageInView, viewModel.totalNumberOfPagesInView)

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
