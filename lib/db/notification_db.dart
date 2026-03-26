import 'package:clone_netflix/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'notification_db.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE notifications(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  movieId INTEGER,
  title TEXT,
  description TEXT,
  image TEXT,
  createdAt TEXT
)
        ''');
      },
    );
  }

  static Future<void> addNotification(Movie movie) async {
    final dbClient = await NotificationDb.db;

    await dbClient.insert(
      'notifications',
      {
        'movieId': movie.id,
        'title': 'Đã thêm vào danh sách',
        'description': 'Bạn đã thêm ${movie.title} thành công',
        'image': movie.fullPosterPath,
        'createdAt': DateTime.now().toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final dbClient = await NotificationDb.db;

    return await dbClient.query(
      'notifications',
      orderBy: 'id DESC',
    );
  }
  Future<void> loadNotifications() async {
    final data = await NotificationDb.getNotifications();
    print(data);
  }
  static Future<int> getCount() async {
    final dbClient = await NotificationDb.db;

    final result = await dbClient.rawQuery(
      'SELECT COUNT(*) as count FROM notifications',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
 static Future<void> deleteNotifier(int id) async{
    final db = await NotificationDb.db;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
