import 'package:clone_netflix/features/discovery/movie_detail.dart';
import 'package:clone_netflix/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/movie.dart';

class MoreLikeThisScreen extends ConsumerWidget {
  final Movie movie;

  const MoreLikeThisScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMoviesAsync = ref.watch(similarMovieProvider(movie));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Nội dung tương tự',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: similarMoviesAsync.when(
          data: (movies) => movies.isEmpty
              ? const Center(
                  child: Text(
                    "Không có nội dung tương tự",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movieItem = movies[index];
                    return MovieCard(
                      movie: movieItem,
                      title: movieItem.title,
                      imageUrl: movieItem.fullPosterPath,
                    );
                  },
                ),
          loading: () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (err, stack) => Center(
            child: Text(
              'Lỗi: $err',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final String title;
  final String imageUrl;

  const MovieCard({
    super.key,
    required this.movie,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie,),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.broken_image, color: Colors.white24),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
