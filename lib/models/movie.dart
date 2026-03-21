enum MediaType {
  movie,
  tv,
  unknown;

  static MediaType fromString(String? type) {
    if (type == 'movie') return MediaType.movie;
    if (type == 'tv') return MediaType.tv;
    return MediaType.unknown;
  }

  String get value => name;
}

class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final int numberOfSeason;
  final MediaType mediaType;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfSeason,
    required this.mediaType,
  });

  factory Movie.fromJson(Map<String, dynamic> json, {MediaType? mediaTypeOverride}) {
    MediaType type = mediaTypeOverride ?? MediaType.fromString(json['media_type']);

    if (type == MediaType.unknown) {
      if (json['first_air_date'] != null || json['name'] != null) {
        type = MediaType.tv;
      } else {
        type = MediaType.movie;
      }
    }

    return Movie(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: json['genre_ids'] != null ? List<int>.from(json['genre_ids']) : [],
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      title: (type == MediaType.tv ? json['name'] : json['title']) ?? 'No Title',
      originalTitle: (type == MediaType.tv ? json['original_name'] : json['original_title']) ?? '',
      releaseDate: (type == MediaType.tv ? json['first_air_date'] : json['release_date']) ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      numberOfSeason: json['number_of_seasons'] ?? 0,
      mediaType: type,
    );
  }

  Movie copyWith({
    bool? adult,
    String? backdropPath,
    List<int>? genreIds,
    int? id,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    String? releaseDate,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
    int? numberOfSeason,
    MediaType? mediaType,
  }) {
    return Movie(
      adult: adult ?? this.adult,
      backdropPath: backdropPath ?? this.backdropPath,
      genreIds: genreIds ?? this.genreIds,
      id: id ?? this.id,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
      title: title ?? this.title,
      video: video ?? this.video,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      numberOfSeason: numberOfSeason ?? this.numberOfSeason,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'media_type': mediaType.value,
      'release_date': releaseDate,
      'overview': overview,
      'vote_average': voteAverage,
    };
  }

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : 'https://via.placeholder.com/1280x720?text=No+Image';

  String get fullPosterPath => posterPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Poster';
}