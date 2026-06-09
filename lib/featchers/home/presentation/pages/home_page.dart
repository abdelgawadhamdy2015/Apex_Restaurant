import 'package:apex_restaurant/core/helpers/permission_checker.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/auth_listener.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/shift_start_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_bar.dart';
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
        backgroundColor: AppColors.background,
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
                  return const PosTopBar();
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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.xxxl,
            vertical: AppPadding.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${lang.welcome}، ${state.userDataModel?.employees?.arabicName}',
                style: AppFonts.displayLarge.colored(AppColors.primaryDark),
              ),
              AppSizes.gapH8,
              Text(lang.homeSubtitle, style: AppFonts.bodyMedium),
              AppSizes.gapH32,
              Expanded(
                child: Row(
                  children: [
                    if (PermissionChecker(
                      RestaurantConstants.permissions,
                    ).hasAnyAccess(AppPermission.itemCardRestaurant))
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.point_of_sale,
                          iconColor: AppColors.textSecondary,
                          iconBg: AppColors.unSelectedColor,
                          title: lang.salesScreen,
                          subtitle: lang.salesScreenSubtitle,
                          badge: _Badge(
                            text: lang.pleaseCheckInFirst,
                            color: AppColors.accent,
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
                    //  AppSizes.gapW16,
                    // Expanded(
                    //   child: _ActionCard(
                    //     icon: Icons.person_pin_rounded,
                    //     iconColor: AppColors.white,
                    //     iconBg: AppColors.accent,
                    //     title: lang.signIn,
                    //     subtitle: lang.signInSubtitle,
                    //     badge: _Badge(
                    //       text: lang.shiftNotStarted,
                    //       color: AppColors.warning,
                    //       isLink: false,
                    //       icon: Icons.info_outline,
                    //     ),
                    //     onTap: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),
              AppSizes.gapH24,
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
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.xxxl,
            vertical: AppPadding.xxxl,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.w80,
                height: AppSizes.h80,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppSizes.iconXl, color: iconColor),
              ),
              AppSizes.gapH24,
              Text(
                title,
                style: AppFonts.titleLarge.colored(AppColors.primaryDark),
              ),
              AppSizes.gapH8,
              badge,
              AppSizes.gapH12,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppFonts.bodySmall.copyWith(height: 1.6),
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
    if (isLink) {
      return GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: AppFonts.bodySmall
              .colored(color)
              .semiBold()
              .copyWith(
                decoration: TextDecoration.underline,
                decorationColor: color,
              ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.md,
        vertical: AppPadding.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconSm, color: color),
            AppSizes.gapW4,
          ],
          Text(text, style: AppFonts.bodySmall.colored(color).semiBold()),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.xxl,
        vertical: AppPadding.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: AppSizes.iconSm, color: AppColors.error),
          AppSizes.gapW8,
          Text(
            lang.currentStatusOffShift,
            style: AppFonts.bodySmall.colored(AppColors.textPrimary),
          ),
          const Spacer(),
          _StatusItem(label: lang.lastCheckOut, value: lang.lastCheckOutValue),
          AppSizes.gapW24,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppFonts.bodySmall.colored(AppColors.textMuted)),
        AppSizes.gapH4,
        Text(
          value,
          style: AppFonts.bodySmall.colored(AppColors.textPrimary).semiBold(),
        ),
      ],
    );
  }
}
