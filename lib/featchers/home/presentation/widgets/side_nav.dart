// Side Navigation
import 'package:apex_restaurant/core/helpers/app_string.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideNav extends StatelessWidget {
  const SideNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.4, // 25% of screen width
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),
          // ── User profile
          Column(
            children: [
              CircleAvatar(
                radius: AppRadius.full,
                backgroundColor: const Color(0xFFDDE3EE),
                child: ClipOval(
                  child: Container(
                    width: 76,
                    height: 76,
                    color: const Color(0xFFB0BDD6),
                    child: Icon(
                      Icons.person,
                      size: AppTheme.theme.iconTheme.size,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'فرع الرياض الرئيسي',
                  style: TextStyles.darkBlueRegulerStyle(
                    fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'متصل الآن',
                style: TextStyle(fontSize: 11, color: Color(0xFF8A94A6)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // ── Nav items
          _NavItem(
            icon: Icons.home_sharp,
            label: 'الصفحة الرئيسية',
            onTap: () => context.goNamed(Routes.homeScreen),
          ),
          _NavItem(
            icon: Icons.point_of_sale_outlined,
            label: 'نقطة البيع',
            onTap: () => context.goNamed(Routes.posScreen),
          ),
          _NavItem(
            icon: Icons.list_alt_outlined,
            label: 'الطلبات',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.table_restaurant_outlined,
            label: 'الطاولات',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.bar_chart_outlined,
            label: 'التقارير',
            onTap: () {},
          ),
          const Spacer(),
          // ── Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 28, right: 20, left: 20),
            child: GestureDetector(
              onTap: () {
                setupLogOutDialogState(context, AppStrings.current.logout, [
                  AppStrings.current.okDialog,
                  AppStrings.current.cancel,
                ]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'تسجيل الخروج',
                    style: TextStyles.lightRedRegulerStyle(
                      fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.logout,
                    color: Color(0xFFE53935),
                    size: AppTheme.theme.iconTheme.size,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF555E6D), size: 22),
          title: Text(
            label,
            style: TextStyles.blackMediumStyle(
              fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: onTap,
          hoverColor: const Color(0xFFF0F4FF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          minLeadingWidth: 20,
        ),
      ),
    );
  }
}
