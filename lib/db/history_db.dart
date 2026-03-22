import 'package:clone_netflix/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'history_db.b');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE history(
      id INTEGER PRIMARY KEY,
      title TEXT,
      poster_path TEXT,
      backdrop_path TEXT,
      vote_average REAL,
      media_type TEXT,
      watched_at TEXT
    )
  ''');
      },
    );
  }
 static Future<void> insertHistory(Movie movie) async {
    final dbClient = await db;

    await dbClient.insert(
      'history',
      {
        ...movie.toFavoriteMap(),
        'watched_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Movie>> getHistory() async{
    final db = await HistoryDb.db;
    final result = await db.query("history");
    return result.map((json) {
      return Movie(
        adult: false,
        backdropPath: json['backdrop_path'] as String? ?? '',
        genreIds: [],
        id: json['id'] as int,
        originalLanguage: '',
        originalTitle: json['title'] as String? ?? '',
        overview: '',
        popularity: 0,
        posterPath: json['poster_path'] as String? ?? '',
        releaseDate: '',
        title: json['title'] as String? ?? '',
        video: false,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
        voteCount: 0,
        mediaType: MediaType.fromString(json['media_type'] as String?),
        numberOfSeason: 0,
      );
    }).toList();
  }
  static Future<void> deleteHistory(int id) async {
    final dbClient = await db;

    await dbClient.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  static Future<void> clearHistory() async {
    final dbClient = await db;
    await dbClient.delete('history');
  }
}
