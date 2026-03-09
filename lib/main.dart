import 'package:clone_netflix/features/discovery/home.dart';
import 'package:clone_netflix/features/discovery/playvideo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(title: 'Flutter Demo', home: NetflixVideoPlayer(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',));
    return MaterialApp(title: 'Flutter Demo', home: MovieDetailScreen());
  }
}
