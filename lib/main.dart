// main.dart
// App entry point. Provides both BLoCs at the root so all child
// routes can access them without re-providing.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'providers/main_bloc.dart';
import 'providers/search/search_bloc.dart';
import 'views/home.dart';
import 'views/search.dart';

void main() {
  runApp(const CineScopeApp());
}

class CineScopeApp extends StatelessWidget {
  const CineScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovieBloc()),
        BlocProvider(create: (_) => SearchBloc()),
      ],
      child: MaterialApp(
        title: 'CineScope',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE84393),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0D1A),
          useMaterial3: true,
        ),
        home: const RootScaffold(),
      ),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [HomeView(), SearchView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.movie_filter_rounded, color: Color(0xFFE84393)),
            SizedBox(width: 8),
            Text(
              'CineScope',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF12122A),
        indicatorColor: const Color(0xFFE84393).withOpacity(0.18),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_outlined),
            selectedIcon: Icon(Icons.local_fire_department_rounded,
                color: Color(0xFFE84393)),
            label: 'Popular',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon:
                Icon(Icons.search_rounded, color: Color(0xFFE84393)),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}