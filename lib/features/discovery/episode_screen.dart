import 'package:clone_netflix/features/discovery/movie_detail.dart';
import 'package:clone_netflix/features/discovery/play_video.dart';
import 'package:clone_netflix/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/episode.dart';
import '../../services/movie_service.dart';

class EpisodeScreen extends ConsumerStatefulWidget {
  final int movieId;
  final MediaType type;

  const EpisodeScreen({super.key, required this.movieId, required this.type});

  @override
  ConsumerState<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends ConsumerState<EpisodeScreen> {
  int selectedSeasonNumber = 1;

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(
      movieDetailProvider(widget.movieId, widget.type),
    );
    final episodesAsync = ref.watch(
      listEpisodeProvider(widget.movieId, selectedSeasonNumber),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: movieAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (movie) =>
              Text(
                movie.originalTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () =>
                  _showSeasonPicker(
                    context,
                    movieAsync.when(
                      data: (movie) => movie.numberOfSeason,
                      error: (error, stack) => 1,
                      loading: () => 1,
                    ),
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mùa $selectedSeasonNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: episodesAsync.when(
              data: (episodes) =>
              episodes.isEmpty
                  ? const Center(
                child: Text(
                  "Không có dữ liệu tập phim",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  return _buildEpisodeItem(
                      movieAsync.when(
                        data: (movie) => movie,
                        error: (error, stack) => throw error!,
                        loading: () => throw Exception('Movie is loading'),
                      ),
                      episodes[index]);
                },
              ),
              loading: () =>
              const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
              error: (err, stack) =>
                  Center(
                    child: Text(
                      'Lỗi: $err',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeItem(Movie movie, Episode episode) {
    return GestureDetector(
      onTap: () async {
        print("movieId: ${movie.id}");
        final String? trailerKey = await ref.read(
          movieTrailerProvider(movie.id, movie.mediaType).future,
        );
        print("Trailer Key: $trailerKey");
        if (trailerKey != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) =>
                  NetflixVideoPlayer(
                    youtubeKey: trailerKey,
                    title: movie.title,
                  ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        episode.fullStillPath,
                        width: 130,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              width: 130,
                              height: 75,
                              color: Colors.grey[900],
                            ),
                      ),
                      const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${episode.episodeNumber}. ${episode.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${episode.runtime} phút',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.file_download_outlined, color: Colors.white),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              episode.overview.isNotEmpty
                  ? episode.overview
                  : 'Nội dung đang được cập nhật...',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showSeasonPicker(BuildContext context, int totalSeasons) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF262626),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalSeasons, (index) => index + 1).map((
                  seasonNum,) {
                return ListTile(
                  title: Center(
                    child: Text(
                      'Mùa $seasonNum',
                      style: TextStyle(
                        color: seasonNum == selectedSeasonNumber
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: seasonNum == selectedSeasonNumber
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() => selectedSeasonNumber = seasonNum);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
