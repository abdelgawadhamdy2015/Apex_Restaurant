import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderTypeDialog extends StatelessWidget {
  const OrderTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: AppSizes.w200,
        padding: AppPadding.allXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر نوع الفاتورة', style: AppFonts.displayMedium),
            AppSizes.gapH32,
            _TypeCard(
              title: 'سفري',
              icon: Icons.shopping_bag,
              onTap: () => context.pop(PosOrderType.takeaway),
            ),
            AppSizes.gapH12,
            _TypeCard(
              title: 'توصيل',
              icon: Icons.delivery_dining,
              onTap: () => context.pop(PosOrderType.delivery),
            ),
            AppSizes.gapH12,
            _TypeCard(
              title: 'صالة',
              icon: Icons.table_restaurant,
              onTap: () => context.pop(PosOrderType.dineIn),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: AppSizes.h64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: AppSizes.iconLg),
            AppSizes.gapW12,
            Text(
              title,
              style: AppFonts.titleLarge.colored(AppColors.white).bold(),
            ),
          ],
        ),
      ),
    );
  }
}
