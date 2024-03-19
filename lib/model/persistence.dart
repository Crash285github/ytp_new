import 'package:shared_preferences/shared_preferences.dart';
import 'package:ytp_new/config.dart';
import 'package:ytp_new/model/anchor_storage.dart';
import 'package:ytp_new/model/playlist/playlist.dart';
import 'package:ytp_new/model/playlist_storage.dart';
import 'package:ytp_new/model/settings/settings.dart';
import 'package:ytp_new/model/video/anchor.dart';

/// Handles saving and loading local data
class Persistence {
  static late final SharedPreferences _prefs;

  /// Gets the instance of `SharedPreferences`
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  /// Saves [Settings] to [Persistence]
  static Future saveSettings() async => _prefs
    ..setInt(AppConfig.settingsThemeKey, Settings.theme.index)
    ..setInt(AppConfig.settingsSchemeKey, Settings.colorScheme.index)
    ..setInt(AppConfig.settingsSplitKey, Settings.splitMode.index)
    ..setBool(AppConfig.settingsHideTopicKey, Settings.hideTopic);

  /// Load & apply persisted settings
  ///
  /// Does not notify
  static void loadSettings() {
    final themeIndex = _prefs.getInt(AppConfig.settingsThemeKey);
    if (themeIndex != null) {
      Settings.theme = ThemeSetting.values[themeIndex];
    }

    final colorIndex = _prefs.getInt(AppConfig.settingsSchemeKey);
    if (colorIndex != null) {
      Settings.colorScheme = ColorSchemeSetting.values[colorIndex];
    }

    final splitIndex = _prefs.getInt(AppConfig.settingsSplitKey);
    if (splitIndex != null) {
      Settings.splitMode = SplitSetting.values[splitIndex];
    }

    final hideTopic = _prefs.getBool(AppConfig.settingsHideTopicKey);
    if (hideTopic != null) {
      Settings.hideTopic = hideTopic;
    }
  }

  /// Saves all [Playlist]s to [Persistence]
  static Future savePlaylists() async {
    _prefs.setStringList(
      AppConfig.playlistsKey,
      [
        ...PlaylistStorage.playlists.map(
          (final playlist) => playlist.toJson(),
        ),
      ],
    );
  }

  /// Loads playlists from [Persistence]
  ///
  /// Does not notify
  static void loadPlaylists() {
    final playlists = _prefs.getStringList(AppConfig.playlistsKey);
    if (playlists == null) return;

    PlaylistStorage.replace(
      [...playlists.map((final json) => Playlist.fromJson(json))],
    );
  }

  /// Saves all [Anchor]s to [Persistence]
  static Future saveAnchors() async {
    _prefs.setStringList(
      AppConfig.anchorsKey,
      [
        ...AnchorStorage.anchors.map(
          (final anchor) => anchor.toJson(),
        ),
      ],
    );
  }

  /// Loads [Anchor]s from [Persistence]
  ///
  /// Does not notify
  static void loadAnchors() {
    final anchors = _prefs.getStringList(AppConfig.anchorsKey);
    if (anchors == null) return;

    AnchorStorage.replace(
      [...anchors.map((final json) => Anchor.fromJson(json))],
    );
  }
}
