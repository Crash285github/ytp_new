part of search_page;

class SearchResult extends StatefulWidget {
  final Playlist playlist;
  final bool isFirst, isLast;
  const SearchResult({
    super.key,
    required this.playlist,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool tapped = false;

  bool get downloaded =>
      PlaylistStorageProvider().playlists.contains(widget.playlist);

  BorderRadiusGeometry get borderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(widget.isLast ? 16.0 : 4.0),
        bottomRight: Radius.circular(widget.isLast ? 16.0 : 4.0),
        topLeft: Radius.circular(widget.isFirst ? 16.0 : 4.0),
        topRight: Radius.circular(widget.isFirst ? 16.0 : 4.0),
      );

  BorderRadius get thumbnailBorderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(widget.isLast ? 14.0 : 4.0),
        bottomRight: const Radius.circular(4.0),
        topLeft: Radius.circular(widget.isFirst ? 14.0 : 4.0),
        topRight: const Radius.circular(4.0),
      );

  @override
  Widget build(BuildContext context) {
    context.watch<PlaylistStorageProvider>();

    return AnimatedOpacity(
      duration: AppConfig.defaultAnimationDuration,
      opacity: tapped ? .5 : 1,
      child: MediaItem(
        borderRadius: borderRadius,
        primaryAction: tapped
            ? null
            : (_) async {
                setState(() => tapped = true);
                Playlist? pl;
                FetchingProvider().incrementDownload();
                try {
                  pl = await YoutubeService.fetch(
                    widget.playlist.id,
                  );

                  PlaylistStorageProvider().add(pl);
                } catch (_) {
                  if (mounted) {
                    setState(() => tapped =
                        PlaylistStorageProvider().playlists.contains(pl));
                  }
                }
                FetchingProvider().decrementDownload();
              },
        secondaryAction: (offset) => offset.showContextMenu(
          context: context,
          items: <PopupMenuEntry>[
            widget.playlist.contextOpen,
            const PopupMenuDivider(),
            widget.playlist.contextCopyTitle,
            widget.playlist.contextCopyId,
            widget.playlist.contextCopyLink,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 3.0, 8.0, 3.0),
          child: Row(
            children: [
              Thumbnail(
                thumbnail: widget.playlist.thumbnail,
                height: 80,
                width: 80,
                borderRadius: thumbnailBorderRadius,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tooltip(
                        message: widget.playlist.title,
                        child: Text(
                          widget.playlist.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        tapped && !downloaded
                            ? "Downloading..."
                            : downloaded
                                ? "Downloaded."
                                : "",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .withOpacity(.5),
                      )
                    ],
                  ),
                ),
              ),
              if (tapped && !downloaded)
                const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator()),
              if (tapped && downloaded)
                const Icon(
                  Icons.download_done,
                  color: Colors.green,
                )
            ],
          ),
        ),
      ),
    );
  }
}
