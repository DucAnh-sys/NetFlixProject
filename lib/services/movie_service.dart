import 'package:clone_netflix/db/favorite_db.dart';
import 'package:clone_netflix/models/actor.dart';
import 'package:clone_netflix/models/episode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

part 'movie_service.g.dart';

@riverpod
Future<List<Movie>> popularMovies(PopularMoviesRef ref) {
  return ref.watch(movieRepositoryProvider).fetchMoviePopular();
}
@riverpod
Future<List<Movie>> popularTvShow(PopularTvShowRef ref){
  return ref.watch(movieRepositoryProvider).fetchTvShowPopular();
}

@riverpod
Future<Movie> movieDetail(MovieDetailRef ref, Movie movie) {
  return ref.watch(movieRepositoryProvider).fetchMovieById(movie);
}

@riverpod
Future<List<Actor>> movieActors(MovieActorsRef ref, Movie movie) {
  return ref.watch(movieRepositoryProvider).fetchActors(movie);
}

@riverpod
Future<String?> movieTrailer(MovieTrailerRef ref, int movieId){
  return ref.watch(movieRepositoryProvider).fetchTrailerMovie(movieId);
}

@riverpod
Future<List<Movie>> similarMovie(SimilarMovieRef ref, Movie movie){
  return ref.watch(movieRepositoryProvider).fetchMovieSimilar(movie);
}

@riverpod
Future<List<Episode>> listEpisode(ListEpisodeRef ref, int movieId, int seasonNumber) {
  return ref.watch(movieRepositoryProvider).fetchEpisode(movieId,seasonNumber);
}
