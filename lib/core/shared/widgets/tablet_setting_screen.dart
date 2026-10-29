import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:apex_restaurant/core/shared/widgets/change_language_dialog.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show Intl;

// ---------------------------------------------------------------------------
// Only layout breakpoints stay as constants. Every size, spacing, radius,
// text style and color below comes from the app theme:
//   context.spacing / context.iconSizes / theme.textTheme / theme.colorScheme
//
// Color convention of this app (same as the mobile settings screen):
//   card background  -> colorScheme.onSurface
//   main text        -> colorScheme.onPrimary
//   muted text/icons -> colorScheme.onSecondary
//   page background  -> scaffoldBackgroundColor
// ---------------------------------------------------------------------------
const double _kMaxContentWidth = 1100;
const double _kTwoColumnBreakpoint = 800;

class TabletSettingsScreen extends StatelessWidget {
  const TabletSettingsScreen({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final spacing = context.spacing;
            final iconSizes = context.iconSizes;

            // ---- Cards ----------------------------------------------------
            final languageCard = _SettingsCard(
              icon: Icons.language_rounded,
              title: S.current.language,
              child: _LanguageTile(changeLanguage: changeLanguage),
            );

            final themeCard = _SettingsCard(
              icon: Icons.palette_outlined,
              title: S.current.appearance,
              child: _ThemeModeSelector(state: state),
            );

            final accentCard = _SettingsCard(
              icon: Icons.color_lens_outlined,
              title: S.current.accentColor,
              child: _AccentColorSelector(state: state),
            );

            final fontCard = _SettingsCard(
              icon: Icons.text_fields_rounded,
              title: S.current.fontSize,
              child: _OptionGroup<AppFontScale>(
                values: AppFontScale.values,
                current: state.fontScale,
                labelOf: (v) => v.label,
                onSelected: (v) =>
                    context.read<SettingsCubit>().setFontScale(v),
              ),
            );

            final iconCard = _SettingsCard(
              icon: Icons.interests_outlined,
              title: S.current.iconSize,
              child: _OptionGroup<AppIconScale>(
                values: AppIconScale.values,
                current: state.iconScale,
                labelOf: (v) => v.label,
                onSelected: (v) =>
                    context.read<SettingsCubit>().setIconScale(v),
              ),
            );

            final spacingCard = _SettingsCard(
              icon: Icons.space_dashboard_outlined,
              title: S.current.elementSpacing,
              child: _OptionGroup<AppUiScale>(
                values: AppUiScale.values,
                current: state.uiScale,
                labelOf: (v) => v.label,
                onSelected: (v) => context.read<SettingsCubit>().setUiScale(v),
              ),
            );

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.xxl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _kMaxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(title: S.current.settings),
                        SizedBox(height: spacing.xl),

                        // Two columns on wide tablets, one column otherwise.
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final twoColumns =
                                constraints.maxWidth >= _kTwoColumnBreakpoint;

                            if (!twoColumns) {
                              return Column(
                                children: _withGaps(spacing.xl, [
                                  languageCard,
                                  themeCard,
                                  accentCard,
                                  fontCard,
                                  iconCard,
                                  spacingCard,
                                ]),
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: _withGaps(spacing.xl, [
                                      languageCard,
                                      themeCard,
                                      accentCard,
                                    ]),
                                  ),
                                ),
                                SizedBox(width: spacing.xl),
                                Expanded(
                                  child: Column(
                                    children: _withGaps(spacing.xl, [
                                      fontCard,
                                      iconCard,
                                      spacingCard,
                                    ]),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: spacing.xxl),

                        // ---- Reset button ----
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(spacing.xxl * 2),
                            side: BorderSide(
                              color: theme.colorScheme.error,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusLg,
                              ),
                            ),
                          ),
                          onPressed: () =>
                              context.read<SettingsCubit>().reset(),
                          icon: Icon(
                            Icons.restore_rounded,
                            color: theme.colorScheme.error,
                            size: iconSizes.lg,
                          ),
                          label: Text(
                            S.current.restoreDefaultSettings,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Inserts a vertical gap between every widget in [children].
  static List<Widget> _withGaps(double gap, List<Widget> children) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) result.add(SizedBox(height: gap));
      result.add(children[i]);
    }
    return result;
  }
}

