import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_web/movie_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '2f048e3e025ffe9e1552507e8f3c18e4';
  List<Movie> topRatedMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> nowPlayingMovies = [];
  List<Movie> upcomingMovies = [];
  String selectedFilter = 'popular';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
    fetchPopularMovies();
    fetchNowPlayingMovies();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchTopRatedMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        topRatedMovies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch top-rated movies');
    }
  }

  Future<void> fetchPopularMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        popularMovies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nowPlayingMovies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch now playing movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              child: Text(
                'Top Rated Movies',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 800,
                  child: isLoading
                      ? _buildSkeletonCarousel()
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: 500.0,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            enableInfiniteScroll: true,
                            pageSnapping: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                          ),
                          items: topRatedMovies.map((movie) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    context.go('/movie/${movie.id}');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Display ListView for Now Playing Movies
                    SizedBox(
                      width: 350,
                      height: 470,
                      child: isLoading
                          ? _buildSkeletonNowPlaying()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: nowPlayingMovies.length,
                              itemBuilder: (context, index) {
                                final movie = nowPlayingMovies[index];
                                return ListTile(
                                  onTap: () {
                                    context.go('/movie/${movie.id}');
                                  },
                                  leading: Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    width: 80,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    movie.title,
                                    style: const TextStyle(
                                        color: Color(0xFFE2B616)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    movie.overview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text(
                'Explore Popular Movies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Display Row for Popular Movies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: isLoading
                      ? _buildSkeletonPopularMovies()
                      : List.generate(popularMovies.length, (index) {
                          final movie = popularMovies[index];
                          return GestureDetector(
                            onTap: () {
                              context.go('/movie/${movie.id}');
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 150,
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    width: 150,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 500.0,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(seconds: 1),
        enableInfiniteScroll: true,
        pageSnapping: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: List.generate(5, (index) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.grey[800],
            );
          },
        );
      }),
    );
  }

  Widget _buildSkeletonNowPlaying() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            color: Colors.grey[800],
            width: 80,
            height: 120,
          ),
          title: Container(
            color: Colors.grey[800],
            height: 20,
          ),
          subtitle: Container(
            color: Colors.grey[800],
            height: 40,
          ),
        );
      },
    );
  }

  _buildSkeletonPopularMovies() {
    return List.generate(5, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 150,
        child: Column(
          children: [
            Container(
              color: Colors.grey[800],
              width: 150,
              height: 200,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              color: Colors.grey[800],
              height: 20,
            )
          ],
        ),
      );
    });
  }
}
