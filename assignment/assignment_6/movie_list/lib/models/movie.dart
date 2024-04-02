class Movie {
  final int id;
  final String title;
  final String description;
  final String posterPath;
  final double rating;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      return Movie(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['overview'] as String,
        posterPath: json['poster_path'] as String,
        rating: (json['vote_average'] as num).toDouble(),
        releaseDate: json['release_date'] as String,
      );
    } catch (e) {
      print("Error processing JSON for movie: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': description,
      'poster_path': posterPath,
      'vote_average': rating,
      'release_date': releaseDate,
    };
  }
}
