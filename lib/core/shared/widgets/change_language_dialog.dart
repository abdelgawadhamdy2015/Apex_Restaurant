import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';

/// Width (shortest side) from which the device is treated as a tablet.
const double _kTabletBreakpoint = 600;

class ChangeLanguageDialog extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) changeLanguage;

  const ChangeLanguageDialog({
    super.key,
    required this.currentLocale,
    required this.changeLanguage,
  });

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  late Locale _selected;

  static const _languages = [
    _LanguageOption(
      locale: Locale('en'),
      flag: '🇺🇸',
      name: 'English',
      nativeName: 'English',
    ),
    _LanguageOption(
      locale: Locale('ar'),
      flag: '🇸🇦',
      name: 'Arabic',
      nativeName: 'العربية',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLocale;
  }

  void _apply() {
    // Show the toast first (while this context is still mounted),
    // then close the dialog and switch the language.
    _showToast(context);
    Navigator.of(context).pop();
    widget.changeLanguage(_selected);
  }

  void _showToast(BuildContext context) {
    final msg = _selected.languageCode == 'ar'
        ? 'تم تغيير اللغة إلى العربية ✓'
        : 'Language changed to English ✓';
    HelperMethods.showSnackBar(context: context, message: msg, isError: false);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    final size = MediaQuery.sizeOf(context);
    final isTablet = size.shortestSide >= _kTabletBreakpoint;

    final maxWidth = isTablet ? 480.0 : 400.0;
    // Keep the dialog inside the screen, also in landscape / with keyboard.
    final maxHeight = size.height * 0.9;
    final buttonVerticalPadding = isTablet ? spacing.md : spacing.sm;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? spacing.xl : spacing.md,
        vertical: spacing.lg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? spacing.xl : spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- Header ----------
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.language,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isTablet
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, size: iconSizes.sm),
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.md),

                // ---------- Languages (scrolls if space is tight) ----------
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _languages
                          .map(
                            (lang) => _LanguageTile(
                              option: lang,
                              isTablet: isTablet,
                              isSelected:
                                  _selected.languageCode ==
                                  lang.locale.languageCode,
                              onTap: () =>
                                  setState(() => _selected = lang.locale),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                SizedBox(height: spacing.xs),
                Divider(height: 1, color: theme.colorScheme.outlineVariant),
                SizedBox(height: spacing.md),

                // ---------- Actions ----------
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          padding: EdgeInsets.symmetric(
                            vertical: buttonVerticalPadding,
                          ),
                          side: BorderSide(color: theme.colorScheme.onTertiary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusMd,
                            ),
                          ),
                        ),
                        child: Text(
                          strings.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _apply,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            vertical: buttonVerticalPadding,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusMd,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          strings.apply,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final bool isSelected;
  final bool isTablet;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final radius = BorderRadius.circular(spacing.radiusMd);

    // Fixed sizes (not multiplied by spacing) so the flag never explodes
    // on larger UI-scale settings.
    final flagBox = isTablet ? 52.0 : 44.0;
    final flagFont = isTablet ? 24.0 : 20.0;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xs),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: isTablet ? spacing.sm : spacing.xs,
                ),
                child: Row(
                  children: [
                    Container(
                      width: flagBox,
                      height: flagBox,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option.flag,
                        style: TextStyle(fontSize: flagFont),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            option.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            option.nativeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: spacing.xs),
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                        size: iconSizes.sm,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final Locale locale;
  final String flag;
  final String name;
  final String nativeName;

  const _LanguageOption({
    required this.locale,
    required this.flag,
    required this.name,
    required this.nativeName,
  });
}
