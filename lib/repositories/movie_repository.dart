  import 'package:clone_netflix/config/api_config.dart';
  import 'package:dio/dio.dart';
  import 'package:riverpod_annotation/riverpod_annotation.dart';
  import '../../models/movie.dart';

  part 'movie_repository.g.dart';

  @riverpod
  class MovieRepository extends _$MovieRepository {

    late final Dio _dio;

    @override
    void build() {
      _dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'vi-VN',
        },
      ));
    }

    Future<List<Movie>> fetchMovies(String endpoint) async {
      try {
        final response = await _dio.get('/movie/$endpoint');

        if (response.statusCode == 200) {
          final List<dynamic> results = response.data['results'];
          return results.map((json) => Movie.fromJson(json)).toList();
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

    Future<Movie> fetchMovieById(int id) async {
      try {
        final response = await _dio.get('/movie/$id');

        if (response.statusCode == 200) {
          return Movie.fromJson(response.data);
        } else {
          throw Exception('Không tìm thấy phim với ID: $id');
        }
      } on DioException catch (e) {
        print('Dio Error: ${e.message}');
        rethrow;
      }
    }

    Future<void> addToWatchlist(Movie movie) async {
      print("Đã thêm ${movie.title} vào danh sách");
    }
  }