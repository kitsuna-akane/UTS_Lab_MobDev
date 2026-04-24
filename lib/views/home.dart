// views/home_view.dart
// Main screen — displays popular movies in a 2-column grid.
// Consumes MovieBloc; delegates all data fetching to the BLoC layer.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/main_bloc.dart';
import 'movie_card.dart';
import 'shimmer_card.dart';
import 'error.dart';
import 'detail.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(const FetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            // ── Offline banner ────────────────────────────────────────────
            if (state is MovieLoaded && state.isFromCache)
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFFE84393).withOpacity(0.15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Color(0xFFE84393), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Showing cached data — connect for latest movies',
                        style: TextStyle(
                          color: const Color(0xFFE84393).withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Content ───────────────────────────────────────────────────
            if (state is MovieLoading)
              SliverFillRemaining(child: ShimmerGrid())
            else if (state is MovieError)
              SliverFillRemaining(
                child: ErrorView(
                  message: state.message,
                  isOffline: state.message.toLowerCase().contains('offline') ||
                      state.message.toLowerCase().contains('socket'),
                  onRetry: () =>
                      context.read<MovieBloc>().add(const FetchPopularMovies()),
                ),
              )
            else if (state is MovieLoaded)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => MovieCard(
                      movie: state.movies[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailView(movie: state.movies[index]),
                        ),
                      ),
                    ),
                    childCount: state.movies.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              )
            else
              const SliverFillRemaining(child: SizedBox.shrink()),
          ],
        );
      },
    );
  }
}