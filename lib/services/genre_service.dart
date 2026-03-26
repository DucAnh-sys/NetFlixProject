import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/Genres.dart';

class GenreService {
  static const String _apiKey = 'e9e9d8da18ae29fc430845952232787c';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Genre>> fetchMovieGenres() async {
    final url = Uri.parse(
      '$_baseUrl/genre/movie/list?api_key=$_apiKey&language=en-US',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List genres = data['genres'] ?? [];
      return genres.map((e) => Genre.fromJson(e)).toList();
    }

    throw Exception('Không tải được movie genres');
  }

  Future<List<Genre>> fetchTvGenres() async {
    final url = Uri.parse(
      '$_baseUrl/genre/tv/list?api_key=$_apiKey&language=en-US',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List genres = data['genres'] ?? [];
      return genres.map((e) => Genre.fromJson(e)).toList();
    }

    throw Exception('Không tải được tv genres');
  }
}

final genreServiceProvider = Provider<GenreService>((ref) {
  return GenreService();
});

final movieGenresProvider = FutureProvider<List<Genre>>((ref) async {
  final service = ref.read(genreServiceProvider);
  return service.fetchMovieGenres();
});

final tvGenresProvider = FutureProvider<List<Genre>>((ref) async {
  final service = ref.read(genreServiceProvider);
  return service.fetchTvGenres();
});