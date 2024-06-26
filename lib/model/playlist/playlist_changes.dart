part of playlist;

/// A [Playlist]s changes
mixin _PlaylistChanges {
  /// The additions made to this [Playlist]
  final List<VideoChange> additions = [];

  /// The removals made to this [Playlist]
  final List<VideoChange> removals = [];

  /// All the changes made to this [Playlist]
  ///
  /// Sorted by title
  List<VideoChange> get changes => (additions + removals)
    ..sort(
      (final fst, final snd) => fst.title.compareTo(snd.title),
    );
}
