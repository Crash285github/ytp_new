import 'package:flutter/material.dart';
import 'package:ytp_new/extensions/extensions.dart';
import 'package:ytp_new/provider/playlist_storage_provider.dart';
import 'package:ytp_new/view/widget/adaptive_secondary.dart';

class PlannedItem extends StatelessWidget {
  final String playlistId;
  final String text;
  const PlannedItem({
    super.key,
    required this.playlistId,
    required this.text,
  });

  Playlist get playlist => PlaylistStorageProvider().fromId(playlistId)!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 2.0, bottom: 2.0),
      child: Material(
        type: MaterialType.transparency,
        child: AdaptiveSecondaryInkWell(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          overlayColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary.withOpacity(.3),
          ),
          onSecondary: (details) => details.showContextMenu(
            context: context,
            items: [
              PopupMenuItem(
                onTap: () => text.copyToClipboard(),
                child: const Text("Copy"),
              ),
              PopupMenuItem(
                onTap: () => PlaylistStorageProvider()
                    .update(() => playlist.planned.remove(text)),
                child: const Text("Remove"),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
