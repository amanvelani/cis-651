//
//  MovieDetailView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    @StateObject var viewModel: MovieViewModel
    @Binding var navigatingToDetail: Bool  // Add this line

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if let posterPath = movie.posterPath {
                            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                            AsyncImage(url: posterURL)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        }
                        if let backdropPath = movie.backdropPath {
                            let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
                            AsyncImage(url: backdropURL)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        }
                    }
                }
                .frame(height: 300)
                
                Text(movie.title)
                    .font(.title2)
                    .padding(.bottom, 1)
                
                HStack {
                    if let average = movie.voteAverage {
                        ForEach(0..<Int(average.rounded()), id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .imageScale(.small)
                        }
                    }
                }
                .padding(.bottom, 2)
                
                Text(movie.overview ?? "No description available.")
                    .font(.body)
            }
            .padding()
        }.navigationBarTitle(Text(movie.title), displayMode: .inline)
//        .navigationBarBackButtonHidden(true) // Ensure back button is not hidden
            .onAppear {
                viewModel.saveLastViewedMovie(movie)
            }
//        }.navigationBarItems(leading: Button(action: {
//            if self.navigatingToDetail{
//                self.navigatingToDetail = false
//            }
//        }) {
//            Image(systemName: "arrow.left") // Use a system image or your own
//            Text("Back")
//        })
         .navigationBarItems(leading: navigatingToDetail ? AnyView(customBackButton) : AnyView(EmptyView()))
        }
    private var customBackButton: some View {
            Button(action: {
                self.navigatingToDetail = false
            }) {
                HStack {
                    Image(systemName: "arrow.left") // System image for back button
                    Text("Movies")
                }
            }
    }
        
    }
    
