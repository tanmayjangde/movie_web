import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_web/movie_details.dart';
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
      setState(() {
        searchResults = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
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
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
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
                        style: const TextStyle(color: Color(0xFFE2B616)),
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
    );
  }
}
