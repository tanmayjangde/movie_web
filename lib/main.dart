import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/movies',
      builder: (context, state) => MoviesPage(),
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
