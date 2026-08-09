import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

enum PaymentMethodType { cash, card, other }

class TabletPaymentDialog extends StatefulWidget {
  final double totalAmount;
  final Function(
    PaymentMethodType method,
    double paidAmount,
    String? referenceNumber,
    Map<String, double>? splitAmounts,
  )?
  onConfirmPayment;

  const TabletPaymentDialog({
    super.key,
    required this.totalAmount,
    this.onConfirmPayment,
  });

  static Future<void> show(
    BuildContext context, {
    required double totalAmount,
    Function(
      PaymentMethodType method,
      double paidAmount,
      String? referenceNumber,
      Map<String, double>? splitAmounts,
    )?
    onConfirmPayment,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: SizedBox(
          width: 520,
          child: TabletPaymentDialog(
            totalAmount: totalAmount,
            onConfirmPayment: onConfirmPayment,
          ),
        ),
      ),
    );
  }

  @override
  State<TabletPaymentDialog> createState() => _TabletPaymentDialogState();
}

class _TabletPaymentDialogState extends State<TabletPaymentDialog> {
  PaymentMethodType _selectedMethod = PaymentMethodType.cash;
  late TextEditingController _paidController;
  late TextEditingController _referenceController;

  // Split payment amounts controller values
  final Map<String, TextEditingController> _splitControllers = {
    'cash': TextEditingController(text: '0.00'),
    'card': TextEditingController(text: '0.00'),
    'visa': TextEditingController(text: '0.00'),
    'transfer': TextEditingController(text: '0.00'),
    'loyalty': TextEditingController(text: '0.00'),
    'voucher': TextEditingController(text: '0.00'),
  };

  @override
  void initState() {
    super.initState();
    _paidController = TextEditingController(
      text: widget.totalAmount.toStringAsFixed(2),
    );
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _paidController.dispose();
    _referenceController.dispose();
    for (var controller in _splitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _calculateTotalSplitPaid() {
    double total = 0.0;
    _splitControllers.forEach((_, controller) {
      total += double.tryParse(controller.text) ?? 0.0;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;
    final l10n = S.of(context);

    final double singlePaidAmount =
        double.tryParse(_paidController.text) ?? 0.0;
    final double totalPaidAmount = _selectedMethod == PaymentMethodType.other
        ? _calculateTotalSplitPaid()
        : singlePaidAmount;

    final double remainingAmount = totalPaidAmount - widget.totalAmount;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -----------------------------------------------------------------
            // Dialog Header
            // -----------------------------------------------------------------
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Text(
                    l10n.payment,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // Dialog Content Body
            // -----------------------------------------------------------------
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Payment Method Selector Bar
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        _buildMethodTab(
                          type: PaymentMethodType.cash,
                          label: l10n.cash,
                          icon: Icons.payments_outlined,
                          isSelected: _selectedMethod == PaymentMethodType.cash,
                        ),
                        _buildMethodTab(
                          type: PaymentMethodType.card,
                          label: l10n.card,
                          icon: Icons.credit_card_outlined,
                          isSelected: _selectedMethod == PaymentMethodType.card,
                        ),
                        _buildMethodTab(
                          type: PaymentMethodType.other,
                          label: '... ${l10n.other}',
                          icon: null,
                          isSelected:
                              _selectedMethod == PaymentMethodType.other,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  // Total Required Card
                  Container(
                    padding: EdgeInsets.all(spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              spacing.radiusSm,
                            ),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: colorScheme.primary,
                            size: 26,
                          ),
                        ),
                        SizedBox(width: spacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.totalAmountRequired,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    l10n.saudiRiyal,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.totalAmount.toStringAsFixed(2),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  // Dynamic Body according to Tab Selection
                  if (_selectedMethod == PaymentMethodType.other)
                    _buildSplitPaymentView(l10n)
                  else
                    _buildSinglePaymentView(l10n, remainingAmount),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // Dialog Footer Actions
            // -----------------------------------------------------------------
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Confirm Payment Button
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (widget.onConfirmPayment != null) {
                            Map<String, double>? splitData;
                            if (_selectedMethod == PaymentMethodType.other) {
                              splitData = _splitControllers.map(
                                (k, v) =>
                                    MapEntry(k, double.tryParse(v.text) ?? 0.0),
                              );
                            }
                            widget.onConfirmPayment!(
                              _selectedMethod,
                              totalPaidAmount,
                              _selectedMethod == PaymentMethodType.card
                                  ? _referenceController.text
                                  : null,
                              splitData,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiary,
                          foregroundColor: colorScheme.onTertiary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusMd,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline, size: 22),
                        label: Text(
                          l10n.payNow,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.sm),

                  // Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          foregroundColor: colorScheme.onSurfaceVariant,
                          side: BorderSide(color: colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusMd,
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Single Payment View for Cash & Card Tabs
  Widget _buildSinglePaymentView(S l10n, double remainingAmount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remaining Amount Box
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.remainingAmount,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 52,
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          remainingAmount.toStringAsFixed(2),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          l10n.currencySymbol,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.md),

            // Paid Input Field
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.paidAmount,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 52,
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                      border: Border.all(color: colorScheme.primary, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _paidController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlign: TextAlign.left,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        Text(
                          l10n.currencySymbol,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Reference Number Field (Displayed only for Card tab)
        if (_selectedMethod == PaymentMethodType.card) ...[
          SizedBox(height: spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.referenceNumber,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _referenceController,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.enterTransactionNumber,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(
                              0.6,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Split Payment Grid View for "Other" Tab
  Widget _buildSplitPaymentView(S l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    final double splitPaidTotal = _calculateTotalSplitPaid();
    final double remainingAmount = splitPaidTotal - widget.totalAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.cash,
                      icon: Icons.payments_outlined,
                      controller: _splitControllers['cash']!,
                      iconColor: Colors.amber,
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.card,
                      icon: Icons.credit_card_outlined,
                      controller: _splitControllers['card']!,
                      iconColor: colorScheme.primary,
                      isFocused: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.visa,
                      icon: Icons.account_balance_outlined,
                      controller: _splitControllers['visa']!,
                      iconColor: Colors.indigo,
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.bankTransfer,
                      icon: Icons.swap_horiz_outlined,
                      controller: _splitControllers['transfer']!,
                      iconColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.loyaltyPoints,
                      icon: Icons.stars_outlined,
                      controller: _splitControllers['loyalty']!,
                      iconColor: Colors.grey,
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: _buildSplitInputTile(
                      label: l10n.voucher,
                      icon: Icons.confirmation_number_outlined,
                      controller: _splitControllers['voucher']!,
                      iconColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),

        // Bottom Remaining Box for Split View
        Container(
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                remainingAmount.toStringAsFixed(2),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.tertiary,
                ),
              ),
              Row(
                children: [
                  Text(
                    l10n.remainingAmount,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.currencySymbol,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplitInputTile({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color iconColor,
    bool isFocused = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = S.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Method Icon & Label
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),

        // Input Field
        Container(
          width: 100,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isFocused
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isFocused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                l10n.currencySymbol,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isFocused
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodTab({
    required PaymentMethodType type,
    required String label,
    required IconData? icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedMethod = type),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
