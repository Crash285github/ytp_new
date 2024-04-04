part of '../preferences_drawer.dart';

class _SelectSplit extends StatelessWidget {
  const _SelectSplit();

  Future _select(BuildContext context, Offset offset) async {
    final selected = await offset.showContextMenu<SplitSetting>(
      context: context,
      items: [
        ...SplitSetting.values.map(
          (final mode) => PopupMenuItem(
            value: mode,
            child: Text(mode.titleCase),
          ),
        ),
      ],
    );

    if (selected != null) {
      SettingsProvider().splitMode = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.select<SettingsProvider, String>(
      (final settings) => settings.splitMode.titleCase,
    );

    return _SettingTemplate(
      onTapUp: (details) => _select(context, details.globalPosition),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              RotatedBox(quarterTurns: 1, child: Icon(Icons.splitscreen)),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Split view'),
              ),
            ],
          ),
          Text(mode)
        ],
      ),
    );
  }
}