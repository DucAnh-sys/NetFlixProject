
class Episode {
  final int id;
  final String name;
  final String overview;
  final String stillPath;
  final int episodeNumber;
  final int runtime;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.stillPath,
    required this.episodeNumber,
    required this.runtime,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      stillPath: json['still_path'] ?? '',
      episodeNumber: json['episode_number'] ?? 0,
      runtime: json['runtime'] ?? 0,
    );
  }

  String get fullStillPath => stillPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$stillPath'
      : 'https://via.placeholder.com/500x280?text=No+Preview';
}