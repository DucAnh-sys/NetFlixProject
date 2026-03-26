import 'package:clone_netflix/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'favorite_db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            backdrop_path TEXT,
            vote_average REAL,
            media_type TEXT
          )
        ''');
      },
    );
  }

  static Future<void> addFavorite(Movie movie) async {
    final db = await FavoriteDb.db;
    await db.insert(
      'favorites',
      movie.toFavoriteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ); //conflictAlgorithm: ConflictAlgorithm.replace tránh trung
  }

  static Future<List<Movie>> getFavoriteFilm() async {
    final db = await FavoriteDb.db;
    final result = await db.query('favorites');
    return result.map((json) {
      return Movie.fromJson(json);
    }).toList();
  }

  static Future<void> deleteFavoriteFilm(int id) async {
    final db = await FavoriteDb.db;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
  static Future<bool> isFavorite(int id) async {
    final db = await FavoriteDb.db;

    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }
}
