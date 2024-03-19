import 'package:flutter/material.dart';
import 'package:ytp_new/config.dart';
import 'package:ytp_new/model/persistence.dart';
import 'package:ytp_new/model/settings/settings.dart';
import 'package:ytp_new/model/settings/theme_creator.dart';
import 'package:ytp_new/provider/playlist_storage_provider.dart';
import 'package:ytp_new/service/codec_service.dart';
import 'package:ytp_new/view/widget/app_navigator.dart';

class SettingsProvider extends ChangeNotifier {
  /// The current [ThemeData] of the app
  ThemeData get themeData =>
      theme == ThemeSetting.dark ? ThemeData.dark() : ThemeData.light();

  /// The current [ThemeSetting] of the app
  ThemeSetting get theme => Settings.theme;
  set theme(final ThemeSetting setting) {
    Settings.theme = setting;
    ThemeCreator.createColorScheme().whenComplete(() => notifyListeners());

    Persistence.saveSettings();
  }

  /// The current [SplitSetting] of the app
  SplitSetting get splitMode => Settings.splitMode;
  set splitMode(final SplitSetting setting) {
    Settings.splitMode = setting;
    notifyListeners();

    Persistence.saveSettings();
  }

  /// The current [ColorSchemeSetting] of the app
  ColorSchemeSetting get colorScheme => Settings.colorScheme;
  set colorScheme(final ColorSchemeSetting colorScheme) {
    Settings.colorScheme = colorScheme;
    ThemeCreator.createColorScheme().then((value) => notifyListeners());

    Persistence.saveSettings();
  }

  /// Whether to hide the `- Topic` suffix from authors
  bool get hideTopic => Settings.hideTopic;
  set hideTopic(final bool hideTopic) {
    Settings.hideTopic = hideTopic;
    notifyListeners();

    Persistence.saveSettings();
  }

  /// Whether to allow reordering of [Playlist]s
  bool get canReorder => Settings.canReorder;
  set canReorder(final bool canReorder) {
    Settings.canReorder = canReorder;
    notifyListeners();

    //? save changed order on finish
    if (!canReorder) {
      Persistence.savePlaylists();
    }
  }

  /// Exports the app data
  Future export() async => CodecService.export();

  bool _managingAppData = false;

  /// Whether the app is currently managing data
  bool get managingAppData => _managingAppData;
  set managingAppData(final bool value) {
    _managingAppData = value;
    notifyListeners();
  }

  /// Imports the app data
  Future import() async {
    managingAppData = true;
    final imported = await CodecService.import();
    if (imported == null) {
      managingAppData = false;
      return;
    }

    AppNavigator.tryPopRight();

    theme = imported[AppConfig.settingsThemeKey];
    colorScheme = imported[AppConfig.settingsSchemeKey];
    splitMode = imported[AppConfig.settingsSplitKey];
    hideTopic = imported[AppConfig.settingsHideTopicKey];

    PlaylistStorageProvider().replace(imported[AppConfig.playlistsKey]);
    managingAppData = false;
  }

  //_ Singleton
  static final _provider = SettingsProvider._();
  factory SettingsProvider() => _provider;
  SettingsProvider._();
}
