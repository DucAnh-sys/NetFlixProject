import 'package:clone_netflix/config/api_config.dart';
import 'package:clone_netflix/models/actor.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/movie.dart';

part 'movie_repository.g.dart';

@riverpod
class MovieRepository extends _$MovieRepository {
  late final Dio _dio;

  @override
  void build() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        queryParameters: {'api_key': ApiConfig.apiKey, 'language': 'vi-VN'},
      ),
    );
  }

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

  Future<List<Movie>> fetchMoviePopular() {
    return fetchMovies("popular", MediaType.movie);
  }

  Future<List<Movie>> fetchTvShowPopular() {
    return fetchMovies("popular", MediaType.tv);
  }

  Future<Movie> fetchMovieById(Movie movie) async {
    try {
      final String category = movie.mediaType == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/${movie.id}');

      if (response.statusCode == 200) {
        return Movie.fromJson(response.data);
      } else {
        throw Exception('Không tìm thấy phim với ID: ${movie.id}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    }
  }

  Future<List<Actor>> fetchActors(Movie movie) async {
    try {
      final String category = movie.mediaType == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/${movie.id}/credits');
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

  Future<List<Movie>> fetchMovieSimilar(Movie movie) async {
    try {
      final String category = movie.mediaType == MediaType.tv ? 'tv' : 'movie';
      final response = await _dio.get('/$category/${movie.id}/similar');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) {
          return Movie.fromJson(json, mediaTypeOverride: movie.mediaType);
        }).toList();
      } else {
        throw Exception("not found similar movie");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addToWatchlist(Movie movie) async {
    print("Đã thêm ${movie.title} vào danh sách");
  }
}
