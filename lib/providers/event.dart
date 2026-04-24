part of 'main_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on app start or pull-to-refresh
class FetchPopularMovies extends MovieEvent {
  const FetchPopularMovies();
}