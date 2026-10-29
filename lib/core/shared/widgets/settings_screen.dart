// lib/featchers/settings/presentation/ui/settings_screen.dart

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:apex_restaurant/core/shared/widgets/change_language_dialog.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show Intl;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(title: S.current.settings, showBackButton: true),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final spacing = context.spacing;

            return SafeArea(
              child: ListView(
                padding: EdgeInsets.all(spacing.md),
                children: [
                  _SectionCard(
                    title: S.current.language,
                    child: _LanguageSelector(changeLanguage: changeLanguage),
                  ),
                  SizedBox(height: spacing.md),

                  _SectionCard(
                    title: S.current.appearance,
                    child: _ThemeModeSelector(state: state),
                  ),
                  SizedBox(height: spacing.md),

                  _SectionCard(
                    title: S.current.accentColor,
                    child: _AccentColorSelector(state: state),
                  ),
                  SizedBox(height: spacing.md),

                  _SectionCard(
                    title: S.current.fontSize,
                    child: _SegmentedSetting<AppFontScale>(
                      values: AppFontScale.values,
                      current: state.fontScale,
                      labelOf: (value) => value.label,
                      onSelected: (value) =>
                          context.read<SettingsCubit>().setFontScale(value),
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  _SectionCard(
                    title: S.current.iconSize,
                    child: _SegmentedSetting<AppIconScale>(
                      values: AppIconScale.values,
                      current: state.iconScale,
                      labelOf: (value) => value.label,
                      onSelected: (value) =>
                          context.read<SettingsCubit>().setIconScale(value),
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  _SectionCard(
                    title: S.current.elementSpacing,
                    child: _SegmentedSetting<AppUiScale>(
                      values: AppUiScale.values,
                      current: state.uiScale,
                      labelOf: (value) => value.label,
                      onSelected: (value) =>
                          context.read<SettingsCubit>().setUiScale(value),
                    ),
                  ),

                  SizedBox(height: spacing.lg),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(48 * spacing.xs / 8),
                      side: BorderSide(color: theme.colorScheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                    onPressed: () => context.read<SettingsCubit>().reset(),
                    icon: Icon(
                      Icons.restore,
                      color: theme.colorScheme.error,
                      size: context.iconSizes.md,
                    ),
                    label: Text(
                      S.current.restoreDefaultSettings,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: context.appTextStyles.captionBold.copyWith(
              fontSize: 14,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: spacing.xs),
          child,
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Function(Locale) changeLanguage;

  const _LanguageSelector({required this.changeLanguage});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ChangeLanguageDialog(
        currentLocale: Locale(Intl.defaultLocale ?? 'ar'),
        changeLanguage: changeLanguage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    final isArabic = Intl.defaultLocale == 'ar';

    return InkWell(
      onTap: () => _showLanguageDialog(context),
      borderRadius: BorderRadius.circular(spacing.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language_outlined,
              size: iconSizes.sm,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                isArabic ? S.current.arabicLanguage : S.current.englishLanguage,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: iconSizes.sm,
              color: theme.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final SettingsState state;

  const _ThemeModeSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final options = <ThemeMode, String>{
      ThemeMode.system: S.current.systemTheme,
      ThemeMode.light: S.current.lightTheme,
      ThemeMode.dark: S.current.darkTheme,
    };

    return _SegmentedSetting<ThemeMode>(
      values: options.keys.toList(),
      current: state.themeMode,
      labelOf: (value) => options[value]!,
      onSelected: (value) => context.read<SettingsCubit>().setThemeMode(value),
    );
  }
}

class _AccentColorSelector extends StatelessWidget {
  final SettingsState state;

  const _AccentColorSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Wrap(
      spacing: spacing.xs,
      runSpacing: spacing.xs,
      children: AppAccentColor.values.map((accent) {
        final isSelected = state.accentColor == accent;

        return InkWell(
          onTap: () => context.read<SettingsCubit>().setAccentColor(accent),
          borderRadius: BorderRadius.circular(spacing.radiusPill),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? accent.color.withValues(alpha: 0.12)
                  : theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(spacing.radiusPill),
              border: Border.all(
                color: isSelected
                    ? accent.color
                    : theme.colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: spacing.xs, backgroundColor: accent.color),
                SizedBox(width: spacing.xs),
                Text(
                  accent.name,
                  style: TextStyle(
                    color: isSelected
                        ? accent.color
                        : theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SegmentedSetting<T> extends StatelessWidget {
  final List<T> values;
  final T current;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  const _SegmentedSetting({
    required this.values,
    required this.current,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Wrap(
      spacing: spacing.xs,
      runSpacing: spacing.xs,
      children: values.map((value) {
        final isSelected = value == current;

        return InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(spacing.radiusPill),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(spacing.radiusPill),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              labelOf(value),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.white
                    : theme.colorScheme.onPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
