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
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // Clear search text
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _onItemTapped(0),
            child: Text(
              'Home',
              style: TextStyle(
                  color: Color(0xFFE2B616), fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => _onItemTapped(1),
            child: Text(
              'Movies',
              style: TextStyle(
                  color: Color(0xFFE2B616), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
