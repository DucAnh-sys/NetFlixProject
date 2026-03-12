import 'package:flutter/material.dart';

class MoreLikeThisScreen extends StatelessWidget {
  final String movieTitle;
  const MoreLikeThisScreen({super.key, required this.movieTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Nội dung tương tự: $movieTitle',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: GridView.builder(
          // Với ảnh ngang và có text bên dưới, tỷ lệ 16/11 là khá ổn
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5, // Điều chỉnh để card không bị kéo quá dài
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return MovieCard(
              title: 'Sabrina - Phần $index',
              imageUrl: 'assets/image/image.jpg',
            );
          },
        ),
      ),
    );
  }
}

// --- WIDGET MOVIECARD NẰM CHUNG FILE ---
class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Phần thân chính của Card
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Ảnh nền phim
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
              ),

              // Lớp Gradient phủ đen ở dưới để nổi bật Text
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Tiêu đề phim ở góc dưới
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}