import 'package:clone_netflix/models/movie.dart';
import 'package:clone_netflix/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../discovery/movie_detail.dart';

enum FilterSortType {
  defaultOrder,
  ratingDesc,
  ratingAsc,
  titleAZ,
  titleZA,
  newestRelease,
  oldestRelease,
}

class FilteredMoviesScreen extends ConsumerStatefulWidget {
  final List<int> genreIds;
  final bool isMovie;
  final String? title;

  const FilteredMoviesScreen({
    super.key,
    required this.genreIds,
    required this.isMovie,
    this.title,
  });

  @override
  ConsumerState<FilteredMoviesScreen> createState() =>
      _FilteredMoviesScreenState();
}

class _FilteredMoviesScreenState extends ConsumerState<FilteredMoviesScreen> {
  FilterSortType selectedSort = FilterSortType.defaultOrder;

  @override
  Widget build(BuildContext context) {
    final asyncMovies = ref.watch(
      filteredMoviesProvider(
        FilteredMoviesParams(
          genreIds: widget.genreIds,
          isMovie: widget.isMovie,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF080404),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080404),
        elevation: 0,
        title: Text(
          widget.title ??
              (widget.isMovie ? 'Filtered Movies' : 'Filtered TV Shows'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: asyncMovies.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE50914),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Không thể tải danh sách phim\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              data: (movies) {
                final sortedMovies = _applySort(movies);

                if (sortedMovies.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Không có phim phù hợp với category đã chọn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  itemCount: sortedMovies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.52,
                  ),
                  itemBuilder: (context, index) {
                    final movie = sortedMovies[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailScreen(movieId: movie.id,type: movie.mediaType),
                          ),
                        );
                      },
                      child: _MovieGridCard(movie: movie),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSortDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF17171C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FilterSortType>(
          value: selectedSort,
          dropdownColor: const Color(0xFF17171C),
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedSort = value;
            });
          },
          items: const [
            DropdownMenuItem(
              value: FilterSortType.defaultOrder,
              child: Text('Mặc định'),
            ),
            DropdownMenuItem(
              value: FilterSortType.ratingDesc,
              child: Text('Rating cao → thấp'),
            ),
            DropdownMenuItem(
              value: FilterSortType.ratingAsc,
              child: Text('Rating thấp → cao'),
            ),
            DropdownMenuItem(
              value: FilterSortType.titleAZ,
              child: Text('Tên A-Z'),
            ),
            DropdownMenuItem(
              value: FilterSortType.titleZA,
              child: Text('Tên Z-A'),
            ),
            DropdownMenuItem(
              value: FilterSortType.newestRelease,
              child: Text('Mới nhất'),
            ),
            DropdownMenuItem(
              value: FilterSortType.oldestRelease,
              child: Text('Cũ nhất'),
            ),
          ],
        ),
      ),
    );
  }

  List<Movie> _applySort(List<Movie> movies) {
    final sorted = [...movies];

    switch (selectedSort) {
      case FilterSortType.defaultOrder:
        return sorted;

      case FilterSortType.ratingDesc:
        sorted.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        return sorted;

      case FilterSortType.ratingAsc:
        sorted.sort((a, b) => a.voteAverage.compareTo(b.voteAverage));
        return sorted;

      case FilterSortType.titleAZ:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        return sorted;

      case FilterSortType.titleZA:
        sorted.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        return sorted;

      case FilterSortType.newestRelease:
        sorted.sort((a, b) => _parseDate(b.releaseDate).compareTo(_parseDate(a.releaseDate)));
        return sorted;

      case FilterSortType.oldestRelease:
        sorted.sort((a, b) => _parseDate(a.releaseDate).compareTo(_parseDate(b.releaseDate)));
        return sorted;
    }
  }

  DateTime _parseDate(String date) {
    if (date.trim().isEmpty) {
      return DateTime(1900);
    }
    return DateTime.tryParse(date) ?? DateTime(1900);
  }
}

class _MovieGridCard extends StatelessWidget {
  final Movie movie;

  const _MovieGridCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: movie.posterPath.isNotEmpty
                ? Image.network(
              movie.fullPosterPath,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackPoster(),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _fallbackPoster(isLoading: true);
              },
            )
                : _fallbackPoster(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '⭐ ${movie.voteAverage.toStringAsFixed(1)}  •  ${movie.releaseDate.isEmpty ? 'N/A' : movie.releaseDate}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _fallbackPoster({bool isLoading = false}) {
    return Container(
      color: const Color(0xFF1A1A1A),
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : const Icon(
        Icons.movie_creation_outlined,
        color: Colors.white38,
        size: 30,
      ),
    );
  }
}