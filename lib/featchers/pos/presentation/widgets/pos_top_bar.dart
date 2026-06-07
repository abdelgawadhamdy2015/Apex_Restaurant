import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/branches_dialog.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PosTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PosTopBar({super.key, this.lang});
  final S? lang;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            height: AppSizes.appBarHeight,
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: AppPadding.sm),
            child: Row(
              children: [
                _AppLogo(),
                Spacer(),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (state.selectedEmployeeBranch != null)
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(LoadBranchesEvent());
                              showDialog(
                                context: context,
                                builder: (_) => BranchesDialog(
                                  branches: context
                                      .read<HomeBloc>()
                                      .state
                                      .branches,
                                  currentBranch: state.selectedEmployeeBranch!,
                                  onBranchSelected: (branch) {
                                    context.read<HomeBloc>().add(
                                      SelectBranchEvent(branch),
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.sm,
                                vertical: AppPadding.xs,
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              state.selectedEmployeeBranch?.arabicName ?? "",
                              style: AppFonts.bodySmall.colored(
                                AppColors.white,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Text(
                              'متصل الآن',
                              style: AppFonts.bodySmall.colored(
                                AppColors.success,
                              ),
                            ),
                            AppSizes.gapW4,
                            Container(
                              width: AppSizes.w4,
                              height: AppSizes.h4,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSizes.gapW16,
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    _NotificationButton(),
                    AppSizes.gapW12,
                    _WifiIndicator(),
                    AppSizes.gapW16,
                    _UserChip(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Container(
        width: AppSizes.w48,
        height: AppSizes.h32,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: SvgPicture.asset(
          Assets.images.logo,
          width: AppSizes.iconSm,
          height: AppSizes.iconSm,
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppSizes.w32,
          height: AppSizes.h32,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.notifications_outlined,
            size: AppSizes.iconMd,
            color: AppColors.textSecondary,
          ),
        ),
        Positioned(
          top: AppPadding.xs,
          right: AppPadding.xs,
          child: Container(
            width: AppSizes.w8,
            height: AppSizes.h8,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _WifiIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w32,
      height: AppSizes.h32,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(Icons.wifi, size: AppSizes.iconMd, color: AppColors.success),
    );
  }
}

class _UserChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            children: [
              Text(
                state.userDataModel?.employees?.arabicName ?? "",
                style: AppFonts.bodySmall
                    .colored(AppColors.textPrimary)
                    .semiBold(),
              ),
              AppSizes.gapW8,
              Container(
                width: AppSizes.w24,
                height: AppSizes.h24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: AppSizes.iconSm,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
