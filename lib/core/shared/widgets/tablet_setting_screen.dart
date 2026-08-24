import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabletSettingsScreen extends StatelessWidget {
  const TabletSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final spacing = context.spacing;
          return SafeArea(
            child: ListView(
              padding: EdgeInsets.all(spacing.md),
              children: [
                _SectionCard(
                  title: 'المظهر',
                  child: _ThemeModeSelector(state: state),
                ),
                SizedBox(height: spacing.md),
                _SectionCard(
                  title: 'لون التمييز',
                  child: _AccentColorSelector(state: state),
                ),
                SizedBox(height: spacing.md),
                _SectionCard(
                  title: 'حجم الخط',
                  child: _SegmentedSetting<AppFontScale>(
                    values: AppFontScale.values,
                    current: state.fontScale,
                    labelOf: (v) => v.label,
                    onSelected: (v) =>
                        context.read<SettingsCubit>().setFontScale(v),
                  ),
                ),
                SizedBox(height: spacing.md),
                _SectionCard(
                  title: 'حجم الأيقونات',
                  child: _SegmentedSetting<AppIconScale>(
                    values: AppIconScale.values,
                    current: state.iconScale,
                    labelOf: (v) => v.label,
                    onSelected: (v) =>
                        context.read<SettingsCubit>().setIconScale(v),
                  ),
                ),
                SizedBox(height: spacing.md),
                _SectionCard(
                  title: 'التباعد بين العناصر',
                  child: _SegmentedSetting<AppUiScale>(
                    values: AppUiScale.values,
                    current: state.uiScale,
                    labelOf: (v) => v.label,
                    onSelected: (v) =>
                        context.read<SettingsCubit>().setUiScale(v),
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
                    'استعادة الإعدادات الافتراضية',
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
            // AppTextStyles.captionBold is already built per-theme with
            // colorScheme.onSurface, so this adapts automatically.
            style: context.appTextStyles.captionBold.copyWith(fontSize: 14),
          ),
          SizedBox(height: spacing.xs),
          child,
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final SettingsState state;
  const _ThemeModeSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final options = {
      ThemeMode.system: 'النظام',
      ThemeMode.light: 'فاتح',
      ThemeMode.dark: 'داكن',
    };

    return _SegmentedSetting<ThemeMode>(
      values: options.keys.toList(),
      current: state.themeMode,
      labelOf: (v) => options[v]!,
      onSelected: (v) => context.read<SettingsCubit>().setThemeMode(v),
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
                  ? accent.color.withOpacity(0.12)
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
      children: values.map((v) {
        final isSelected = v == current;
        return InkWell(
          onTap: () => onSelected(v),
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
              labelOf(v),
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
