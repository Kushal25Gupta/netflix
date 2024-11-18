import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String removeHtmlTags(String htmlText) {
  final RegExp exp = RegExp(r"<[^>]*>");
  return htmlText.replaceAll(exp, '');
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController controller = TextEditingController();

  searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: searchMovies,
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var movie = searchResults[index]['show'];
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
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
