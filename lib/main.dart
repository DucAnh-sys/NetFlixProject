import 'package:flutter/material.dart';
import 'package:project/UI/page/MyListFilmUI.dart';
import 'package:project/UI/page/NotificationsUI.dart';
import 'package:project/UI/page/PersonalizationUI.dart';
import 'package:project/UI/page/ReviewUI.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyNetflixScreen(),
    );
  }
}
