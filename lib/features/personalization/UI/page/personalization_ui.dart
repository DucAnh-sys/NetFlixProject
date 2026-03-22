
import 'package:clone_netflix/db/notification_db.dart';
import 'package:clone_netflix/features/component/footer.dart';
import 'package:clone_netflix/features/discovery/movie_detail.dart';
import 'package:clone_netflix/features/personalization/UI/page/history_screen.dart';
import 'package:clone_netflix/services/favorite_provider.dart';
import 'package:clone_netflix/services/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_list_film_ui.dart';
import 'notification_ui.dart';
import 'package:clone_netflix/models/movie.dart';

class MyNetflixScreen extends StatelessWidget {
  final int movieId;
  final MediaType type;
  const MyNetflixScreen({super.key, this.movieId=0,this.type=MediaType.movie});

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

               ProfileHeader(movieId: movieId, type: type),

              const SizedBox(height: 20),

              const DownloadCard(),

              const SizedBox(height: 25),

              const SizedBox(height: 25),

              SectionTitle(
                title: "Bộ phim yêu thích của tôi",
                showMore: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyListScreen()),
                  );
                },
              ),

              const SizedBox(height: 12),

              const MovieRow(),
              const SizedBox(height: 25),

              SectionTitle(
                title: "Đã xem gần đây",
                showMore: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>HistoryScreen(movieId: movieId, type: type),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

               HistoryRow(movieId: movieId, type: type),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppFooter(currentIndex: 2)
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final int movieId;
  final MediaType type;
  const ProfileHeader({super.key,required this.movieId,required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.movie,
            color: Color(0xFFE50914),
            size: 24,
          ),
        ),

          const SizedBox(width: 10),

          const Spacer(),

          const Icon(Icons.download, color: Colors.white),

          const SizedBox(width: 15),


          FutureBuilder<int>(
            future: NotificationDb.getCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationScreen(movieId: movieId, type: type),
                        ),
                      );


                      (context as Element).markNeedsBuild();
                    },
                  ),


                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            count > 99 ? "99+" : "$count",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                  builder: (_) => MovieDetailScreen(movieId: movie.id,type: movie.mediaType),
                ),
              ).then((_) {
                ref.refresh(historyProvider); // 🔥 thêm dòng này
              });
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
class HistoryRow extends ConsumerWidget {
  final int movieId;
  final MediaType type;
  const HistoryRow({super.key,required this.movieId,required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Text("Error: $e"),

      data: (movies) {
        if (movies.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Bạn chưa xem phim nào 🎬",
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

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
                      builder: (_) => MovieDetailScreen(movieId: movie.id,type: type,),
                    ),
                  ).then((_) {
                    ref.refresh(historyProvider);
                  });
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
                    const Text(
                      "Đã xem",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}