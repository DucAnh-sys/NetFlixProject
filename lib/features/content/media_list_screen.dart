import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/movie.dart';
import '../../services/movie_service.dart';
import '../discovery/movie_detail.dart';

class MediaListScreen extends ConsumerStatefulWidget {
  final bool isMovie;
  const MediaListScreen({super.key, required this.isMovie});

  @override
  ConsumerState<MediaListScreen> createState() => _MediaListScreenState();
}

class _MediaListScreenState extends ConsumerState<MediaListScreen> {
  String sortBy = 'Release Date';

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(widget.isMovie ? popularMoviesProvider : popularTvShowProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMovie ? 'Movies' : 'TV Shows'),
        backgroundColor: const Color(0xFF080404),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => sortBy = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Alphabet', child: Text('Sắp xếp A-Z')),
              const PopupMenuItem(value: 'Rating', child: Text('Rating cao nhất')),
              const PopupMenuItem(value: 'Release Date', child: Text('Mới nhất')),
            ],
          ),
        ],
      ),
      body: mediaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
        data: (list) {

          List<Movie> sortedList = List.from(list);
          if (sortBy == 'Alphabet') {
            sortedList.sort((a, b) => a.title.compareTo(b.title));
          } else if (sortBy == 'Rating') {
            sortedList.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
          } else if (sortBy == 'Release Date') {
            sortedList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
          }

          return ListView.builder(
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final item = sortedList[index];
              return _buildMediaCard(context, item);
            },
          );
        },
      ),
    );
  }

  Widget _buildMediaCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movieId: movie.id,type: movie.mediaType),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color(0xFF1A1A1A),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.fullPosterPath,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          ' ${movie.voteAverage.toStringAsFixed(1)} ',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          movie.releaseDate,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}