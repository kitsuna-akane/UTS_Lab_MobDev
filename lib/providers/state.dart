part of 'main_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

/// Loaded with optional offline flag to show a banner
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool isFromCache;

  const MovieLoaded({required this.movies, this.isFromCache = false});

  @override
  List<Object?> get props => [movies, isFromCache];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}