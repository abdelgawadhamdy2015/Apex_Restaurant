import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PosTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PosTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Row(
          children: [
            // Left: User info (RTL - right side)
            Row(
              children: [
                _NotificationButton(),
                const SizedBox(width: AppSpacing.md),
                _WifiIndicator(),
                const SizedBox(width: AppSpacing.lg),
                _UserChip(),
              ],
            ),

            const Spacer(),

            // Right: Branch info + Logo (RTL - left side)
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      RestaurantConstants.currentBranch?.arabicName ??
                          'فرع غير معروف',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'متصل الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
                _AppLogo(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Directionality.of(context) == TextDirection.ltr) {
          Scaffold.of(context).openDrawer();
        } else if (Directionality.of(context) == TextDirection.rtl) {
          Scaffold.of(context).openEndDrawer();
        }
      },
      child: Row(
        children: [
          Container(
            width: 100,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.white, AppColors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: SvgPicture.asset(
              Assets.images.logo,
              width: 20,
              height: 20,
              // color: Colors.white,
            ),
          ),
          // const SizedBox(width: AppSpacing.sm),
          // Text(
          //   'ApexTime',
          //   style: GoogleFonts.cairo(
          //     fontSize: 20,
          //     fontWeight: FontWeight.w800,
          //     color: AppColors.primary,
          //     letterSpacing: -0.5,
          //   ),
          // ),
        ],
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: 8,
            height: 8,
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
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Icon(Icons.wifi, size: 20, color: AppColors.success),
    );
  }
}

class _UserChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: const BorderSide(color: AppColors.border).toPaint().isAntiAlias
            ? null
            : null,
      ),
      child: Row(
        children: [
          Text(
            'أحمد العتيبي',
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}

// extension on Paint {
//   bool get isAntiAlias => true;
// }
