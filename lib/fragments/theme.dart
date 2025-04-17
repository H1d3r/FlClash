import 'dart:math';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/config.dart';
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
    // final previewCard = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: CommonCard(
    //     onPressed: () {},
    //     info: Info(
    //       label: appLocalizations.preview,
    //       iconData: Icons.looks,
    //     ),
    //     child: Container(
    //       height: 200,
    //     ),
    //   ),
    // );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // previewCard,
          const ThemeColorsBox(),
        ],
      ),
    );
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
      Colors.pinkAccent,
      Colors.lightBlue,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.purple,
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
            return SizedBox(
              width: constraints.maxWidth,
              height: 1000,
              child: Wrap(
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
                    )
                ],
              ),
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
