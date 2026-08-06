import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddReservationButton extends StatelessWidget {
  const AddReservationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add_circle, color: AppColors.white, size: iconSizes.md),
      label: Text(
        l10n.addNewReservation,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppColors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusLg),
        ),
      ),
    );
  }
}
