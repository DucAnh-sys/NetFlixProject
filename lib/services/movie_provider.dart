import 'package:clone_netflix/models/actor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

part 'movie_provider.g.dart';

@riverpod
Future<List<Movie>> popularMovies(PopularMoviesRef ref) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMovies('popular');
}

@riverpod
Future<List<Movie>> upcomingMovies(UpcomingMoviesRef ref) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMovies('upcoming');
}

@riverpod
Future<List<Movie>> nowPlayingMovies(NowPlayingMoviesRef ref) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMovies('now_playing');
}

@riverpod
Future<Movie> movieDetail(MovieDetailRef ref, int movieId) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMovieById(movieId);
}

@riverpod
Future<List<Actor>> movieActors(MovieActorsRef ref, int movieId) {
  return ref.watch(movieRepositoryProvider.notifier).fetchActors(movieId);
}
