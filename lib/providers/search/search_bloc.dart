import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../../models/model.dart';
import '../../services/service.dart';

part 'event.dart';
part 'state.dart';

// Debounce transformer: waits 400ms after the last event before processing
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).exhaustMap(mapper);
}

extension on Stream {
  Stream debounceTime(Duration duration) {
    StreamController? controller;
    Timer? timer;
    late StreamSubscription subscription;

    controller = StreamController(
      onListen: () {
        subscription = listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () => controller!.add(data));
          },
          onDone: () {
            timer?.cancel();
            controller!.close();
          },
          onError: controller!.addError,
        );
      },
      onCancel: () {
        subscription.cancel();
        timer?.cancel();
      },
    );
    return controller.stream;
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieService _movieService;

  SearchBloc({MovieService? movieService})
      : _movieService = movieService ?? MovieService(),
        super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await _movieService.searchMovies(event.query);
      emit(SearchLoaded(results: results, query: event.query));
    } catch (e) {
      emit(SearchError('Search failed. Please try again.'));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}