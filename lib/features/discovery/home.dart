
import 'package:flutter/material.dart';
import 'package:project/features/discovery/playvideo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class MovieDetailScreen extends ConsumerWidget  {
  const MovieDetailScreen({super.key, required int movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: [
            const _SliverMovieHeader(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STRANGER THINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMovieMetadata(),
                    const SizedBox(height: 16),
                    _buildActionButtons(context),
                    const SizedBox(height: 16),
                    const Text(
                      'Khi một cậu bé mất tích, một thị trấn nhỏ phơi bày một bí ẩn liên quan đến các thí nghiệm bí mật, các lực lượng siêu nhiên đáng sợ và một cô bé kỳ lạ.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Diễn viên: Winona Ryder, David Harbour, Millie Bobby Brown...',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    _buildInteractionRow(),
                  ],
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  indicatorColor: Color(0xFFE50914),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'TẬP PHIM'),
                    Tab(text: 'NỘI DUNG TƯƠNG TỰ'),
                    Tab(text: 'TRAILER'),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white12, width: 0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/image/image.jpg',
                            width: 120,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Stranger Things',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Cậu bé mất tích là một loạt phim truyền hình chiếu mạng thế loại khoa...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.more_vert, color: Colors.white54),
                      ],
                    ),
                  );
                }, childCount: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieMetadata() {
    return Row(
      children: [
        const Text('2022', style: TextStyle(color: Colors.grey)),
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
        const Text('4 Mùa', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NetflixVideoPlayer(
                  videoUrl:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                ),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text(
            'Phát',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF262626),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
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
  const _SliverMovieHeader();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/image/image.jpg', fit: BoxFit.cover),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.black, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
