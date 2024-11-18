import 'package:flutter/material.dart';

String removeHtmlTags(String htmlText) {
  final RegExp exp = RegExp(r"<[^>]*>");
  return htmlText.replaceAll(exp, '');
}

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map;

    var image = movie['image'] != null && movie['image']['original'] != null
        ? movie['image']['original']
        : null;

    var name = movie['name'] ?? 'Untitled Movie';
    var summary = movie['summary'] != null
        ? removeHtmlTags(movie['summary'])
        : 'No summary available for this movie.';
    var genres = movie['genres']?.join(', ') ??
        'No genres available.';
    var rating = movie['rating'] != null
        ? movie['rating']['average'].toString()
        : 'No rating available.';
    var premiered = movie['premiered'] ??
        'Unknown premiere date.';
    var network = movie['network'] != null
        ? movie['network']['name']
        : 'Unknown network.';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image != null
                    ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_movie_image.jpg',
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                    );
                  },
                )
                    : Image.asset(
                  'assets/images/default_movie_image.jpg',
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 20),

              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Genres: $genres',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),

              Text(
                'Rating: $rating',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),

              Text(
                'Premiered: $premiered',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),

              Text(
                'Network: $network',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),

              Text(
                'Summary:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                summary,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
