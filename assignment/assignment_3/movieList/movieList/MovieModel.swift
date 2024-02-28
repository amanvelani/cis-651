import Foundation

struct MovieModel: Identifiable, Decodable, Encodable, Hashable {
    let id: Int
    let title: String
    let backdropPath: String?
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let mediaType: String?
    let runtime: Int?
    let revenue: Int?
    let genreIds: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let tagline: String?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id, title, backdropPath = "backdrop_path", originalTitle = "original_title", overview, posterPath = "poster_path", mediaType = "media_type", runtime, revenue, genreIds = "genre_ids", popularity, releaseDate = "release_date", video, voteAverage = "vote_average", voteCount = "vote_count", tagline = "tag_line", genres
    }
}

struct Genre: Identifiable, Decodable, Encodable, Hashable {
    let id: Int
    let name: String
}

struct MovieResponse: Decodable {
    let results: [MovieModel]
}
