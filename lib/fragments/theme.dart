import 'dart:math';

import 'dart:ui' as ui;

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

  const ItemCard({
    super.key,
    required this.info,
    required this.child,
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
    List<Color?> primaryColors = [
      null,
      defaultPrimaryColor,
      Colors.lightBlue,
      Colors.yellowAccent,
      Color(0xffbbc9cc),
      Color(0xffabd397),
      Color(0xffd8c0c3),
      Color(0xff665390),
    ];
    return ItemCard(
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
                  SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: ColorSchemeBox(
                      isSelected: color?.toARGB32() == primaryColor,
                      primaryColor: color,
                      onPressed: () {
                        ref.read(themeSettingProvider.notifier).updateState(
                              (state) => state.copyWith(
                                primaryColor: color?.toARGB32(),
                              ),
                            );
                      },
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
          onPressed: () {},
          child: Text(appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {},
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
