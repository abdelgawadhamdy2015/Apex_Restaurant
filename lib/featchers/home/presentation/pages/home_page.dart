import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/permission_checker.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/auth_listener.dart';
import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/shift_start_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_app_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.changeLanguage});
  final Function(Locale) changeLanguage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _loadEmployeeBranches(),
    );
  }

  void _loadEmployeeBranches() {
    context.read<HomeBloc>().add(LoadBranchesEvent());
    context.read<HomeBloc>().add(LoadUserDataEvent(id: ApiConstants.userId!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocErrorListener<HomeBloc, HomeState>(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: SideNav(
          changeLanguage: widget.changeLanguage,
          currentRoute: Routes.homeScreen,
        ),
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final branches = state.branches
                      .whereType<EmployeeBranch>()
                      .toList();
                  final current = branches.isNotEmpty ? branches.first : null;
                  if (current != null && state.selectedEmployeeBranch == null) {
                    context.read<HomeBloc>().add(SelectBranchEvent(current));
                  }
                  return const PosTopAppBar();
                },
              ),
              const Expanded(child: _MainContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HomeStatus.openSessionLoading) {
          // Show non-dismissible loading indicator while checking session status
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state.status == HomeStatus.openSessionLoaded) {
          // Pop loading dialog if displayed
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          // Check session model to decide target screen / dialog
          if (state.sessionModel != null && state.sessionModel!.id != 0) {
            context.push(Routes.posScreen);
          } else {
            showDialog(
              context: context,
              builder: (_) => const ShiftStartDialog(),
            );
          }
        } else if (state.status == HomeStatus.error) {
          // Pop loading indicator on error
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            HelperMethods.showSnackBar(
              context: context,
              message: state.errorMessage ?? 'An error occurred',
              isError: true,
            );
          }
        }
      },
      builder: (context, state) {
        final userName = state.userDataModel?.employees?.arabicName ?? '';

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final horizontalPadding = isTablet ? spacing.xl : spacing.md;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${lang.welcome}، $userName',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    lang.homeSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: spacing.xl),

                  // Action Cards Grid/List based on screen width
                  if (PermissionChecker(
                    RestaurantConstants.permissions,
                  ).hasAnyAccess(AppPermission.itemCardRestaurant))
                    GridView.count(
                      crossAxisCount: isTablet ? 2 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: spacing.md,
                      crossAxisSpacing: spacing.md,
                      childAspectRatio: isTablet ? 1.4 : 1.6,
                      children: [
                        _ActionCard(
                          icon: Icons.point_of_sale,
                          iconColor: theme.colorScheme.onSurfaceVariant,
                          iconBg: theme.colorScheme.primary,
                          title: lang.salesScreen,
                          subtitle: lang.salesScreenSubtitle,
                          badge: _Badge(
                            text: lang.pleaseCheckInFirst,
                            color: theme.colorScheme.secondary,
                            isLink: true,
                            icon: Icons.alarm,
                            onTap: () {},
                          ),
                          onTap: () {
                            if (state.sessionModel != null &&
                                state.sessionModel!.id != 0) {
                              context.push(Routes.posScreen);
                            } else {
                              context.read<HomeBloc>().add(
                                OpenRestaurantPosEvent(),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                  SizedBox(height: spacing.lg),
                  const _StatusBar(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget badge;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(spacing.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.radiusLg),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          padding: EdgeInsets.all(spacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: spacing.sm,
                height: spacing.sm,
                child: Icon(icon, size: iconSizes.lg, color: iconColor),
              ),
              SizedBox(height: spacing.md),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.xs),
              badge,
              SizedBox(height: spacing.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isLink;
  final IconData? icon;
  final VoidCallback? onTap;

  const _Badge({
    required this.text,
    required this.color,
    required this.isLink,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    if (isLink) {
      return GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: color,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(spacing.radiusPill),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSizes.sm, color: color),
            SizedBox(width: spacing.xs / 2),
          ],
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: spacing.sm,
        spacing: spacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 12, color: theme.colorScheme.error),
              SizedBox(width: spacing.xs),
              Text(
                lang.currentStatusOffShift,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusItem(
                label: lang.lastCheckOut,
                value: lang.lastCheckOutValue,
              ),
              SizedBox(width: spacing.lg),
              _StatusItem(label: lang.systemTime, value: '09:15 ص'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatusItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs / 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
