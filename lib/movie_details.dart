import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:movie_web/appbar.dart';
import 'package:movie_web/drawer.dart';
import 'dart:convert';
import 'package:movie_web/movie_model.dart';
import 'package:movie_web/responsive.dart';

class MovieDetails extends StatefulWidget {
  final String movieId;

  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Map<String, dynamic>? details;
  List<Movie> similarMovies = [];
  bool isLoading = true;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchSimilarMovies();
  }

  @override
  void didUpdateWidget(covariant MovieDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movieId != widget.movieId) {
      setState(() {
        isLoading = true;
      });
      fetchDetails();
      fetchSimilarMovies();
    }
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
      drawer: CustomDrawer(context: context),
      appBar: CustomAppbar(context: context),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : details != null
              ? SingleChildScrollView(
                  child: SizedBox(
                    height: 3000,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: const Responsive().isMobile(context)
                                  ? 250
                                  : 400,
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
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
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
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 25),
                                child: Text(
                                  'Similar Movies',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Display Row for Popular Movies
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return isLoading
                                        ? GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (const Responsive()
                                                          .isDesktop(context))
                                                      ? 5
                                                      : (const Responsive()
                                                              .isTablet(context)
                                                          ? 3
                                                          : 2),
                                              childAspectRatio: 0.7,
                                            ),
                                            itemCount: 12,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                elevation: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (const Responsive()
                                                          .isDesktop(context))
                                                      ? 5
                                                      : (const Responsive()
                                                              .isTablet(context)
                                                          ? 3
                                                          : 2),
                                              childAspectRatio: 0.7,
                                            ),
                                            itemCount: similarMovies.length,
                                            itemBuilder: (context, index) {
                                              final movie =
                                                  similarMovies[index];
                                              return MouseRegion(
                                                onEnter: (_) {
                                                  setState(() {
                                                    _hoveredIndex = index;
                                                  });
                                                },
                                                onExit: (_) {
                                                  setState(() {
                                                    _hoveredIndex = null;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  transform:
                                                      _hoveredIndex == index
                                                          ? (Matrix4.identity()
                                                            ..scale(1.05, 1.05)
                                                            ..translate(0, -10))
                                                          : Matrix4.identity(),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      context.go(
                                                          '/movie/${movie.id}');
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Card(
                                                        elevation:
                                                            _hoveredIndex ==
                                                                    index
                                                                ? 20
                                                                : 4,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8),
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                                                  width: double
                                                                      .infinity,
                                                                  height: 200,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              // Ensuring content inside card is scrollable
                                                              child: ListView(
                                                                // Wrap with ListView
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                children: [
                                                                  Text(
                                                                    movie.title,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber),
                                                                      Text(
                                                                          '${movie.voteAverage} (${movie.voteCount} votes)'),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                      'Language: ${movie.originalLanguage}'),
                                                                  const SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                      'Adult: ${movie.adult ? 'Yes' : 'No'}'),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('Failed to load movie details'),
                ),
    );
  }
}
