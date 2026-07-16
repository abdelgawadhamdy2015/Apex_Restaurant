import 'package:apex_restaurant/core/helpers/permission_checker.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/auth_listener.dart';
import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/shift_start_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/home_tap_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocErrorListener<HomeBloc, HomeState>(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: SideNav(changeLanguage: widget.changeLanguage),
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
                  return HomeTopBar(managerName: "");
                },
              ),
              Expanded(
                child: Row(children: [Expanded(child: _MainContent())]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _MainContent extends StatelessWidget {
  _MainContent();
  late S lang;

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${lang.welcome}، ${state.userDataModel?.employees?.arabicName}',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(lang.homeSubtitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32),
              Expanded(
                child: Row(
                  children: [
                    if (PermissionChecker(
                      RestaurantConstants.permissions,
                    ).hasAnyAccess(AppPermission.itemCardRestaurant))
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.point_of_sale,
                          iconColor: theme.colorScheme.onSurfaceVariant,
                          iconBg: theme.colorScheme.surfaceContainerHighest,
                          title: lang.salesScreen,
                          subtitle: lang.salesScreenSubtitle,
                          badge: _Badge(
                            text: lang.pleaseCheckInFirst,
                            color: theme.colorScheme.secondary,
                            isLink: true,
                            icon: Icons.alarm,
                            onTap: () {},
                          ),
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => ShiftStartDialog(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _StatusBar(),
            ],
          ),
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

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              badge,
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
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
  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Text(
            lang.currentStatusOffShift,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          _StatusItem(label: lang.lastCheckOut, value: lang.lastCheckOutValue),
          const SizedBox(width: 24),
          _StatusItem(label: lang.systemTime, value: '09:15 ص'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
