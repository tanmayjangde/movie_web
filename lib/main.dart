import 'package:flutter/material.dart';
import 'package:movie_web/home.dart';
import 'package:movie_web/movies.dart';

const apiKey = '2f048e3e025ffe9e1552507e8f3c18e4';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Web App',
      theme: ThemeData.dark(), // Set dark theme here
      home: MainScreen(),
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
