//
//  MovieViewModel.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject{
    @Published var movies = [MovieModel]()
    @Published var keychain = KeychainHelper()
    
    var lastViewedMovieId: Int?

    private var cancellables = Set<AnyCancellable>()
    var listId = 65056
    lazy var token: String = self.keychain.retrieveToken()

    init() {
        loadMovies()
    }


    func fetchMovies(){
        if movies.isEmpty{
            guard let url = URL(string: "https://api.themoviedb.org/4/list/65056?page=1") else { return }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .map { response -> Data in
                    let dataString = String(data: response.data, encoding: .utf8)!
                    print("Received data string: \(dataString)")
                    return response.data }
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching movies: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    self?.movies = response.results
                })
                .store(in: &cancellables)
            saveMovies()
        }
    }
    
    func saveLastViewedMovie(_ movie: MovieModel) {
        if let movieData = try? JSONEncoder().encode(movie) {
            UserDefaults.standard.set(movieData, forKey: "LastViewedMovie")
            UserDefaults.standard.set(movie.id, forKey: "LastViewedMovieID") // Save ID separately if needed.
        }
    }
        
    func loadLastViewedMovie() -> MovieModel? {
        if let lastMovieData = UserDefaults.standard.data(forKey: "LastViewedMovie"),
            let lastMovie = try? JSONDecoder().decode(MovieModel.self, from: lastMovieData) {
                return lastMovie
            }
            return nil
    }
    
    func lastMovieId() -> Int? {
        return UserDefaults.standard.integer(forKey: "LastViewedMovieID")
    }
    
    func saveMovies() {
            if let encoded = try? JSONEncoder().encode(movies) {
                UserDefaults.standard.set(encoded, forKey: "SavedMovies")
            }
        }

    func loadMovies() {
        if let savedMovies = UserDefaults.standard.data(forKey: "SavedMovies"),
            let decodedMovies = try? JSONDecoder().decode([MovieModel].self, from: savedMovies) {
            self.movies = decodedMovies
        }
    }

}
