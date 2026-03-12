import 'package:clone_netflix/features/discovery/episode_screen.dart';
import 'package:clone_netflix/features/discovery/more_like_this.dart';
import 'package:clone_netflix/features/discovery/play_video.dart';
import 'package:clone_netflix/services/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch dữ liệu phim chi tiết
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: movieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white))),
        data: (movie) => CustomScrollView(
          slivers: [
            // Header với ảnh backdrop từ API
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
                    _buildActionButtons(context, movie.title),
                    const SizedBox(height: 16),

                    // Nội dung phim
                    Text(
                      movie.overview.isNotEmpty ? movie.overview : 'Nội dung đang cập nhật...',
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    _buildInteractionRow(),

                    const SizedBox(height: 24),
                    const Text(
                      'Diễn viên chính',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Danh sách diễn viên thật từ API
                    _buildCastList(ref, movieId),

                    const SizedBox(height: 24),
                    _buildNavigationTiles(context, movie.title),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET DIỄN VIÊN THẬT ---
  Widget _buildCastList(WidgetRef ref, int id) {
    final actorsAsync = ref.watch(movieActorsProvider(id));

    return actorsAsync.when(
      loading: () => const SizedBox(height: 110, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (e, s) => const Text('Không tải được diễn viên', style: TextStyle(color: Colors.grey)),
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

  // --- CÁC WIDGET GIAO DIỆN KHÁC ---
  Widget _buildMovieMetadata(String date) {
    final year = date.isNotEmpty ? date.split('-')[0] : 'N/A';
    return Row(
      children: [
        Text(year, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2)),
          child: const Text('16+', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 15),
        const Text('Phim lẻ', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildNavigationTiles(BuildContext context, String title) {
    return Column(
      children: [
        _buildTile(context, 'Tập phim & Mùa', Icons.video_library_outlined, () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => EpisodeScreen(movieTitle: title)));
        }),
        const Divider(color: Colors.white12),
        _buildTile(context, 'Nội dung tương tự', Icons.auto_awesome_motion_outlined, () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => MoreLikeThisScreen(movieTitle: title)));
        }),
      ],
    );
  }

  Widget _buildTile(BuildContext context, String t, IconData i, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(i, color: Colors.white),
      title: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
    );
  }

  Widget _buildActionButtons(BuildContext context, String title) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => NetflixVideoPlayer(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))),
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text('Phát', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF262626), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 45)),
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Tải xuống'),
        ),
      ],
    );
  }

  Widget _buildInteractionRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _VerticalIconBtn(Icons.add, 'Danh sách'),
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
            Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900])),
            const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black]))),
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