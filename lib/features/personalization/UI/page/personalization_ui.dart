import 'package:clone_netflix/features/discovery/movie_detail.dart';
import 'package:clone_netflix/services/favorite_provider.dart';
import 'package:clone_netflix/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_list_film_ui.dart';
import 'notification_ui.dart';

class MyNetflixScreen extends StatelessWidget {
  const MyNetflixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              const ProfileHeader(),

              const SizedBox(height: 20),

              const DownloadCard(),

              const SizedBox(height: 25),

              // const SectionTitle(title: "Tác phẩm bạn đã thích"),
              // const SizedBox(height: 12),
              //
              // const MovieRow(),

              const SizedBox(height: 25),

              SectionTitle(
                title: "Bộ phim yêu thích của tôi",
                showMore: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyListScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              const MovieRow(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFE50914),
        unselectedItemColor: Colors.white54,
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Tìm kiếm",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Netflix của tôi",
          ),
        ],
      ),
    );
  }
}
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),

          const SizedBox(width: 10),

          const Text(
            "❤️❤️❤️",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Icon(Icons.arrow_drop_down, color: Colors.white),

          const Spacer(),

          const Icon(Icons.download, color: Colors.white),

          const SizedBox(width: 15),

          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
class DownloadCard extends StatelessWidget {
  const DownloadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [

            const Icon(Icons.download, color: Colors.white),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Tệp tải xuống",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Các bộ phim và chương trình bạn tải xuống xuất hiện tại đây.",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)
          ],
        ),
      ),
    );
  }
}
class SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.showMore = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          if (showMore)
            GestureDetector(
              onTap: onTap,
              child: const Row(
                children: [
                  Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.white54,
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
class MovieRow extends ConsumerWidget {
  const MovieRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final movies = ref.watch(favoriteProvider); // ✅ List<Movie>

    // 🔥 CASE 1: KHÔNG CÓ PHIM
    if (movies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Hãy thêm phim yêu thích của bạn ❤️",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      );
    }

    // 🔥 CASE 2: CÓ PHIM
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),

        itemBuilder: (context, index) {

          final movie = movies[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailScreen(movie: movie),
                ),
              );
            },

            child: Column(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.fullPosterPath,
                    width: 130,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 6),

                const Row(
                  children: [
                    Icon(Icons.share, color: Colors.white54, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "Chia sẻ",
                      style: TextStyle(color: Colors.white54),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}