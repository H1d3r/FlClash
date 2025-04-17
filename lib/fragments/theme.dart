import 'dart:math';

import 'dart:ui' as ui;

import 'package:defer_pointer/defer_pointer.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeItem {
  final ThemeMode themeMode;
  final IconData iconData;
  final String label;

  const ThemeModeItem({
    required this.themeMode,
    required this.iconData,
    required this.label,
  });
}

class FontFamilyItem {
  final FontFamily fontFamily;
  final String label;

  const FontFamilyItem({
    required this.fontFamily,
    required this.label,
  });
}

class ThemeFragment extends StatelessWidget {
  const ThemeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: ThemeColorsBox());
  }
}

class ItemCard extends StatelessWidget {
  final Widget child;
  final Info info;
  final List<Widget> actions;

  const ItemCard({
    super.key,
    required this.info,
    required this.child,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          InfoHeader(
            info: info,
            actions: actions,
          ),
          child,
        ],
      ),
    );
  }
}

class ThemeColorsBox extends ConsumerStatefulWidget {
  const ThemeColorsBox({super.key});

  @override
  ConsumerState<ThemeColorsBox> createState() => _ThemeColorsBoxState();
}

class _ThemeColorsBoxState extends ConsumerState<ThemeColorsBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeModeItem(),
        _PrimaryColorItem(),
        _PrueBlackItem(),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }
}

class _ThemeModeItem extends ConsumerWidget {
  const _ThemeModeItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(themeSettingProvider.select((state) => state.themeMode));
    List<ThemeModeItem> themeModeItems = [
      ThemeModeItem(
        iconData: Icons.auto_mode,
        label: appLocalizations.auto,
        themeMode: ThemeMode.system,
      ),
      ThemeModeItem(
        iconData: Icons.light_mode,
        label: appLocalizations.light,
        themeMode: ThemeMode.light,
      ),
      ThemeModeItem(
        iconData: Icons.dark_mode,
        label: appLocalizations.dark,
        themeMode: ThemeMode.dark,
      ),
    ];
    return ItemCard(
      info: Info(
        label: appLocalizations.themeMode,
        iconData: Icons.brightness_high,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: themeModeItems.length,
          itemBuilder: (_, index) {
            final themeModeItem = themeModeItems[index];
            return CommonCard(
              isSelected: themeModeItem.themeMode == themeMode,
              onPressed: () {
                ref.read(themeSettingProvider.notifier).updateState(
                      (state) => state.copyWith(
                        themeMode: themeModeItem.themeMode,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Icon(themeModeItem.iconData),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        themeModeItem.label,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(
              width: 16,
            );
          },
        ),
      ),
    );
  }
}

class _PrimaryColorItem extends ConsumerWidget {
  const _PrimaryColorItem();

  int _calcColumns(double maxWidth) {
    return max((maxWidth / 96).ceil(), 3);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor =
        ref.watch(themeSettingProvider.select((state) => state.primaryColor));
    List<int?> primaryColors = [null, ...defaultPrimaryColors];
    return DeferredPointerHandler(
      child: ItemCard(
        actions: [
          FilledButton.tonal(
            onPressed: () {},
            child: Text(appLocalizations.edit),
          ),
        ],
        info: Info(
          label: appLocalizations.themeColor,
          iconData: Icons.palette,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final columns = _calcColumns(constraints.maxWidth);
              final itemWidth =
                  (constraints.maxWidth - (columns - 1) * 16) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final color in primaryColors)
                    Container(
                      clipBehavior: Clip.none,
                      width: itemWidth,
                      height: itemWidth,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ColorSchemeBox(
                            isSelected: color == primaryColor,
                            primaryColor: color != null ? Color(color) : null,
                            onPressed: () {
                              ref
                                  .read(themeSettingProvider.notifier)
                                  .updateState(
                                    (state) => state.copyWith(
                                      primaryColor: color,
                                    ),
                                  );
                            },
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: DeferPointer(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: IconButton.filled(
                                  iconSize: 20,
                                  padding: EdgeInsets.all(2),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.close,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                    width: itemWidth,
                    height: itemWidth,
                    padding: EdgeInsets.all(
                      4,
                    ),
                    child: IconButton.filledTonal(
                      onPressed: () {
                        globalState.showCommonDialog(
                          child: PaletteDialog(),
                        );
                      },
                      iconSize: 32,
                      icon: Icon(
                        color: context.colorScheme.primary,
                        Icons.add,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PrueBlackItem extends ConsumerWidget {
  const _PrueBlackItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prueBlack =
        ref.watch(themeSettingProvider.select((state) => state.pureBlack));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListItem.switchItem(
        leading: Icon(
          Icons.contrast,
        ),
        horizontalTitleGap: 12,
        title: Text(
          appLocalizations.pureBlackMode,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
        ),
        delegate: SwitchDelegate(
          value: prueBlack,
          onChanged: (value) {
            ref.read(themeSettingProvider.notifier).updateState(
                  (state) => state.copyWith(
                    pureBlack: value,
                  ),
                );
          },
        ),
      ),
    );
  }
}

class PaletteDialog extends StatefulWidget {
  const PaletteDialog({super.key});

  @override
  State<PaletteDialog> createState() => _PaletteDialogState();
}

class _PaletteDialogState extends State<PaletteDialog> {
  final _controller = ValueNotifier<ui.Color>(Colors.red);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "调色盘",
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(appLocalizations.confirm),
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 250,
            height: 250,
            child: Palette(
              controller: _controller,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, color, __) {
              return PrimaryColorBox(
                primaryColor: color,
                child: FilledButton(
                  onPressed: () {},
                  child: Text(
                    _controller.value.hex,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
