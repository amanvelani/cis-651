//
//  MovieDetailView.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                GeometryReader { geometry in
                    if let path = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 500)
                            .clipped()
                    }
                }
                .frame(height: 500)
                Spacer()
                Text(movie.title)
                    .font(.title2)
                    .padding(.bottom, 1)
                
                HStack {
                    if let average = movie.voteAverage {
                        ForEach(0..<Int(average.rounded())) { _ in
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
        }
        .navigationBarTitle(Text(movie.title), displayMode: .inline)
    }
}
