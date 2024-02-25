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
    private var cancellables = Set<AnyCancellable>()
    var listId = 65056
    var token: String?
    init() {
        self.token = retrieveToken()
    }


    func fetchMovies(){
//        print("Token: \(token!)")
        guard let url = URL(string: "https://api.themoviedb.org/4/list/65056?page=1") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
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
    }
    
    func retrieveToken() -> String {
        if let receivedData = KeychainHelper.load(key: "bearerToken"),
           let tokenString = String(data: receivedData, encoding: .utf8) {
            return tokenString
        } else {
            return "Failed to retrieve or decode token"
        }
    }

}
