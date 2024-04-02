import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

enum APIError { invalidURL, serverError, noData, decodingError }

class Result<T, E> {
  final T? success;
  final E? error;

  Result.success(this.success) : error = null;
  Result.error(this.error) : success = null;
}

class MovieService {
  final String apiKey = '7d35186037ab168c57ce140a7bb93a27';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=';
  http.Client client;

  MovieService({http.Client? client}) : client = client ?? http.Client();

  Future<Result<List<Movie>, APIError>> fetchMovies() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('cachedMovies');
    final String? cachedMovies = prefs.getString('cachedMovies');
    print("Cached Movies: $cachedMovies");

    try {
      if (cachedMovies != null) {
        final jsonData = json.decode(cachedMovies);
        print("Decoded JSON Data: $jsonData");
        final List<dynamic> moviesJson = jsonData['results'];
        final List<Movie> movies = moviesJson.map((json) {
          print("Preparing to parse movie JSON: $json");
          return Movie.fromJson(json);
        }).toList();

        return Result.success(movies);
      } else {
        final response = await client.get(Uri.parse('$baseUrl$apiKey'));
        if (kDebugMode) {
          print("API Response: ${response.body}");
        }
        if (response.statusCode == 200) {
          prefs.setString('cachedMovies', response.body);
          final jsonData = json.decode(response.body);
          final List<dynamic> moviesJson = jsonData['results'];
          final List<Movie> movies = moviesJson.map((json) {
            if (kDebugMode) {
              print("Preparing to parse movie JSON: $json");
            }
            return Movie.fromJson(json);
          }).toList();

          return Result.success(movies);
        } else {
          return Result.error(APIError.serverError);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred during JSON processing: $e');
      }
      return Result.error(APIError.decodingError);
    }
  }
}
