import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/actor.dart';
import 'package:project/repositories/MovieRepository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';

part 'movie_provider.g.dart';

@riverpod
Future<List<Movie>> popularMovies(Ref ref) {
  return ref.read(movieRepositoryProvider.notifier).fetchMovies('popular');
}

@riverpod
Future<List<Movie>> upcomingMovies(Ref ref) {
  return ref.read(movieRepositoryProvider.notifier).fetchMovies('upcoming');
}

@riverpod
Future<List<Movie>> nowPlayingMovies(Ref ref) {
  return ref.read(movieRepositoryProvider.notifier).fetchMovies('now_playing');
}

@riverpod
Future<Movie> movieDetail(Ref ref, int movieId) {
  return ref.read(movieRepositoryProvider.notifier).fetchMovieById(movieId);
}

@riverpod
Future<List<Actor>> movieActors(Ref ref, int movieId) {
  return ref.read(movieRepositoryProvider.notifier).fetchActors(movieId);
}