// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$popularMoviesHash() => r'bf7e32d9ed23a7d9dfb97df160fae7d265cae640';

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
String _$upcomingMoviesHash() => r'b483fcb507c9bb33db5d0eecbf390b7a5684d483';

/// See also [upcomingMovies].
@ProviderFor(upcomingMovies)
final upcomingMoviesProvider = AutoDisposeFutureProvider<List<Movie>>.internal(
  upcomingMovies,
  name: r'upcomingMoviesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingMoviesRef = AutoDisposeFutureProviderRef<List<Movie>>;
String _$nowPlayingMoviesHash() => r'ca0f92dfa8c010136fa75f3a6a4bb41c213c5960';

/// See also [nowPlayingMovies].
@ProviderFor(nowPlayingMovies)
final nowPlayingMoviesProvider =
    AutoDisposeFutureProvider<List<Movie>>.internal(
      nowPlayingMovies,
      name: r'nowPlayingMoviesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nowPlayingMoviesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NowPlayingMoviesRef = AutoDisposeFutureProviderRef<List<Movie>>;
String _$movieDetailHash() => r'83accdfbc14fa4531e89e34d175c3c09aacf0421';

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
  MovieDetailProvider call(int movieId) {
    return MovieDetailProvider(movieId);
  }

  @override
  MovieDetailProvider getProviderOverride(
    covariant MovieDetailProvider provider,
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
  String? get name => r'movieDetailProvider';
}

/// See also [movieDetail].
class MovieDetailProvider extends AutoDisposeFutureProvider<Movie> {
  /// See also [movieDetail].
  MovieDetailProvider(int movieId)
    : this._internal(
        (ref) => movieDetail(ref as MovieDetailRef, movieId),
        from: movieDetailProvider,
        name: r'movieDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$movieDetailHash,
        dependencies: MovieDetailFamily._dependencies,
        allTransitiveDependencies: MovieDetailFamily._allTransitiveDependencies,
        movieId: movieId,
      );

  MovieDetailProvider._internal(
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
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Movie> createElement() {
    return _MovieDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailProvider && other.movieId == movieId;
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
mixin MovieDetailRef on AutoDisposeFutureProviderRef<Movie> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _MovieDetailProviderElement
    extends AutoDisposeFutureProviderElement<Movie>
    with MovieDetailRef {
  _MovieDetailProviderElement(super.provider);

  @override
  int get movieId => (origin as MovieDetailProvider).movieId;
}

String _$movieActorsHash() => r'ff1f18808d8bb2703660b16b95583b1ec7628eb7';

/// See also [movieActors].
@ProviderFor(movieActors)
const movieActorsProvider = MovieActorsFamily();

/// See also [movieActors].
class MovieActorsFamily extends Family<AsyncValue<List<Actor>>> {
  /// See also [movieActors].
  const MovieActorsFamily();

  /// See also [movieActors].
  MovieActorsProvider call(int movieId) {
    return MovieActorsProvider(movieId);
  }

  @override
  MovieActorsProvider getProviderOverride(
    covariant MovieActorsProvider provider,
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
  String? get name => r'movieActorsProvider';
}

/// See also [movieActors].
class MovieActorsProvider extends AutoDisposeFutureProvider<List<Actor>> {
  /// See also [movieActors].
  MovieActorsProvider(int movieId)
    : this._internal(
        (ref) => movieActors(ref as MovieActorsRef, movieId),
        from: movieActorsProvider,
        name: r'movieActorsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$movieActorsHash,
        dependencies: MovieActorsFamily._dependencies,
        allTransitiveDependencies: MovieActorsFamily._allTransitiveDependencies,
        movieId: movieId,
      );

  MovieActorsProvider._internal(
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
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Actor>> createElement() {
    return _MovieActorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieActorsProvider && other.movieId == movieId;
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
mixin MovieActorsRef on AutoDisposeFutureProviderRef<List<Actor>> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _MovieActorsProviderElement
    extends AutoDisposeFutureProviderElement<List<Actor>>
    with MovieActorsRef {
  _MovieActorsProviderElement(super.provider);

  @override
  int get movieId => (origin as MovieActorsProvider).movieId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