// ===========================================================================
// Header
// ===========================================================================
class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            size: iconSizes.xl,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: spacing.xxl),

        Icon(
          Icons.settings_rounded,
          size: iconSizes.xl,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: spacing.sm),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Card container for each settings section
// ===========================================================================
class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSizes.lg,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          child,
        ],
      ),
    );
  }
}

// ===========================================================================
// Shared option tile (used by every selector)
// ===========================================================================
class _OptionTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final Color? accent; // overrides primary when provided
  final EdgeInsetsGeometry? padding;

  const _OptionTile({
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.accent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final color = accent ?? theme.colorScheme.primary;
    final radius = BorderRadius.circular(spacing.radiusLg);

    return Material(
      color: isSelected
          ? color.withValues(alpha: 0.12)
          : theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: isSelected ? color : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: ConstrainedBox(
          // Comfortable touch target that still follows the UI-scale setting.
          constraints: BoxConstraints(minHeight: spacing.xxl * 1.75),
          child: Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: spacing.xl,
                  vertical: spacing.sm,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Language
// ===========================================================================
class _LanguageTile extends StatelessWidget {
  final Function(Locale) changeLanguage;
  const _LanguageTile({required this.changeLanguage});

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

    return _OptionTile(
      isSelected: false,
      onTap: () => _showLanguageDialog(context),
      child: Row(
        children: [
          Text(
            isArabic ? '🇸🇦' : '🇺🇸',
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              isArabic ? S.current.arabicLanguage : S.current.englishLanguage,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: iconSizes.xl,
            color: theme.colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Theme mode (3 equal tiles with icons)
// ===========================================================================
class _ThemeModeSelector extends StatelessWidget {
  final SettingsState state;
  const _ThemeModeSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    final options = <ThemeMode, ({String label, IconData icon})>{
      ThemeMode.system: (
        label: S.current.systemTheme,
        icon: Icons.brightness_auto_rounded,
      ),
      ThemeMode.light: (
        label: S.current.lightTheme,
        icon: Icons.light_mode_rounded,
      ),
      ThemeMode.dark: (
        label: S.current.darkTheme,
        icon: Icons.dark_mode_rounded,
      ),
    };

    final entries = options.entries.toList();

    return Row(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) SizedBox(width: spacing.sm),
          Expanded(
            child: Builder(
              builder: (context) {
                final mode = entries[i].key;
                final data = entries[i].value;
                final isSelected = state.themeMode == mode;

                return _OptionTile(
                  isSelected: isSelected,
                  onTap: () => context.read<SettingsCubit>().setThemeMode(mode),
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xs,
                    vertical: spacing.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.icon,
                        size: iconSizes.xl,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSecondary,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        data.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

// ===========================================================================
// Accent colors (big swatches)
// ===========================================================================
class _AccentColorSelector extends StatelessWidget {
  final SettingsState state;
  const _AccentColorSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: AppAccentColor.values.map((accent) {
        final isSelected = state.accentColor == accent;

        return _OptionTile(
          isSelected: isSelected,
          accent: accent.color,
          onTap: () => context.read<SettingsCubit>().setAccentColor(accent),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSizes.xl,
                height: iconSizes.xl,
                decoration: BoxDecoration(
                  color: accent.color,
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: iconSizes.md,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: spacing.sm),
              Text(
                accent.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? accent.color
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ===========================================================================
// Generic option group (font / icon / spacing)
// ===========================================================================
class _OptionGroup<T> extends StatelessWidget {
  final List<T> values;
  final T current;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  const _OptionGroup({
    required this.values,
    required this.current,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: values.map((value) {
        final isSelected = value == current;

        return _OptionTile(
          isSelected: isSelected,
          onTap: () => onSelected(value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_circle_rounded,
                  size: iconSizes.lg,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: spacing.xs),
              ],
              Text(
                labelOf(value),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
