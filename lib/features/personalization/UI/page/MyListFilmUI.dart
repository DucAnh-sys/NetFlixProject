import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/personalization/UI/page/PersonalizationUI.dart';
import 'package:project/features/personalization/model/MyListFilm.dart';
import 'package:project/models/movie.dart';
import 'package:project/services/movie_provider.dart';
class MyListScreen extends ConsumerWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final moviesAsync = ref.watch(popularMoviesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF181111),

      appBar: AppBar(
        backgroundColor: const Color(0xFF181111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Danh sách của tôi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: moviesAsync.when(

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (err, stack) => Center(
          child: Text(
            "Lỗi: $err",
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (movies) {

          return GridView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: movies.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2 / 3,
            ),

            itemBuilder: (context, index) {

              final movie = movies[index];

              return MovieCard(movie: movie);
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181111),
        selectedItemColor: const Color(0xFFE60A15),
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

  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Stack(
            children: [

              Image.network(
                movie.fullPosterPath,
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
                  movie.title,
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