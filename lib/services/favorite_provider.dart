import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/favorite_db.dart';
import '../models/movie.dart';

class FavoriteNotifier extends StateNotifier<List<Movie>> {
  FavoriteNotifier() : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await FavoriteDb.getFavoriteFilm();
    state = data;
  }

  bool isFavorite(int id) {
    return state.any((m) => m.id == id);
  }

  Future<void> toggle(Movie movie) async {
    final exists = isFavorite(movie.id);

    if (exists) {
      await FavoriteDb.deleteFavoriteFilm(movie.id);
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      await FavoriteDb.addFavorite(movie);
      state = [...state, movie];
    }
  }
}

final favoriteProvider =
StateNotifierProvider<FavoriteNotifier, List<Movie>>(
      (ref) => FavoriteNotifier(),
);