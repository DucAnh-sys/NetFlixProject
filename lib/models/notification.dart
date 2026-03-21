class Notificationmodel {
  final int? id;
  final int movieId;
  final String title;
  final String description;
  final String image;
  final String createdAt;

  Notificationmodel({
    this.id,
    required this.movieId,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'title': title,
      'description': description,
      'image': image,
      'createdAt': createdAt,
    };
  }

  factory Notificationmodel.fromMap(Map<String, dynamic> map) {
    return Notificationmodel(
      id: map['id'],
      movieId: map['movieId'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      createdAt: map['createdAt'],
    );
  }
}
