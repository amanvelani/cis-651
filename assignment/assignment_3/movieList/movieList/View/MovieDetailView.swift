//
//  MovieDetailView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

// View for Movie Detail
struct MovieDetailView: View {
    let movieId: Int
    @StateObject var viewModel: MovieViewModel
    @State var movie: MovieModel?
    @State private var text: String = ""
    // ScrollView for Movie Detail
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Horizontal ScrollView for Movie Poster and Backdrop
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<2, id: \.self) { _ in
                            if let posterPath = movie?.posterPath {
                                let posterURL = URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
                                AsyncImage(url: posterURL) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure(_):
                                        Color.red
                                    case .empty:
                                        Color.blue
                                    @unknown default:
                                        Color.gray
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 450)
                                .clipped()
                            }
                            if let backdropPath = movie?.backdropPath {
                                let backdropURL = URL(string: "https://image.tmdb.org/t/p/w342\(backdropPath)")
                                AsyncImage(url: backdropURL) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure(_):
                                        Color.red
                                    case .empty:
                                        Color.blue
                                    @unknown default:
                                        Color.gray
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 450)
                                .clipped()
                            }
                        }
                    }
                }
                .frame(height: 450)

                // View for Movie Title, Tagline, Rating, Genres, Release Date, and Runtime
                if let title = movie?.title {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                }
                
                if let tagline = movie?.tagline, !tagline.isEmpty {
                    Text("\"\(tagline)\"")
                        .font(.title3)
                        .italic()
                        .padding(.bottom, 2)
                }
                
                HStack {
                    if let average = movie?.voteAverage {
                        let fullStars = Int(average)
                        let hasHalfStar = average.truncatingRemainder(dividingBy: 1) >= 0.35
                        let maxStars = 10

                        ForEach(0..<fullStars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }

                        if hasHalfStar {
                            Image(systemName: "star.leadinghalf.filled")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }

                        ForEach(0..<maxStars - fullStars - (hasHalfStar ? 1 : 0), id: \.self) { _ in
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }
                    }
                }
                .padding(.bottom, 2)

                if let genres = movie?.genres {
                    Text(genres.map { $0.name }.joined(separator: ", "))
                        .font(.headline)
                        .padding(.bottom, 1)
                }
                
                if let releaseDate = movie?.releaseDate {
                    Text("Release date: \(releaseDate)")
                        .font(.subheadline)
                        .padding(.bottom, 1)
                }
                
                if let runtime = movie?.runtime {
                    Text("Runtime: \(runtime) min")
                        .font(.subheadline)
                        .padding(.bottom, 2)
                }
                
                Text(movie?.overview ?? "No description available.")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding()
        }
        .navigationBarTitle(Text(movie?.title ?? "Loading..."), displayMode: .inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            Task {
                do {
                    // Fetch movie details
                    movie = try await viewModel.fetchMovieDetails(currentMovieId: movieId)
                    // Save last viewed movie for persistance
                    if let fetchedMovie = movie {
                        viewModel.saveLastViewedMovie(fetchedMovie)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
