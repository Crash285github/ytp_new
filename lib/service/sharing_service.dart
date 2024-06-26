import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'package:ytp_new/config.dart';
import 'package:ytp_new/persistence/persistence.dart';
import 'package:ytp_new/provider/fetching_provider.dart';
import 'package:ytp_new/provider/playlist_storage_provider.dart';
import 'package:ytp_new/service/popup_service.dart';
import 'package:ytp_new/service/youtube_service.dart';

class SharingService {
  static void receive() {
    ReceiveSharingIntent.instance.getMediaStream().listen((event) async {
      if (event.isNotEmpty) {
        FetchingProvider().incrementDownload();
        await _handleIntent(event.first.path);
        FetchingProvider().decrementDownload();
      }
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      if (value.isNotEmpty) {
        FetchingProvider().incrementDownload();
        await _handleIntent(value.first.path);
        FetchingProvider().decrementDownload();
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  static Future<void> _handleIntent(final String text) async {
    final String? id = yt.PlaylistId.parsePlaylistId(text);

    if (id == null) {
      PopupService.showError(
        context: AppConfig.mainNavigatorKey.currentContext!,
        message: "Playlist id couldn't be parsed.",
      );
      return;
    }

    if (PlaylistStorage.playlists
        .where((final playlist) => playlist.id == id)
        .isNotEmpty) {
      PopupService.showError(
        context: AppConfig.mainNavigatorKey.currentContext!,
        message: "Playlist already in the app.",
      );
      return;
    }

    final fetched = await YoutubeService.fetch(id);

    //? private playlist shared
    if (fetched.length == 0) {
      PopupService.showError(
        context: AppConfig.mainNavigatorKey.currentContext!,
        message: "Private Playlist can't be fetched.",
      );
      return;
    }

    PlaylistStorageProvider().add(fetched);
  }
}
