import 'package:flutter/material.dart';
import 'package:project/UI/page/PersonalizationUI.dart';
import 'package:project/model/MyListFilm.dart';
class MyListScreen extends StatelessWidget {

  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Mylistfilm> myFilms = Mylistfilm.listMyFilm();

    return Scaffold(
      backgroundColor: const Color(0xFF181111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MyNetflixScreen(),
              ),
            );
          },
        ),
        title: const Text(
          "Danh sách của tôi",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // TabItem(title: "Movies", isActive: true),
                // SizedBox(width: 24),
                // TabItem(title: "TV Shows"),
                // SizedBox(width: 24),
                // TabItem(title: "Downloaded"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: myFilms.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {

                  final movie = myFilms[index];

                  return MovieCard(
                    title: movie.title,
                    imageUrl: movie.image,
                  );
                },
              ),
            ),
          ),

          // Bottom Section
        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181111), // nền đen Netflix
        selectedItemColor: const Color(0xFFE60A15), // đỏ Netflix
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation),
            label: "Clip",
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

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

        Positioned(
          top: 6,
          right: 6,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
