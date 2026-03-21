// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$popularMoviesHash() => r'3f8fe87ee5ff2006f8e097df4a8a2ec8db2b1f35';

/// See also [popularMovies].
@ProviderFor(popularMovies)
final popularMoviesProvider = AutoDisposeFutureProvider<List<Movie>>.internal(
  popularMovies,
  name: r'popularMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularMoviesRef = AutoDisposeFutureProviderRef<List<Movie>>;
String _$popularTvShowHash() => r'7f9c13910b7920d027060b8eabfa6643d3ac874b';

/// See also [popularTvShow].
@ProviderFor(popularTvShow)
final popularTvShowProvider = AutoDisposeFutureProvider<List<Movie>>.internal(
  popularTvShow,
  name: r'popularTvShowProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularTvShowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularTvShowRef = AutoDisposeFutureProviderRef<List<Movie>>;
String _$movieDetailHash() => r'f240de8024453bcf6f21b4766ae269a49b93db16';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [movieDetail].
@ProviderFor(movieDetail)
const movieDetailProvider = MovieDetailFamily();

/// See also [movieDetail].
class MovieDetailFamily extends Family<AsyncValue<Movie>> {
  /// See also [movieDetail].
  const MovieDetailFamily();

  /// See also [movieDetail].
  MovieDetailProvider call(Movie movie) {
    return MovieDetailProvider(movie);
  }

  @override
  MovieDetailProvider getProviderOverride(
    covariant MovieDetailProvider provider,
  ) {
    return call(provider.movie);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'movieDetailProvider';
}

/// See also [movieDetail].
class MovieDetailProvider extends AutoDisposeFutureProvider<Movie> {
  /// See also [movieDetail].
  MovieDetailProvider(Movie movie)
    : this._internal(
        (ref) => movieDetail(ref as MovieDetailRef, movie),
        from: movieDetailProvider,
        name: r'movieDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$movieDetailHash,
        dependencies: MovieDetailFamily._dependencies,
        allTransitiveDependencies: MovieDetailFamily._allTransitiveDependencies,
        movie: movie,
      );

  MovieDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movie,
  }) : super.internal();

  final Movie movie;

  @override
  Override overrideWith(
    FutureOr<Movie> Function(MovieDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MovieDetailProvider._internal(
        (ref) => create(ref as MovieDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movie: movie,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Movie> createElement() {
    return _MovieDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailProvider && other.movie == movie;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movie.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MovieDetailRef on AutoDisposeFutureProviderRef<Movie> {
  /// The parameter `movie` of this provider.
  Movie get movie;
}

class _MovieDetailProviderElement
    extends AutoDisposeFutureProviderElement<Movie>
    with MovieDetailRef {
  _MovieDetailProviderElement(super.provider);

  @override
  Movie get movie => (origin as MovieDetailProvider).movie;
}

String _$movieActorsHash() => r'd17dc47188d82563ce5023aa2aa7ddab6ffc2b03';

/// See also [movieActors].
@ProviderFor(movieActors)
const movieActorsProvider = MovieActorsFamily();

/// See also [movieActors].
class MovieActorsFamily extends Family<AsyncValue<List<Actor>>> {
  /// See also [movieActors].
  const MovieActorsFamily();

  /// See also [movieActors].
  MovieActorsProvider call(Movie movie) {
    return MovieActorsProvider(movie);
  }

  @override
  MovieActorsProvider getProviderOverride(
    covariant MovieActorsProvider provider,
  ) {
    return call(provider.movie);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'movieActorsProvider';
}

/// See also [movieActors].
class MovieActorsProvider extends AutoDisposeFutureProvider<List<Actor>> {
  /// See also [movieActors].
  MovieActorsProvider(Movie movie)
    : this._internal(
        (ref) => movieActors(ref as MovieActorsRef, movie),
        from: movieActorsProvider,
        name: r'movieActorsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$movieActorsHash,
        dependencies: MovieActorsFamily._dependencies,
        allTransitiveDependencies: MovieActorsFamily._allTransitiveDependencies,
        movie: movie,
      );

  MovieActorsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movie,
  }) : super.internal();

  final Movie movie;

  @override
  Override overrideWith(
    FutureOr<List<Actor>> Function(MovieActorsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MovieActorsProvider._internal(
        (ref) => create(ref as MovieActorsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movie: movie,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Actor>> createElement() {
    return _MovieActorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieActorsProvider && other.movie == movie;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movie.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MovieActorsRef on AutoDisposeFutureProviderRef<List<Actor>> {
  /// The parameter `movie` of this provider.
  Movie get movie;
}

class _MovieActorsProviderElement
    extends AutoDisposeFutureProviderElement<List<Actor>>
    with MovieActorsRef {
  _MovieActorsProviderElement(super.provider);

  @override
  Movie get movie => (origin as MovieActorsProvider).movie;
}

String _$movieTrailerHash() => r'521e1d4c4ebf09d573b6fa21870543271da4c9ee';

/// See also [movieTrailer].
@ProviderFor(movieTrailer)
const movieTrailerProvider = MovieTrailerFamily();

/// See also [movieTrailer].
class MovieTrailerFamily extends Family<AsyncValue<String?>> {
  /// See also [movieTrailer].
  const MovieTrailerFamily();

  /// See also [movieTrailer].
  MovieTrailerProvider call(int movieId) {
    return MovieTrailerProvider(movieId);
  }

  @override
  MovieTrailerProvider getProviderOverride(
    covariant MovieTrailerProvider provider,
  ) {
    return call(provider.movieId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'movieTrailerProvider';
}

/// See also [movieTrailer].
class MovieTrailerProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [movieTrailer].
  MovieTrailerProvider(int movieId)
    : this._internal(
        (ref) => movieTrailer(ref as MovieTrailerRef, movieId),
        from: movieTrailerProvider,
        name: r'movieTrailerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$movieTrailerHash,
        dependencies: MovieTrailerFamily._dependencies,
        allTransitiveDependencies:
            MovieTrailerFamily._allTransitiveDependencies,
        movieId: movieId,
      );

  MovieTrailerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
  }) : super.internal();

  final int movieId;

  @override
  Override overrideWith(
    FutureOr<String?> Function(MovieTrailerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MovieTrailerProvider._internal(
        (ref) => create(ref as MovieTrailerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _MovieTrailerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieTrailerProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MovieTrailerRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _MovieTrailerProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with MovieTrailerRef {
  _MovieTrailerProviderElement(super.provider);

  @override
  int get movieId => (origin as MovieTrailerProvider).movieId;
}

String _$similarMovieHash() => r'aa5d9966219d9da532fdb585d5af2e8fdac07655';

/// See also [similarMovie].
@ProviderFor(similarMovie)
const similarMovieProvider = SimilarMovieFamily();

/// See also [similarMovie].
class SimilarMovieFamily extends Family<AsyncValue<List<Movie>>> {
  /// See also [similarMovie].
  const SimilarMovieFamily();

  /// See also [similarMovie].
  SimilarMovieProvider call(Movie movie) {
    return SimilarMovieProvider(movie);
  }

  @override
  SimilarMovieProvider getProviderOverride(
    covariant SimilarMovieProvider provider,
  ) {
    return call(provider.movie);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarMovieProvider';
}

/// See also [similarMovie].
class SimilarMovieProvider extends AutoDisposeFutureProvider<List<Movie>> {
  /// See also [similarMovie].
  SimilarMovieProvider(Movie movie)
    : this._internal(
        (ref) => similarMovie(ref as SimilarMovieRef, movie),
        from: similarMovieProvider,
        name: r'similarMovieProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$similarMovieHash,
        dependencies: SimilarMovieFamily._dependencies,
        allTransitiveDependencies:
            SimilarMovieFamily._allTransitiveDependencies,
        movie: movie,
      );

  SimilarMovieProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movie,
  }) : super.internal();

  final Movie movie;

  @override
  Override overrideWith(
    FutureOr<List<Movie>> Function(SimilarMovieRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SimilarMovieProvider._internal(
        (ref) => create(ref as SimilarMovieRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movie: movie,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Movie>> createElement() {
    return _SimilarMovieProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarMovieProvider && other.movie == movie;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movie.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimilarMovieRef on AutoDisposeFutureProviderRef<List<Movie>> {
  /// The parameter `movie` of this provider.
  Movie get movie;
}

class _SimilarMovieProviderElement
    extends AutoDisposeFutureProviderElement<List<Movie>>
    with SimilarMovieRef {
  _SimilarMovieProviderElement(super.provider);

  @override
  Movie get movie => (origin as SimilarMovieProvider).movie;
}

String _$listEpisodeHash() => r'da4469fafc63033dafcb06b82f1e8f5037dfbbe9';

/// See also [listEpisode].
@ProviderFor(listEpisode)
const listEpisodeProvider = ListEpisodeFamily();

/// See also [listEpisode].
class ListEpisodeFamily extends Family<AsyncValue<List<Episode>>> {
  /// See also [listEpisode].
  const ListEpisodeFamily();

  /// See also [listEpisode].
  ListEpisodeProvider call(int movieId, int seasonNumber) {
    return ListEpisodeProvider(movieId, seasonNumber);
  }

  @override
  ListEpisodeProvider getProviderOverride(
    covariant ListEpisodeProvider provider,
  ) {
    return call(provider.movieId, provider.seasonNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'listEpisodeProvider';
}

/// See also [listEpisode].
class ListEpisodeProvider extends AutoDisposeFutureProvider<List<Episode>> {
  /// See also [listEpisode].
  ListEpisodeProvider(int movieId, int seasonNumber)
    : this._internal(
        (ref) => listEpisode(ref as ListEpisodeRef, movieId, seasonNumber),
        from: listEpisodeProvider,
        name: r'listEpisodeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$listEpisodeHash,
        dependencies: ListEpisodeFamily._dependencies,
        allTransitiveDependencies: ListEpisodeFamily._allTransitiveDependencies,
        movieId: movieId,
        seasonNumber: seasonNumber,
      );

  ListEpisodeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
    required this.seasonNumber,
  }) : super.internal();

  final int movieId;
  final int seasonNumber;

  @override
  Override overrideWith(
    FutureOr<List<Episode>> Function(ListEpisodeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ListEpisodeProvider._internal(
        (ref) => create(ref as ListEpisodeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
        seasonNumber: seasonNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Episode>> createElement() {
    return _ListEpisodeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListEpisodeProvider &&
        other.movieId == movieId &&
        other.seasonNumber == seasonNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);
    hash = _SystemHash.combine(hash, seasonNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ListEpisodeRef on AutoDisposeFutureProviderRef<List<Episode>> {
  /// The parameter `movieId` of this provider.
  int get movieId;

  /// The parameter `seasonNumber` of this provider.
  int get seasonNumber;
}

class _ListEpisodeProviderElement
    extends AutoDisposeFutureProviderElement<List<Episode>>
    with ListEpisodeRef {
  _ListEpisodeProviderElement(super.provider);

  @override
  int get movieId => (origin as ListEpisodeProvider).movieId;
  @override
  int get seasonNumber => (origin as ListEpisodeProvider).seasonNumber;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
