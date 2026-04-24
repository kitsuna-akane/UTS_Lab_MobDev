import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';

class MovieService {
  // -----------------------------------------------------------------------
  // NOTE FOR REVIEWER:
  // Replace the value below with your own TMDB API key.
  // Get one free at: https://www.themoviedb.org/settings/api
  // -----------------------------------------------------------------------
  static const String _apiKey = '6c3d8aca8948cc97007c36b6bad20106';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Cache keys
  static const String _cachePopular = 'cache_popular_movies';
  static const String _cacheSearch = 'cache_search_';

  // ── Popular Movies ──────────────────────────────────────────────────────

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final uri = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final movies = (data['results'] as List)
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
        await _cacheMovies(_cachePopular, movies);
        return movies;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (_) {
      // Offline fallback — return cached data if available
      return _loadCachedMovies(_cachePopular);
    }
  }

  // ── Search Movies ────────────────────────────────────────────────────────

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return fetchPopularMovies();

    final cacheKey = '$_cacheSearch${query.toLowerCase().replaceAll(' ', '_')}';
    try {
      final encoded = Uri.encodeComponent(query);
      final uri = Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$encoded&language=en-US&page=1');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final movies = (data['results'] as List)
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
        await _cacheMovies(cacheKey, movies);
        return movies;
      } else {
        throw Exception('Search API error: ${response.statusCode}');
      }
    } catch (_) {
      return _loadCachedMovies(cacheKey);
    }
  }

  // ── Cache helpers ─────────────────────────────────────────────────────

  Future<void> _cacheMovies(String key, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  Future<List<Movie>> _loadCachedMovies(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> isCacheAvailable(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}