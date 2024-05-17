import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/home.dart';
import 'package:movie_web/movie_details.dart';
import 'package:movie_web/movies.dart';
import 'package:movie_web/search_page.dart';

const apiKey = '2f048e3e025ffe9e1552507e8f3c18e4';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return MovieDetails(movieId: id);
      },
    ),
    GoRoute(
      path: '/search/:query',
      builder: (context, state) {
        final String query = state.pathParameters['query']!;
        return SearchPage(query: query);
      },
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie Web App',
      routerConfig: _router,
      theme: ThemeData.dark(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MoviesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearch(String query) {
    context.go('/search?query=$query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 50,
            ),
            TextButton(
              onPressed: () {}, // Add functionality here if needed
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE2B616),
              ),
              child: Text(
                'TMDB',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 850,
              height: 40,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    onSubmitted: _onSearch,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _onItemTapped(0),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Home',
                style: TextStyle(
                  color: Color(0xFFE2B616),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => _onItemTapped(1),
            child: const Padding(
              padding: EdgeInsets.only(right: 50),
              child: Text(
                'Movies',
                style: TextStyle(
                  color: Color(0xFFE2B616),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
