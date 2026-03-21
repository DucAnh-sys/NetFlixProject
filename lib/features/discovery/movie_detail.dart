import 'package:clone_netflix/db/notification_db.dart';
import 'package:clone_netflix/features/discovery/episode_screen.dart';
import 'package:clone_netflix/features/discovery/more_like_this.dart';
import 'package:clone_netflix/features/discovery/play_video.dart';
import 'package:clone_netflix/models/movie.dart';
import 'package:clone_netflix/services/favorite_provider.dart';
import 'package:clone_netflix/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  final MediaType type;

  const MovieDetailScreen({super.key, required this.movieId, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId,type));

    return Scaffold(
      backgroundColor: Colors.black,
      body: movieAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (movie) => CustomScrollView(
          slivers: [
            _SliverMovieHeader(imageUrl: movie.fullBackdropPath),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMovieMetadata(movie.releaseDate),
                    const SizedBox(height: 16),
                    _buildActionButtons(context, ref, movie),
                    const SizedBox(height: 16),

                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'Nội dung đang cập nhật...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInteractionRow(ref,movie),

                    const SizedBox(height: 24),
                    const Text(
                      'Diễn viên chính',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildCastList(ref, movie),

                    const SizedBox(height: 24),
                    _buildNavigationTiles(context, movie),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCastList(WidgetRef ref, Movie movie) {
    final actorsAsync = ref.watch(movieActorsProvider(movieId,type));

    return actorsAsync.when(
      loading: () => const SizedBox(
        height: 110,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, s) => const Text(
        'Không tải được diễn viên',
        style: TextStyle(color: Colors.grey),
      ),
      data: (actors) => SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white10,
                    backgroundImage: NetworkImage(actor.fullProfilePath),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      actor.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieMetadata(String date) {
    final year = date.isNotEmpty ? date.split('-')[0] : 'N/A';
    return Row(
      children: [
        Text(year, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Text(
            '16+',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Text('Phim lẻ', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildNavigationTiles(BuildContext context, Movie movie) {
    return Column(
      children: [
        _buildTile(context, 'Tập phim & Mùa', Icons.video_library_outlined, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => EpisodeScreen(movie: movie)),
          );
        }),
        const Divider(color: Colors.white12),
        _buildTile(
          context,
          'Nội dung tương tự',
          Icons.auto_awesome_motion_outlined,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => MoreLikeThisScreen(movieId: movieId,type: type),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    String t,
    IconData i,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(i, color: Colors.white),
      title: Text(
        t,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 14,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Movie movie) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () async {
            print("movieId: $movie.id");
            final String? trailerKey = await ref.read(
              movieTrailerProvider(movie.id).future,
            );
            print("Trailer Key: $trailerKey");
            if (trailerKey != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => NetflixVideoPlayer(
                    youtubeKey: trailerKey,
                    title: movie.title,
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text(
            'Phát',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF262626),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 45),
          ),
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Tải xuống'),
        ),
      ],
    );
  }

  Widget _buildInteractionRow(WidgetRef ref, Movie movie) {
    final favorites = ref.watch(favoriteProvider);
    final notifier = ref.read(favoriteProvider.notifier);

    final isFav = favorites.any((m) => m.id == movie.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        GestureDetector(
          onTap: () async {
            await notifier.toggle(movie);
            await NotificationDb.addNotification(movie);
          },
          child: Column(
            children: [
              Icon(
                isFav ? Icons.favorite : Icons.add,
                color: isFav ? Colors.red : Colors.white,
                size: 24,
              ),
              const SizedBox(height: 5),
              const Text(
                'Danh sách',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),

        _VerticalIconBtn(Icons.thumb_up_outlined, 'Xếp hạng'),
        _VerticalIconBtn(Icons.share, 'Chia sẻ'),
      ],
    );
  }
}

class _SliverMovieHeader extends StatelessWidget {
  final String imageUrl;

  const _SliverMovieHeader({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.grey[900]),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalIconBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _VerticalIconBtn(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
