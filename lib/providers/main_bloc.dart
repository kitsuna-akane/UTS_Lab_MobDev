// blocs/movie_bloc/movie_bloc.dart
// Core business logic for fetching popular movies.
// The BLoC layer is the only consumer of MovieService —
// views never call the service directly.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/model.dart';
import '../../services/service.dart';

part 'event.dart';
part 'state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService;
  
  MovieBloc({MovieService? movieService})
      : _movieService = movieService ?? MovieService(),
        super(MovieInitial()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    try {
      final movies = await _movieService.fetchPopularMovies();
      if (movies.isEmpty) {
        emit(const MovieError('No movies found. Check your API key or connection.'));
      } else {
        // Detect if data came from cache (no network hit succeeded)
        final isCached = await _movieService.isCacheAvailable('cache_popular_movies');
        emit(MovieLoaded(movies: movies, isFromCache: isCached));
      }
    } catch (e) {
      emit(MovieError('Something went wrong: ${e.toString()}'));
    }
  }
}