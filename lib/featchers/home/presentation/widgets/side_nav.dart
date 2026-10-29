// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/change_language_dialog.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';
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
                      context.pushReplacementNamed(Routes.posScreen);
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
