// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show Intl;

class SideNav extends StatefulWidget {
  const SideNav({super.key, required this.changeLanguage, this.currentRoute});

  final Function(Locale) changeLanguage;
  final String? currentRoute;

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  late String selectedLanguage;
  late S lang;

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? lang.arabic
        : lang.english;

    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    // Dynamic width calculation for drawer across Phone and Tablet
    final drawerWidth = (size.width * 0.75).clamp(280.0, 360.0);

    return Drawer(
      width: drawerWidth,
      // Was AppColors.canvas — now follows the active ThemeData.
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm,
                  horizontal: spacing.md,
                ),
                child: Column(
                  children: [
                    // User Avatar
                    Container(
                      width: spacing.xl * 2.5,
                      height: spacing.xl * 2.5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: iconSizes.lg,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: spacing.sm),

                    // User Details
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(
                              state.userDataModel?.employees?.arabicName ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: spacing.xs / 2),
                            Text(
                              state.userDataModel?.isActive == true
                                  ? lang.active
                                  : lang.notActive,
                              style: theme.textTheme.bodySmall?.copyWith(
                                // Was AppColors.error for the inactive case.
                                color: state.userDataModel?.isActive == true
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                child: Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),

            // Nav Items List
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: lang.home,
                    isSelected: widget.currentRoute == Routes.homeScreen,
                    onTap: () {
                      Navigator.pop(context);
                      context.goNamed(Routes.homeScreen);
                    },
                  ),
                  _NavItem(
                    icon: Icons.point_of_sale_outlined,
                    activeIcon: Icons.point_of_sale_rounded,
                    label: lang.pos,
                    isSelected: widget.currentRoute == Routes.posScreen,
                    onTap: () {
                      Navigator.pop(context);
                      context.goNamed(Routes.posScreen);
                    },
                  ),
                  _NavItem(
                    icon: Icons.list_alt_outlined,
                    label: lang.requests,
                    onTap: () => Navigator.pop(context),
                  ),
                  _NavItem(
                    icon: Icons.table_restaurant_outlined,
                    label: lang.tables,
                    onTap: () => Navigator.pop(context),
                  ),
                  _NavItem(
                    icon: Icons.bar_chart_outlined,
                    label: lang.reports,
                    onTap: () => Navigator.pop(context),
                  ),
                  _NavItem(
                    icon: Icons.language_outlined,
                    label: selectedLanguage,
                    onTap: () {
                      Navigator.pop(context);
                      _showLanguageDialog(context);
                    },
                  ),
                ]),
              ),
            ),

            // Bottom Logout Section anchored to end
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    child: Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(spacing.md),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                      onTap: () => showLogOutDialogState(context, lang.logout, [
                        lang.okDialog,
                        lang.cancel,
                      ]),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.sm,
                          horizontal: spacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: theme.colorScheme.error,
                              size: iconSizes.sm,
                            ),
                            SizedBox(width: spacing.xs),
                            Text(
                              lang.logout,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ChangeLanguageDialog(
        currentLocale: Locale(Intl.defaultLocale!),
        changeLanguage: widget.changeLanguage,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs / 4,
      ),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          leading: Icon(
            isSelected ? (activeIcon ?? icon) : icon,
            // Was AppColors.textSecondary.
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            size: iconSizes.sm,
          ),
          title: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              // Was AppColors.textPrimary.
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

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
    widget.changeLanguage(_selected);
    Navigator.of(context).pop();
    _showToast(context);
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      // Was AppColors.surface.
      backgroundColor: theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.lg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(strings.language, style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, size: iconSizes.sm),
                    style: IconButton.styleFrom(
                      // Was AppColors.canvas.
                      backgroundColor: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.md),
              ..._languages.map(
                (lang) => _LanguageTile(
                  option: lang,
                  isSelected:
                      _selected.languageCode == lang.locale.languageCode,
                  onTap: () => setState(() => _selected = lang.locale),
                ),
              ),
              SizedBox(height: spacing.xs),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              SizedBox(height: spacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: spacing.sm),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                      ),
                      child: Text(strings.cancel),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: spacing.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                        elevation: 0,
                      ),
                      child: Text(strings.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: spacing.xs),
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          // Was AppColors.surface.
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.colorScheme.surface,
          border: Border.all(
            // Was AppColors.border.
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 36 * spacing.md,
              height: 36 * spacing.md,
              decoration: BoxDecoration(
                // Was AppColors.canvas.
                color: theme.scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(option.flag, style: const TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      // Was AppColors.textPrimary.
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    option.nativeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      // Was AppColors.textSecondary.
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: iconSizes.sm,
              ),
          ],
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
