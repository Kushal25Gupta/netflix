import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String removeHtmlTags(String htmlText) {
  final RegExp exp = RegExp(r"<[^>]*>");
  return htmlText.replaceAll(exp, '');
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index]['show'];

          var image = movie['image'] != null && movie['image']['medium'] != null
              ? movie['image']['medium']
              : 'assets/images/default_movie_image.jpg';

          var name = movie['name'] ?? 'Untitled Movie';
          var summary = movie['summary'] != null ? removeHtmlTags(movie['summary']) : 'No summary available for this movie.';

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: movie);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                color: Colors.grey[800],
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        height: 120,
                        width: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_movie_image.jpg',
                            height: 120,
                            width: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              summary,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
