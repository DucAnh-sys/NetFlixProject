import 'package:clone_netflix/features/discovery/episode_screen.dart';
import 'package:clone_netflix/features/discovery/more_like_this.dart';
import 'package:clone_netflix/features/discovery/play_video.dart';
import 'package:clone_netflix/services/movie_provider.dart'; // Import provider của Hiếu
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gọi Provider để lấy dữ liệu phim theo ID
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: Colors.black,
      // Dùng .when để quản lý trạng thái Async dữ liệu
      body: movieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(child: Text('Lỗi: $err', style: const TextStyle(color: Colors.white))),
        data: (movie) => CustomScrollView(
          slivers: [
            // Truyền link ảnh từ API vào Header
            _SliverMovieHeader(
              imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
            ),
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
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'Nội dung phim đang được cập nhật...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInteractionRow(),

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
                    _buildCastList(),

                    const SizedBox(height: 24),
                    _buildNavigationTile(
                      context,
                      title: 'Tập phim & Mùa',
                      icon: Icons.video_library_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EpisodeScreen(movieTitle: movie.title),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.white12),
                    _buildNavigationTile(
                      context,
                      title: 'Nội dung tương tự',
                      icon: Icons.auto_awesome_motion_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreLikeThisScreen(movieTitle: movie.title),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.white12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cập nhật lấy năm phát hành thực tế
  Widget _buildMovieMetadata(String releaseDate) {
    final year = releaseDate.isNotEmpty ? releaseDate.split('-')[0] : 'N/A';
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
            '16+', // Phần này TMDB cần API riêng, tạm để cứng hoặc logic theo adult
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 15),
        const Text('Phim lẻ', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // --- CÁC WIDGET PHỤ TRỢ (GIỮ NGUYÊN HOẶC CHỈNH NHẸ) ---

  Widget _buildCastList() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return const Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white10,
                  backgroundImage: AssetImage('assets/image/actor.jpg'),
                ),
                SizedBox(height: 8),
                Text('Actor Name', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationTile(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NetflixVideoPlayer(
                  videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                ),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text('Phát', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF262626),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
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
        _VerticalIconBtn(Icons.comment, 'Bình Luận'),
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
              // Xử lý khi ảnh bị lỗi link từ API
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
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
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}