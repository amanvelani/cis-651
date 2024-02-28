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

enum API {
    static var token: String {
        return (try? Configuration.value(for: "API_TOKEN")) ?? ""
    }
}

class MovieViewModel: ObservableObject{
    @Published var movies = [MovieModel]()
    
    var lastViewedMovieId: Int?

    private var cancellables = Set<AnyCancellable>()
    var listId = 65056
    lazy var token: String = API.token
    
    @Published var currentPageInView = 1
    let moviesPerPageInView = 10
    var totalNumberOfPagesInView: Int {
        (movies.count + moviesPerPageInView - 1) / moviesPerPageInView
    }

    var moviesForCurrentPage: [MovieModel] {
        Array(movies.dropFirst((currentPageInView - 1) * moviesPerPageInView).prefix(moviesPerPageInView))
    }


    init() {
        loadMovies()
    }


    func fetchMovies(hardFetch: Bool){
        if movies.isEmpty{
            movies = []
            fetchMoviesPage(byPageNumber: 1)
        }else if hardFetch{
            movies = []
            fetchMoviesPage(byPageNumber: 1)
        }
    }
    
    func fetchMoviesPage(byPageNumber pageNumber: Int) {
        print(token)
        guard pageNumber < 4 else {
            saveMovies()
            return
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/4/list/65056?page=\(pageNumber)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { response -> Data in
                let dataString = String(data: response.data, encoding: .utf8)!
                print("Received data string: \(dataString)")
                return response.data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
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
