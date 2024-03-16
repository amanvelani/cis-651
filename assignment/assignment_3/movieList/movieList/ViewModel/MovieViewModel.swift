//
//  MovieViewModel.swift
//  movieList
//
//  Created by Aman Velani on 2/25/24.
//

import Foundation
import Combine

// Referance : https://nshipster.com/secrets/
enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
// API configuration, specifically for fetching the API token
enum API {
    static var token: String {
        return (try? Configuration.value(for: "API_TOKEN")) ?? ""
    }
}

class MovieViewModel: ObservableObject{
    @Published var movies = [MovieModel]()
    
    var lastViewedMovieId: Int?
    // cancellables is a set of AnyCancellable objects that are used to store the AnyCancellable instances returned by the sink(receiveCompletion:receiveValue:) method.
    private var cancellables = Set<AnyCancellable>()
    // List ID for fetching of movies
    var listId = 65056
    // Get API token from Configuration
    lazy var token: String = API.token
    
    // Used for pagination
    @Published var currentPageInView = 1
    let moviesPerPageInView = 10
    var totalNumberOfPagesInView: Int {
        (movies.count + moviesPerPageInView - 1) / moviesPerPageInView
    }

    // Movies for current page
    var moviesForCurrentPage: [MovieModel] {
        Array(movies.dropFirst((currentPageInView - 1) * moviesPerPageInView).prefix(moviesPerPageInView))
    }

    // Load movies on initialization
    init() {
        loadMovies()
    }


    func fetchMovies(hardFetch: Bool){
        // If movies are empty, fetch movies
        if movies.isEmpty{
            movies = []
            fetchMoviesPage(byPageNumber: 1)
        }else if hardFetch{ // If hardFetch is true, fetch movies
            movies = []
            fetchMoviesPage(byPageNumber: 1)
        }
    }
    
    func fetchMoviesPage(byPageNumber pageNumber: Int) {
        guard pageNumber < 4 else {
            saveMovies()
            return
        }
        
        // URL for fetching movies
        guard let url = URL(string: "https://api.themoviedb.org/4/list/65056?page=\(pageNumber)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Set token in header

        URLSession.shared.dataTaskPublisher(for: request) // Url session for fetching movies
            .map { response -> Data in
                let dataString = String(data: response.data, encoding: .utf8)!
                print("Received data string: \(dataString)")
                return response.data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder()) // Decode response
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        print("Error fetching movies for page \(pageNumber): \(error.localizedDescription)")
                    case .finished:
                        self?.fetchMoviesPage(byPageNumber: pageNumber + 1)
                }
            }, receiveValue: { [weak self] response in
                self?.movies.append(contentsOf: response.results)
            })
            .store(in: &cancellables)
    }

    // Fetch movie details via id
    func fetchMovieDetails(currentMovieId : Int) async throws -> MovieModel{
        let urlString = "https://api.themoviedb.org/3/movie/\(currentMovieId)"
        guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        if let dataString = String(data: data, encoding: .utf8) {
            print("Received data string: \(dataString)")
        } else {
            print("Failed to convert data to string.")
        }
        let decodedMovie = try JSONDecoder().decode(MovieModel.self, from: data)
        return decodedMovie
        
    }
    
    // Save last viewed movie for persistance
    func saveLastViewedMovie(_ movie: MovieModel) {
        if let movieData = try? JSONEncoder().encode(movie) {
            UserDefaults.standard.set(movieData, forKey: "LastViewedMovie") // Save movie in user defaults for persistance
            UserDefaults.standard.set(movie.id, forKey: "LastViewedMovieID") // Save movie ID in user defaults for persistance
        }
    }
    
    // Load last viewed movie for persistance
    func loadLastViewedMovie() -> MovieModel? {
        if let lastMovieData = UserDefaults.standard.data(forKey: "LastViewedMovie"),
            let lastMovie = try? JSONDecoder().decode(MovieModel.self, from: lastMovieData) {
                return lastMovie
            }
            return nil
    }
    
    // Save last viewed movie ID for persistance
    func lastMovieId() -> Int? {
        return UserDefaults.standard.integer(forKey: "LastViewedMovieID")
    }
    
    // Save movies for persistance
    func saveMovies() {
            if let encoded = try? JSONEncoder().encode(movies) {
                UserDefaults.standard.set(encoded, forKey: "SavedMovies")
            }
        }

    // Load movies for persistance
    func loadMovies() {
        if let savedMovies = UserDefaults.standard.data(forKey: "SavedMovies"),
            let decodedMovies = try? JSONDecoder().decode([MovieModel].self, from: savedMovies) {
            self.movies = decodedMovies
        }
    }
}
