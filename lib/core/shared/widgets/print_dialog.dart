import 'package:flutter/material.dart';

class PrintDialog extends StatelessWidget {
  const PrintDialog({
    super.key,
    required this.title,
    required this.printKitchenTitle,
    required this.printReceiptTitle,
    required this.onPrintReceipt,
    this.onPrintKitchen,
    this.radius,
    this.spacing = 8,
    this.primaryColor,
    this.secondaryColor,
  });

  final String title;
  final String printKitchenTitle;
  final String printReceiptTitle;

  final VoidCallback? onPrintKitchen;
  final VoidCallback onPrintReceipt;

  final double? radius;
  final double spacing;

  final Color? primaryColor;
  final Color? secondaryColor;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String printKitchenTitle,
    required String printReceiptTitle,
    required VoidCallback onPrintReceipt,
    VoidCallback? onPrintKitchen,
    double? radius,
    double spacing = 8,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => PrintDialog(
        title: title,
        printKitchenTitle: printKitchenTitle,
        printReceiptTitle: printReceiptTitle,
        onPrintKitchen: onPrintKitchen,
        onPrintReceipt: onPrintReceipt,
        radius: radius,
        spacing: spacing,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 16),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPrintKitchen != null) ...[
            _PrintOptionButton(
              icon: Icons.restaurant_outlined,
              title: printKitchenTitle,
              color: primaryColor ?? theme.colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
                onPrintKitchen!();
              },
            ),
            SizedBox(height: spacing),
          ],
          _PrintOptionButton(
            icon: Icons.receipt_long_outlined,
            title: printReceiptTitle,
            color: secondaryColor ?? theme.colorScheme.secondary,
            onPressed: () {
              Navigator.of(context).pop();
              onPrintReceipt();
            },
          ),
        ],
      ),
    );
  }
}

class _PrintOptionButton extends StatelessWidget {
  const _PrintOptionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(title),
      ),
    );
  }
}
