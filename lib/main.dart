import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'search_screen.dart';
import 'details_screen.dart';
import 'bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Splash screen is the entry point
        '/home': (context) => MainScreen(), // Main screen with Bottom Navigation
        '/search': (context) => SearchScreen(),
        '/details': (context) => DetailsScreen(),
      },
    );
  }
}
