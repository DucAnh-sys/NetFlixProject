import 'package:clone_netflix/models/actor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

part 'movie_service.g.dart';

@riverpod
Future<List<Movie>> popularMovies(PopularMoviesRef ref) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMoviePopular();
}
@riverpod
Future<List<Movie>> popularTvShow(PopularTvShowRef ref){
  return ref.watch(movieRepositoryProvider.notifier).fetchTvShowPopular();
}
@riverpod
Future<List<Movie>> upcomingMovies(UpcomingMoviesRef ref){
  return ref.watch(movieRepositoryProvider.notifier).fetchUpcoming();
}
@riverpod
Future<List<Movie>> topRatedMovies(TopRatedMoviesRef ref){
  return ref.watch(movieRepositoryProvider.notifier).fetchTopRated();
}
@riverpod
Future<List<Movie>> nowPlayingMovies(NowPlayingMoviesRef ref){
  return ref.watch(movieRepositoryProvider.notifier).fetchNowPlaying();
}

@riverpod
Future<Movie> movieDetail(MovieDetailRef ref, Movie movie) {
  return ref.watch(movieRepositoryProvider.notifier).fetchMovieById(movie);
}

@riverpod
Future<List<Actor>> movieActors(MovieActorsRef ref, Movie movie) {
  return ref.watch(movieRepositoryProvider.notifier).fetchActors(movie);
}

@riverpod
Future<String?> movieTrailer(MovieTrailerRef ref, int movieId){
  return ref.watch(movieRepositoryProvider.notifier).fetchTrailerMovie(movieId);
}

@riverpod
Future<List<Movie>> similarMovie(SimilarMovieRef ref, Movie movie){
  return ref.watch(movieRepositoryProvider.notifier).fetchMovieSimilar(movie);
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String value) => state = value;
  void clear() => state = '';
}

@riverpod
Future<List<Movie>> searchMovies(SearchMoviesRef ref) async {
  final query = ref.watch(searchQueryProvider).trim();

  if (query.isEmpty) return [];

  await Future.delayed(const Duration(milliseconds: 400));

  if (query != ref.read(searchQueryProvider).trim()) {
    return [];
  }

  return ref.read(movieRepositoryProvider.notifier).searchMovies(query);
}
