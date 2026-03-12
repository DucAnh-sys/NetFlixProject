class Actor {
  final int id;
  final String name;
  final String originalName;
  final String? profilePath;
  final String character;
  final double popularity;
  final int order;

  Actor({
    required this.id,
    required this.name,
    required this.originalName,
    this.profilePath,
    required this.character,
    required this.popularity,
    required this.order,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      profilePath: json['profile_path'],
      character: json['character'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      order: json['order'] ?? 0,
    );
  }

  String get fullProfilePath {
    if (profilePath != null && profilePath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w200$profilePath';
    }
    return 'https://ui-avatars.com/api/?name=$name&background=random&color=fff';
  }
}