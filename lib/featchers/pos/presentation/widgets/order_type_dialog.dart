import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderTypeDialog extends StatelessWidget {
  const OrderTypeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الفاتورة',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            _TypeCard(
              title: 'سفري',
              icon: Icons.shopping_bag,
              onTap: () {
                context.pop(PosOrderType.takeaway);
              },
            ),

            const SizedBox(height: 12),

            _TypeCard(
              title: 'توصيل',
              icon: Icons.delivery_dining,
              onTap: () {
                context.pop(PosOrderType.delivery);
              },
            ),

            const SizedBox(height: 12),

            _TypeCard(
              title: 'صالة',
              icon: Icons.table_restaurant,
              onTap: () {
                context.pop(PosOrderType.dineIn);
              },
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
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
