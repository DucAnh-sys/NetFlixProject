import 'package:clone_netflix/features/personalization/UI/page/personalization_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Đảm bảo đã import cái này
import 'features/content/search_screen.dart';
import 'features/discovery/movie_detail.dart';
import 'features/content/homepage.dart';
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080404),
        fontFamily: 'SplineSans',
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/my-list': (context) => const MyNetflixScreen(),
      },
    );
  }
}