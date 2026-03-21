import 'package:clone_netflix/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/Genres.dart';
import '../../services/genre_service.dart';
import '../../services/movie_service.dart';
import '../component/footer.dart';
import '../discovery/movie_detail.dart';
import 'filtered_movies_screen.dart';
void main() {
  runApp(const ProviderScope(child: NetflixCloneApp()));
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix Mobile',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080404),
        fontFamily: 'SplineSans',
      ),
      home: const HomeScreen(),

    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFFE70814);
  static const Color backgroundDark = Color(0xFF080404);

  static const String profileImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBFxaf8UCO6-YGW7mO36HAMnpgiW6ALwTbBF-SMKFEDDjTSxW3wQH5LZqyebttvWtwPnFdSu3K334XVvvOUbsOqg-OUGSEuTWgi2FZt9O-9kc8YqZCCtxLF9_MQmXxTRCrUFDKk_etGx-BLO3meAVWI2ZWNfJD_u9XgmfAIFxcQ49AjAkrvVua9NcYystpsAX6GChMwb4ctKOBuohOPpaL4tex6KyUsY0BwIuS7bdb8JiWsdRtGWN9W_AneAn9dsmkpWlSAirItokDr';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingAsync = ref.watch(nowPlayingMoviesProvider);
    final popularAsync = ref.watch(popularMoviesProvider);
    final upcomingAsync = ref.watch(upcomingMoviesProvider);
    final topRatedAsync = ref.watch(topRatedMoviesProvider);
    return Scaffold(
      body: Stack(
        children: [
          nowPlayingAsync.when(
            loading: () => const _HomeLoadingView(),
            error: (error, stack) => _HomeErrorView(message: error.toString()),
            data: (nowPlayingMovies) {
              if (nowPlayingMovies.isEmpty) {
                return const _HomeErrorView(
                  message: 'Không có dữ liệu phim đang chiếu',
                );
              }

              final heroMovie = nowPlayingMovies.first;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 92),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                        _buildHeroSection(context, heroMovie),
                        const SizedBox(height: 20),

                        _AsyncMovieSection(
                          title: 'Now Playing',
                          asyncMovies: nowPlayingAsync,
                          onMovieTap: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        _AsyncMovieSection(
                          title: 'Popular on Netflix',
                          asyncMovies: popularAsync,
                          highlightedIndex: 1,
                          onMovieTap: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        topRatedAsync.when(
                          loading: () => const _SectionLoadingPlaceholder(
                            title: 'Top 10 in your country',
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (movies) => _buildTop10Section(movies),
                        ),

                        const SizedBox(height: 28),

                        _AsyncMovieSection(
                          title: 'Upcoming',
                          asyncMovies: upcomingAsync,
                          onMovieTap: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          _buildTopOverlay(),
        ],
      ),
      bottomNavigationBar: const AppFooter(currentIndex: 0),
    );
  }

  Widget _buildTopOverlay() {
    return Container(
      padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromRGBO(0, 0, 0, 0.82), Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const _NetflixLogo(),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _TopMenuItem('TV Shows'),
                  SizedBox(width: 28),
                  _TopMenuItem('Movies'),
                  SizedBox(width: 28),
                  _CategoryMenuItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Movie movie) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _MovieBackdropImage(movie: movie),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(8, 4, 4, 0),
                  Color.fromRGBO(8, 4, 4, 0.82),
                  Color(0xFF080404),
                ],
                stops: [0.0, 0.45, 0.78, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 38,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                _buildMetaRow(movie),
                const SizedBox(height: 18),
                Text(
                  movie.overview.isEmpty
                      ? 'No overview available.'
                      : movie.overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        label: 'Play',
                        icon: Icons.play_arrow,
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
                        label: 'My List',
                        icon: Icons.add,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(Movie movie) {
    final tags = <String>[
      if (movie.releaseDate.isNotEmpty) movie.releaseDate,
      if (movie.voteAverage > 0) '⭐ ${movie.voteAverage.toStringAsFixed(1)}',
      if (movie.originalLanguage.isNotEmpty)
        movie.originalLanguage.toUpperCase(),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 0,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          _GenreText(tags[i]),
          if (i != tags.length - 1) const _GenreDot(),
        ],
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        color: isPrimary ? Colors.black : Colors.white,
        size: 22,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor:
        isPrimary ? Colors.white : Colors.white.withOpacity(0.16),
        foregroundColor: isPrimary ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildTop10Section(List<Movie> movies) {
    final topMovies = movies.take(10).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 10 in your country',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              itemCount: topMovies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 26),
              itemBuilder: (context, index) {
                final movie = topMovies[index];

                return SizedBox(
                  width: 140,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: -24,
                          bottom: -4,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 108,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _MoviePosterImage(
                            movie: movie,
                            width: 120,
                            height: 180,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class _AsyncMovieSection extends StatelessWidget {
  final String title;
  final AsyncValue<List<Movie>> asyncMovies;
  final int? highlightedIndex;
  final ValueChanged<Movie> onMovieTap;

  const _AsyncMovieSection({
    required this.title,
    required this.asyncMovies,
    required this.onMovieTap,
    this.highlightedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return asyncMovies.when(
      loading: () => _SectionLoadingPlaceholder(title: title),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Lỗi tải $title',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      data: (movies) => _MoviePosterSection(
        title: title,
        movies: movies,
        highlightedIndex: highlightedIndex,
        onMovieTap: onMovieTap,
      ),
    );
  }
}
class _MoviePosterSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final int? highlightedIndex;
  final ValueChanged<Movie> onMovieTap;

  const _MoviePosterSection({
    required this.title,
    required this.movies,
    required this.onMovieTap,
    this.highlightedIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final movie = movies[index];
                final isHighlighted = highlightedIndex == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onMovieTap(movie),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isHighlighted
                          ? Border.all(
                        color: const Color(0xFFE70814).withOpacity(0.4),
                        width: 2,
                      )
                          : null,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _MoviePosterImage(movie: movie),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _MoviePosterImage extends StatelessWidget {
  final Movie movie;
  final double? width;
  final double? height;

  const _MoviePosterImage({
    required this.movie,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (movie.posterPath.isEmpty) {
      return _ImageFallback(width: width, height: height, iconSize: 30);
    }

    return Image.network(
      movie.fullPosterPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          _ImageFallback(width: width, height: height, iconSize: 30),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _ImageLoading(width: width, height: height);
      },
    );
  }
}

class _MovieBackdropImage extends StatelessWidget {
  final Movie movie;

  const _MovieBackdropImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.backdropPath.isEmpty) {
      return const _ImageFallback(iconSize: 52);
    }

    return Image.network(
      movie.fullBackdropPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _ImageFallback(iconSize: 52),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _ImageLoading();
      },
    );
  }
}

class _ImageLoading extends StatelessWidget {
  final double? width;
  final double? height;

  const _ImageLoading({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF141414),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final double? width;
  final double? height;
  final double iconSize;

  const _ImageFallback({
    this.width,
    this.height,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF1A1A1A),
      alignment: Alignment.center,
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.white38,
        size: iconSize,
      ),
    );
  }
}

class _SectionLoadingPlaceholder extends StatelessWidget {
  final String title;

  const _SectionLoadingPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, __) => Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 120),
              _HeroLoadingPlaceholder(),
              SizedBox(height: 28),
              _SectionLoadingPlaceholder(title: 'Now Playing'),
              SizedBox(height: 28),
              _SectionLoadingPlaceholder(title: 'Popular on Netflix'),
              SizedBox(height: 28),
              _SectionLoadingPlaceholder(title: 'Upcoming'),
              SizedBox(height: 120),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroLoadingPlaceholder extends StatelessWidget {
  const _HeroLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A1A), Color(0xFF080404)],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;

  const _HomeErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'Không thể tải dữ liệu\n$message',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TopMenuItem extends StatelessWidget {
  final String title;

  const _TopMenuItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

class _CategoryMenuItem extends StatelessWidget {
  const _CategoryMenuItem();

  void _showCategoryPopup(BuildContext context) async {
    final result = await showGeneralDialog(
      context: context,
      barrierLabel: 'Categories',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.72),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => const _BeautifulCategoryDialog(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: child,
          ),
        );
      },
    );

    if (result != null) {
      final data = result as Map<String, dynamic>;
      final genreIds = List<int>.from(data['genreIds'] as List);
      final isMovie = data['isMovie'] as bool;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FilteredMoviesScreen(
            genreIds: genreIds,
            isMovie: isMovie,
            title: isMovie ? 'Filtered Movies' : 'Filtered TV Shows',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showCategoryPopup(context),
      child: Row(
        children: const [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 2),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _BeautifulCategoryDialog extends ConsumerStatefulWidget {
  const _BeautifulCategoryDialog();

  @override
  ConsumerState<_BeautifulCategoryDialog> createState() =>
      _BeautifulCategoryDialogState();
}

class _BeautifulCategoryDialogState
    extends ConsumerState<_BeautifulCategoryDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final Set<int> selectedMovieGenreIds = {};
  final Set<int> selectedTvGenreIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onGenreTap(Genre genre, bool isMovie) {
    setState(() {
      final targetSet = isMovie ? selectedMovieGenreIds : selectedTvGenreIds;

      if (targetSet.contains(genre.id)) {
        targetSet.remove(genre.id);
      } else {
        targetSet.add(genre.id);
      }
    });
  }

  void _onSearchPressed() {
    final isMovieTab = _tabController.index == 0;
    final selectedIds =
    isMovieTab ? selectedMovieGenreIds.toList() : selectedTvGenreIds.toList();

    if (selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text('Vui lòng chọn ít nhất 1 category'),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'genreIds': selectedIds,
      'isMovie': isMovieTab,
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieGenresAsync = ref.watch(movieGenresProvider);
    final tvGenresAsync = ref.watch(tvGenresProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.82,
            decoration: const BoxDecoration(
              color: Color(0xFF0B0B0F),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 24,
                  offset: Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Browse by Category',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17171C),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFE50914),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Movies'),
                        Tab(text: 'TV Shows'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _GenreTabView(
                        title: 'Movie Genres',
                        subtitle: 'Choose one or more genres to discover movies',
                        asyncGenres: movieGenresAsync,
                        selectedGenreIds: selectedMovieGenreIds,
                        onGenreTap: (genre) => _onGenreTap(genre, true),
                      ),
                      _GenreTabView(
                        title: 'TV Show Genres',
                        subtitle: 'Choose one or more genres to discover series',
                        asyncGenres: tvGenresAsync,
                        selectedGenreIds: selectedTvGenreIds,
                        onGenreTap: (genre) => _onGenreTap(genre, false),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _onSearchPressed,
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50914),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _GenreTabView extends StatelessWidget {
  final String title;
  final String subtitle;
  final AsyncValue<List<Genre>> asyncGenres;
  final Set<int> selectedGenreIds;
  final ValueChanged<Genre> onGenreTap;

  const _GenreTabView({
    required this.title,
    required this.subtitle,
    required this.asyncGenres,
    required this.selectedGenreIds,
    required this.onGenreTap,
  });

  @override
  Widget build(BuildContext context) {
    return asyncGenres.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE50914),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Không thể tải category\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
      ),
      data: (genres) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: genres.map((genre) {
                  final isSelected = selectedGenreIds.contains(genre.id);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onGenreTap(genre),
                        borderRadius: BorderRadius.circular(22),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: isSelected
                                ? const Color(0xFFE50914)
                                : const Color(0xFF1A1A20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE50914)
                                  : Colors.white10,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: const Color(0xFFE50914)
                                    .withOpacity(0.28),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                genre.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
class _GenreText extends StatelessWidget {
  final String text;

  const _GenreText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFFCBD5E1),
      ),
    );
  }
}

class _GenreDot extends StatelessWidget {
  const _GenreDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF64748B),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white38;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _NetflixLogo extends StatelessWidget {
  const _NetflixLogo();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'N',
      style: TextStyle(
        color: Color(0xFFE70814),
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: -2,
      ),
    );
  }
}