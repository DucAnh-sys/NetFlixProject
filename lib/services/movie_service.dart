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
Future<List<Movie>> upcomingMovies(UpcomingMoviesRef ref){
  return ref.watch(movieRepositoryProvider).fetchUpcoming();
}

@riverpod
Future<List<Movie>> topRatedMovies(TopRatedMoviesRef ref){
  return ref.watch(movieRepositoryProvider).fetchTopRated();
}

@riverpod
Future<List<Movie>> nowPlayingMovies(NowPlayingMoviesRef ref){
  return ref.watch(movieRepositoryProvider).fetchNowPlaying();
}

@riverpod
Future<Movie> movieDetail(MovieDetailRef ref, int movieId, MediaType type) {
  return ref.watch(movieRepositoryProvider).fetchMovieById(movieId,type);
}

@riverpod
Future<List<Actor>> movieActors(MovieActorsRef ref, int movieId, MediaType type) {
  return ref.watch(movieRepositoryProvider).fetchActors(movieId,type);
}

@riverpod
Future<String?> movieTrailer(MovieTrailerRef ref, int movieId, MediaType type){
  return ref.watch(movieRepositoryProvider).fetchTrailerMovie(movieId,type);
}

@riverpod
Future<List<Movie>> similarMovie(SimilarMovieRef ref, int movieId, MediaType type){
  return ref.watch(movieRepositoryProvider).fetchMovieSimilar(movieId,type);
}

@riverpod
Future<List<Episode>> listEpisode(ListEpisodeRef ref, int movieId, int seasonNumber) {
  return ref.watch(movieRepositoryProvider).fetchEpisode(movieId, seasonNumber);
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

  return ref.read(movieRepositoryProvider).searchMovies(query);
}

class FilteredMoviesParams {
  final List<int> genreIds;
  final bool isMovie;

  const FilteredMoviesParams({
    required this.genreIds,
    required this.isMovie,
  });

  @override
  bool operator ==(Object other) {
    return other is FilteredMoviesParams &&
        other.isMovie == isMovie &&
        _sameGenreIds(other.genreIds, genreIds);
  }

  @override
  int get hashCode => Object.hash(
    isMovie,
    Object.hashAll([...genreIds]..sort()),
  );

  static bool _sameGenreIds(List<int> a, List<int> b) {
    if (a.length != b.length) return false;

    final sortedA = [...a]..sort();
    final sortedB = [...b]..sort();

    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}

@riverpod
Future<List<Movie>> filteredMovies(
    FilteredMoviesRef ref,
    FilteredMoviesParams params,
    ) {
  return ref.watch(movieRepositoryProvider).fetchByGenres(
    genreIds: params.genreIds,
    isMovie: params.isMovie,
  );
}


