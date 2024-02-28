## Check list for assignment 3:
- [x] Use version 4 api in tmdb

### Master flow
- [x] Own custom row view
- [x] Show small image of poster, title
- [x] Fetch movie list from TMDB server through Json downloading
- [x] Download image from the poster link
- [x] Select a movie by tapping a row, then load detail view of your design
- [x] Delete a movie with swiping action

### Detail view
- [x] Customize/design your detail view, title, rating, description, rating must be visual (not text)
- [x] Download movie detail from TMDB with id of Movie (v3)
- [x] Show poster/backdrop images within a scrollable horizontal stack
- [x] Download images from the server
- [x] Use 2 poster/backdrop images to manipulate >= 4 collectionview items

### MVVM pattern:
1. [movieListApp.swift](movieList/movieList/movieListApp.swift) - App entry point
2. [MovieViewModel.swift](movieList/movieList/MovieViewModel.swift) - ViewModel for MovieList
3. [MovieModel.swift](movieList/movieList/MovieModel.swift) - Model for MovieList
4. [MovieDetailView.swift](movieList/movieList/MovieDetailView.swift) - Detail view for MovieList
5. [MovieListView.swift](movieList/movieList/MovieListView.swift) - List view for MovieList

### Persistence and Archive:
- [x] App shall remember the movie the user last selected before exit
- [x] App shall open up next time with the specific movie detail on screen
- [x] App shall archive the movie data
- [x] If the user has deleted a movie, the app shall open up next time with the movie deleted from the master view.
