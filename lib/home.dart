import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_web/appbar.dart';
import 'package:movie_web/drawer.dart';
import 'package:movie_web/movie_model.dart';
import 'package:movie_web/responsive.dart';

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
  int? _hoveredIndex;

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
      drawer: CustomDrawer(context: context),
      appBar: CustomAppbar(context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Top Rated Movies',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            (const Responsive().isDesktop(context))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.82,
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
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16),
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
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
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
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          width: MediaQuery.of(context).size.width * 0.82,
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
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Now Playing',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 350,
                                height: 470,
                                child: isLoading
                                    ? _buildSkeletonNowPlaying()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
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
                          ),
                        ),
                      ],
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
              child: Text(
                'Explore Popular Movies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Display Row for Popular Movies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return isLoading
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (const Responsive().isDesktop(context))
                                    ? 5
                                    : (const Responsive().isTablet(context)
                                        ? 3
                                        : 2),
                            childAspectRatio: 0.7,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (const Responsive().isDesktop(context))
                                    ? 5
                                    : (const Responsive().isTablet(context)
                                        ? 3
                                        : 2),
                            childAspectRatio:
                                const Responsive().isMobile(context)
                                    ? 0.5
                                    : 0.7,
                          ),
                          itemCount: popularMovies.length,
                          itemBuilder: (context, index) {
                            final movie = popularMovies[index];
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
                                duration: const Duration(milliseconds: 200),
                                transform: _hoveredIndex == index
                                    ? (Matrix4.identity()
                                      ..scale(1.05, 1.05)
                                      ..translate(0, -10))
                                    : Matrix4.identity(),
                                child: GestureDetector(
                                  onTap: () {
                                    context.go('/movie/${movie.id}');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      elevation:
                                          _hoveredIndex == index ? 20 : 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            // Ensuring content inside card is scrollable
                                            child: ListView(
                                              // Wrap with ListView
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              children: [
                                                Text(
                                                  movie.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.amber),
                                                    Text(
                                                        '${movie.voteAverage}'),
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
            const SizedBox(
              height: 20,
            ),
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
            ),
          ],
        ),
      );
    });
  }
}
