import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_web/movie_details.dart';
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

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
    fetchPopularMovies();
    fetchNowPlayingMovies();
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
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE2B616)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  SizedBox(
                    width: 800,
                    child: CarouselSlider(
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
                      items: topRatedMovies.map((movie) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (conext) =>
                                            MovieDetailsPage(movie: movie)));
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
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Now Playing',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE2B616)),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        height: 470,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: nowPlayingMovies.length,
                          itemBuilder: (context, index) {
                            final movie = nowPlayingMovies[index];
                            return ListTile(
                              leading: Image.network(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                movie.title,
                                style:
                                    const TextStyle(color: Color(0xFFE2B616)),
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
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Explore Popular Movies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(popularMovies.length, (index) {
                final movie = popularMovies[index];
                return GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: Text(movie.title),
                        )
                      ],
                    ),
                  ),
                );
              })),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
