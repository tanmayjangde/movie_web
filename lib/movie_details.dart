import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_web/movie_model.dart';

class MovieDetails extends StatefulWidget {
  final String movieId;

  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Map<String, dynamic>? details;
  List<Movie>? similarMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchSimilarMovies();
  }

  Future<void> fetchDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieId}?language=en-US&api_key=2f048e3e025ffe9e1552507e8f3c18e4'));

    if (response.statusCode == 200) {
      setState(() {
        details = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> fetchSimilarMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieId}/similar?language=en-US&api_key=2f048e3e025ffe9e1552507e8f3c18e4'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        similarMovies = (json.decode(response.body)['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      });
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : details != null
              ? Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/original${details!['backdrop_path']}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 300,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${details!['poster_path']}',
                                  width: 150,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        details!['original_title'],
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '(${details!['release_date']?.substring(0, 4)})',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        details!['tagline'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        details!['overview'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      if (details!['genres'] != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Genres: ${details!['genres'].map((genre) => genre['name']).join(", ")}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Original language: ${details!['spoken_languages']?[0]['name'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Released Date: ${details!['release_date'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('Failed to load movie details'),
                ),
    );
  }
}
