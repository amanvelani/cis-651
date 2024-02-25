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
            VStack(alignment: .leading, spacing: 10) { // Add spacing between elements
                GeometryReader { geometry in
                    if let path = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 500) // Adjust the height
                            .clipped() // Ensure the image does not overflow its bounds
                    }
                }
                .frame(height: 500) // Set a fixed height for the image container
                Spacer()
                Text(movie.title)
                    .font(.title2) // Adjust font size if needed
                    .padding(.bottom, 1)
                
                HStack {
                    if let average = movie.voteAverage {
                        ForEach(0..<Int(average.rounded())) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .imageScale(.small) // Make stars smaller to fit better
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
