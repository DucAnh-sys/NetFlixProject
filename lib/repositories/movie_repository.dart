import 'dart:convert';

import 'package:clone_netflix/config/api_config.dart';
import 'package:clone_netflix/db/favorite_db.dart';
import 'package:clone_netflix/models/actor.dart';
import 'package:clone_netflix/models/episode.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/movie.dart';

part 'movie_repository.g.dart';

@riverpod
MovieRepository movieRepository(MovieRepositoryRef ref) {
  return MovieRepository();
}

class MovieRepository {
  final Dio _dio;

  MovieRepository()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          queryParameters: {'api_key': ApiConfig.apiKey, 'language': 'en-US'},
        ),
      );

  Future<List<Movie>> fetchMovies(String endpoint, MediaType type) async {
    final String category = type == MediaType.tv ? 'tv' : 'movie';
    try {
      final response = await _dio.get('/$category/$endpoint');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) {
          return Movie.fromJson(json, mediaTypeOverride: type);
        }).toList();
      } else {
        throw Exception('Lỗi lấy dữ liệu: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    } catch (error) {
      print('Unexpected Error: $error');
      rethrow;
    }
  }
  Future<List<Movie>> searchMovies(String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) return [];

    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': cleanQuery,
          'page': 1,
          'include_adult': false,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) {
          return Movie.fromJson(json, mediaTypeOverride: MediaType.movie);
        }).toList();
      } else {
        throw Exception('Lỗi tìm kiếm phim: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    } catch (error) {
      print('Unexpected Error: $error');
      rethrow;
    }
  }
  Future<List<Movie>> fetchMoviePopular() {
    return fetchMovies("popular", MediaType.movie);
  }

  Future<List<Movie>> fetchNowPlaying(){
    return fetchMovies("now_playing", MediaType.movie);
  }

  Future<List<Movie>> fetchUpcoming(){
    return fetchMovies("upcoming", MediaType.movie);
  }

  Future<List<Movie>> fetchTopRated(){
    return fetchMovies("top_rated", MediaType.movie);
  }

  Future<List<Movie>> fetchTvShowPopular() {
    return fetchMovies("popular", MediaType.tv);
  }

  Future<Movie> fetchMovieById(int movieId, MediaType type) async {
    try {
      final String category = type == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/$movieId');
      if (response.statusCode == 200) {
        return Movie.fromJson(response.data);
      } else {
        throw Exception('Không tìm thấy phim với ID: $movieId');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    }
  }

  Future<List<Actor>> fetchActors(int movieId, MediaType type) async {
    try {
      final String category = type == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/$movieId/credits');
      if (response.statusCode == 200) {
        final List<dynamic> castJson = response.data['cast'];
        return castJson.take(15).map((json) => Actor.fromJson(json)).toList();
      }
      throw Exception('Lỗi lấy danh sách diễn viên');
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> fetchTrailerMovie(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/videos');
      print("responseFromRepo: $response");
      if (response.statusCode == 200) {
        final List result = response.data['results'];

        final trailer = result.firstWhere(
          (t) => t['type'] == 'Trailer' && t['site'] == 'YouTube',
          orElse: () => result.firstWhere(
            (t) => t['type'] == 'Teaser' && t['site'] == 'YouTube',
            orElse: () => result.firstWhere(
              (t) => t['type'] == 'Clip' && t['site'] == 'YouTube',
              orElse: () => null,
            ),
          ),
        );
        if (trailer != null) {
          return trailer['key'];
        }
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<List<Movie>> fetchMovieSimilar(int movieId, MediaType type) async {
    try {
      final String category = type == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/$movieId/similar');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) {
          return Movie.fromJson(json, mediaTypeOverride: type);
        }).toList();
      } else {
        throw Exception("not found similar movie");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Episode>> fetchEpisode(int movieId, int seasonNumber) async {
    try {
      final response = await _dio.get('/tv/$movieId/season/$seasonNumber');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['episodes'];
        return results.map((json) => Episode.fromJson(json)).toList();
      } else {
        throw Exception("not found episode for movie: $movieId");
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<List<Movie>> fetchByGenres({
    required List<int> genreIds,
    required bool isMovie,
  }) async {
    if (genreIds.isEmpty) return [];

    final String category = isMovie ? 'movie' : 'tv';
    final MediaType mediaType = isMovie ? MediaType.movie : MediaType.tv;

    try {
      final response = await _dio.get(
        '/discover/$category',
        queryParameters: {
          'with_genres': genreIds.join(','),
          'sort_by': 'popularity.desc',
          'include_adult': false,
          'page': 1,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];

        return results.map((json) {
          return Movie.fromJson(json, mediaTypeOverride: mediaType);
        }).toList();
      } else {
        throw Exception('Lỗi lấy phim theo genre: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    } catch (error) {
      print('Unexpected Error: $error');
      rethrow;
    }
  }
}
