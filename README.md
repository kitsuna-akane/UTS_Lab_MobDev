# 🎬 CineScope — Flutter Movie App

A data-driven Flutter application fetching movie data from the [TMDB API](https://www.themoviedb.org/), built for the Mobile Application Development Midterm Exam (2025/2026).

---

## 📁 Folder Structure

```
lib/
├── main.dart                      # App entry point, MultiBlocProvider setup
├── models/
│   └── movie.dart                 # Movie data class with fromJson/toJson
├── services/
│   └── movie_service.dart         # All HTTP calls + shared_preferences caching
├── blocs/
│   ├── movie_bloc/
│   │   ├── movie_bloc.dart        # BLoC logic for popular movies
│   │   ├── movie_event.dart       # Events: FetchPopularMovies
│   │   └── movie_state.dart       # States: Loading, Loaded, Error
│   └── search_bloc/
│       ├── search_bloc.dart       # BLoC logic for search with debounce
│       ├── search_event.dart      # Events: SearchQueryChanged, SearchCleared
│       └── search_state.dart      # States: Initial, Loading, Loaded, Error
├── views/
│   ├── home_view.dart             # Popular movies grid
│   ├── search_view.dart           # Search + results grid
│   └── detail_view.dart           # Movie detail screen
└── widgets/
    ├── movie_card.dart            # ♻️ Reusable widget #1 — movie card
    ├── shimmer_card.dart          # ♻️ Reusable widget #2 — shimmer loading card + grid
    └── error_view.dart            # ♻️ Reusable widget #3 — creative error UI
```

---

## 🧠 Why BLoC for State Management?

**BLoC (Business Logic Component)** was chosen for the following reasons:

| Reason | Explanation |
|---|---|
| **Separation of Concerns** | BLoC enforces a strict boundary between UI and business logic. Views only dispatch Events and render States — they never call services directly. |
| **Testability** | Events and States are plain Dart classes (Equatable), making unit tests straightforward without mocking the entire widget tree. |
| **Scalability** | Adding a new feature (e.g., Favorites) only requires a new BLoC with its own events/states — zero changes to existing BLoCs. |
| **Predictability** | Every UI state change is traceable to a single Event, making debugging and logging trivial with `BlocObserver`. |
| **Async Safety** | `flutter_bloc`'s `Emitter`-based handlers prevent emitting to closed streams, avoiding common async pitfalls. |

**Why not GetX?** GetX mixes routing, DI, and state into one package, making it harder to reason about data flow in larger teams.  
**Why not Riverpod?** Riverpod is excellent but less opinionated about event-driven architecture, which is a better fit for exam grading clarity.

---

## ⚙️ Setup

1. Get a free API key at [themoviedb.org](https://www.themoviedb.org/settings/api)
2. Open `lib/services/movie_service.dart`
3. Replace `YOUR_TMDB_API_KEY` with your key
4. Run:

```bash
flutter pub get
flutter run
```

---

## ✅ Feature Checklist

- [x] Modular folder structure (models / services / blocs / views / widgets)
- [x] Offline caching with `shared_preferences`
- [x] Offline banner shown when serving cached data
- [x] Full error handling with creative UI (no raw error codes)
- [x] Async search with 400ms debounce (no UI freeze)
- [x] Shimmer loading effect on both Home and Search screens
- [x] 3 reusable widgets: `MovieCard`, `ShimmerCard`/`ShimmerGrid`, `ErrorView`
- [x] Pull-to-refresh on home screen
- [x] Movie detail screen with hero poster
