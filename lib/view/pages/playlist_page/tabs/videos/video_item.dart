import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytp_new/extensions/media_context.dart';
import 'package:ytp_new/extensions/offset_context_menu.dart';
import 'package:ytp_new/extensions/string_hide_topic.dart';
import 'package:ytp_new/extensions/text_style_with_opacity.dart';
import 'package:ytp_new/model/video/video.dart';
import 'package:ytp_new/provider/anchor_storage_provider.dart';
import 'package:ytp_new/provider/settings_provider.dart';
import 'package:ytp_new/view/widget/media_item_template.dart';
import 'package:ytp_new/view/widget/thumbnail.dart';

class VideoItem extends StatelessWidget {
  final Video video;
  final bool isFirst, isLast;
  const VideoItem({
    super.key,
    required this.video,
    this.isFirst = false,
    this.isLast = false,
  });

  BorderRadiusGeometry get borderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(isLast ? 16.0 : 4.0),
        bottomRight: Radius.circular(isLast ? 16.0 : 4.0),
        topLeft: Radius.circular(isFirst ? 16.0 : 4.0),
        topRight: Radius.circular(isFirst ? 16.0 : 4.0),
      );

  BorderRadius get thumbnailBorderRadius => BorderRadius.only(
        bottomLeft: Radius.circular(isLast ? 14.0 : 4.0),
        bottomRight: const Radius.circular(4.0),
        topLeft: Radius.circular(isFirst ? 14.0 : 4.0),
        topRight: const Radius.circular(4.0),
      );

  String get author =>
      SettingsProvider().hideTopic ? video.author.hideTopic() : video.author;

  String? get anchorText => video.anchor == null
      ? null
      : "${video.anchor!.position.name[0].toUpperCase()}"
          "${video.anchor!.index > 0 ? '+' : ''}"
          "${video.anchor!.index}";

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    context.watch<AnchorStorageProvider>();

    return MediaItem(
      secondaryAction: (offset) => offset.showContextMenu(
        context: context,
        items: [
          video.contextOpen,
          video.contextCopyTitle,
          video.contextCopyId,
          video.contextCopyLink,
          video.contextDownload,
          video.contextSetAnchor(context),
        ],
      ),
      borderRadius: borderRadius,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Thumbnail(
                  thumbnail: video.thumbnail,
                  borderRadius: thumbnailBorderRadius,
                  height: 80,
                  width: 80,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tooltip(
                          message: video.title,
                          child: Text(
                            video.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          author,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .withOpacity(.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (video.anchor != null && !video.anchorInPlace)
            Positioned(
              bottom: 0,
              right: 4,
              child: Icon(
                video.index > video.anchor!.index
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
        ],
      ),
    );
  }
}
