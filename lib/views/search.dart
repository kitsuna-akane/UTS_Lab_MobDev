// views/search_view.dart
// Search screen — uses SearchBloc with debounced async search.
// The TextField dispatches SearchQueryChanged events; the BLoC
// handles async/await and emits states. FutureBuilder is mimicked
// via BlocBuilder for a clean, freeze-free UI.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/search/search_bloc.dart';
import 'movie_card.dart';
import 'shimmer_card.dart';
import 'error.dart';
import 'detail.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search Field ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) =>
                context.read<SearchBloc>().add(SearchQueryChanged(val)),
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 15),
              filled: true,
              fillColor: const Color(0xFF1C1C2E),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: Color(0xFFE84393)),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: Colors.white38),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchBloc>().add(const SearchCleared());
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // ── Results ─────────────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_movies_outlined,
                          size: 64, color: Colors.white12),
                      const SizedBox(height: 12),
                      Text(
                        'Search for any movie',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is SearchLoading) return const ShimmerGrid(count: 6);

              if (state is SearchError) {
                return ErrorView(message: state.message);
              }

              if (state is SearchLoaded) {
                if (state.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 56, color: Colors.white24),
                        const SizedBox(height: 12),
                        Text(
                          'No results for "${state.query}"',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.results.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => MovieCard(
                    movie: state.results[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailView(movie: state.results[index]),
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}