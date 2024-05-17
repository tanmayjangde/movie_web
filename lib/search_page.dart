import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_web/movie_model.dart';

class SearchPage extends StatefulWidget {
  final String query;

  const SearchPage({Key? key, required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?query=${widget.query}&api_key=2f048e3e025ffe9e1552507e8f3c18e4'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      searchResults = (data['results'] as List)
          .map((movieData) => Movie.fromJson(movieData))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? Center(child: Text('No results found.'))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 6,
                      child: InkWell(
                        onTap: () {
                          context.go('/movie/${movie.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      movie.overview,
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors
                                                    .yellow), // Vote count icon
                                            Text(
                                                'Vote Count: ${movie.voteCount}'),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.trending_up,
                                                color: Colors
                                                    .orange), // Popularity icon
                                            Text(
                                                'Popularity: ${movie.popularity}'),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                color: Colors
                                                    .green), // Release date icon
                                            Text(
                                                'Release Date: ${movie.releaseDate}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
