import 'package:clone_netflix/db/history_db.dart';
import 'package:clone_netflix/models/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyProvider = FutureProvider<List<Movie>>((ref) async {
  return await HistoryDb.getHistory();
});