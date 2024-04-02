import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_list/models/movie.dart';
import 'package:movie_list/widgets/movie_tile.dart';
import 'package:movie_list/services/movie_service.dart';
import 'package:movie_list/widgets/platform_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredMovies = _movies;
      });
    } else {
      setState(() {
        _filteredMovies = _movies
            .where((movie) => movie.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  void _fetchMovies() async {
    final result = await _movieService.fetchMovies();
    if (result.success != null) {
      List<Movie> movies = result.success!;
      setState(() {
        _movies = movies;
        _filteredMovies = movies;
      });
    } else if (result.error != null) {
      // Handle error
      setState(() {
        _movies = [];
        _filteredMovies = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: platformTextField(
          context: context,
          controller: _searchController,
          hintText: 'Search movies...',
          hintStyle: const TextStyle(color: Colors.white70),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => _onSearchChanged(),
        ),
        actions: <Widget>[
          platformIconButton(
            context: context,
            icon: Icons.clear,
            onPressed: () {
              _searchController.clear();
            },
          ),
          platformIconButton(
            context: context,
            icon: Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            onPressed: () => widget
                .toggleTheme(Theme.of(context).brightness == Brightness.light),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 2.5,
        ),
        itemCount: _filteredMovies.length,
        itemBuilder: (context, index) {
          final movie = _filteredMovies[index];
          return Dismissible(
            key: Key(movie.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              setState(() {
                _filteredMovies.removeAt(index);
                _movies.removeWhere((m) => m.id == movie.id);
              });

              final prefs = await SharedPreferences.getInstance();
              print(_movies);
              final String updatedMoviesJson = jsonEncode(
                  {"results": _movies.map((m) => m.toJson()).toList()});
              print(updatedMoviesJson);
              print("Before deleting: " +
                  (prefs.getString('cachedMovies') ?? ""));
              await prefs.setString('cachedMovies', updatedMoviesJson);
              print(
                  "After deleting: " + (prefs.getString('cachedMovies') ?? ""));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Movie removed')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie)),
                );
              },
              child: MovieTile(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
