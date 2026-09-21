import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/size_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/accredite_pos_invoices_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_invoice_accrediting_data_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/restaurant_invoice_accrediting_data.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class DailyCloseScreen extends StatefulWidget {
  const DailyCloseScreen({super.key});

  @override
  State<DailyCloseScreen> createState() => _DailyCloseScreenState();
}

class _DailyCloseScreenState extends State<DailyCloseScreen> {
  bool _printWithApproval = true;
  bool _approveDeficitVoucher = false;
  final TextEditingController drowerCashController = TextEditingController();
  final TextEditingController deficitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoreActionsBloc>().add(
        FetchAllInvoicesAcreditDataEvent(
          request: GetInvoiceAccreditingDataRequest(
            employeesId: ApiConstants.empId,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);
    final isTablet = SizeHelper.isTablet;
    return isTablet
        ? _buildTabletLayout(context, theme, spacing, lang)
        : _buildMobileLayout(context, theme, spacing, lang);
  }

  // ---------------------------------------------------------------------
  // MOBILE LAYOUT (unchanged single-column design)
  // ---------------------------------------------------------------------
  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S lang,
  ) {
    return Scaffold(
      appBar: CustomAppBar(title: lang.closeCustody),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(spacing.radiusLg),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: BlocConsumer<MoreActionsBloc, MoreActionsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status ||
                previous.message != current.message,
            listener: (context, state) {
              if (state.status == MoreActionsStatus.successAcredit) {
                HelperMethods.showSnackBar(
                  context: context,
                  message: state.message ?? lang.savedSuccessfully,
                  isError: false,
                );
              }

              if (state.status == MoreActionsStatus.failure) {
                HelperMethods.showSnackBar(
                  context: context,
                  message: state.message ?? lang.somethingWentWrong,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              if (state.status == MoreActionsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == MoreActionsStatus.successAcredit) {
                context.read<PosBloc>().add(
                  SelectedNavIndexEvent(selectedNavIndex: PosBottomNavEnm.menu),
                );
                context.pop();
                context.pushReplacementNamed(Routes.posScreen);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      lang.dailyClose,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  SizedBox(height: spacing.md),

                  _MetricsSummaryCard(bordered: false, data: state.acreditData),

                  SizedBox(height: spacing.md),

                  _ExpectedCashCard(
                    totalExpectedCash: state.acreditData?.totalExpectedCash,
                  ),

                  SizedBox(height: spacing.md),

                  _AmountInputField(
                    controller: drowerCashController,
                    label: lang.actualCashInDrawer,
                    valueColor: theme.colorScheme.onPrimary,
                    onChanged: (val) {
                      final actualCash =
                          double.tryParse(drowerCashController.text) ?? 0;

                      final expectedCash =
                          state.acreditData?.totalExpectedCash ?? 0;

                      deficitController.text = (actualCash - expectedCash)
                          .toString();
                    },
                  ),

                  SizedBox(height: spacing.sm),

                  _AmountInputField(
                    controller: deficitController,
                    label: lang.deficit,
                    valueColor: theme.colorScheme.error,
                    readOnly: true,
                  ),

                  SizedBox(height: spacing.md),

                  _buildSwitches(theme, lang),

                  SizedBox(height: spacing.lg),

                  _buildApproveButton(theme, spacing, lang),

                  SizedBox(height: spacing.sm),

                  Row(
                    children: [
                      Expanded(child: _buildPrintButton(theme, spacing, lang)),
                      SizedBox(width: spacing.sm),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TABLET / DESKTOP LAYOUT (two panels, matches reference design)
  // ---------------------------------------------------------------------
  Widget _buildTabletLayout(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S lang,
  ) {
    return BlocConsumer<MoreActionsBloc, MoreActionsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.status == MoreActionsStatus.successAcredit) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.message ?? lang.savedSuccessfully,
            isError: false,
          );
        }

        if (state.status == MoreActionsStatus.failure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.message ?? lang.somethingWentWrong,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        if (state.status == MoreActionsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == MoreActionsStatus.successAcredit) {
          context.read<PosBloc>().add(
            SelectedNavIndexEvent(selectedNavIndex: PosBottomNavEnm.menu),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                lang.dailyClose,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),

            SizedBox(height: spacing.md),

            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _TabletPanel(
                      theme: theme,
                      spacing: spacing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ExpectedCashCard(
                            totalExpectedCash:
                                state.acreditData?.totalExpectedCash,
                          ),

                          SizedBox(height: spacing.md),

                          _AmountInputField(
                            controller: drowerCashController,
                            label: lang.actualCashInDrawer,
                            valueColor: theme.colorScheme.onPrimary,
                            onChanged: (val) {
                              final actualCash =
                                  double.tryParse(drowerCashController.text) ??
                                  0;

                              final expectedCash =
                                  state.acreditData?.totalExpectedCash ?? 0;

                              deficitController.text =
                                  (actualCash - expectedCash).toString();
                            },
                          ),

                          SizedBox(height: spacing.sm),

                          _AmountInputField(
                            controller: deficitController,
                            label: lang.deficit,
                            valueColor: theme.colorScheme.error,
                            readOnly: true,
                          ),

                          SizedBox(height: spacing.md),

                          _buildSwitches(theme, lang),

                          SizedBox(height: spacing.lg),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildApproveButton(
                                  theme,
                                  spacing,
                                  lang,
                                ),
                              ),

                              SizedBox(width: spacing.sm),

                              Expanded(
                                child: _buildPrintButton(theme, spacing, lang),
                              ),

                              SizedBox(width: spacing.sm),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 320,
                    child: _TabletPanel(
                      theme: theme,
                      spacing: spacing,
                      child: _MetricsSummaryCard(
                        bordered: false,
                        data: state.acreditData,
                      ),
                    ),
                  ),

                  SizedBox(width: spacing.md),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // Shared pieces (switches + buttons) reused by both layouts
  // ---------------------------------------------------------------------
  Widget _buildSwitches(ThemeData theme, S lang) {
    return Column(
      children: [
        SwitchListTile(
          value: _printWithApproval,
          onChanged: (val) => setState(() => _printWithApproval = val),
          title: Text(
            lang.printWithApproval,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
          activeColor: AppColors.green,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _approveDeficitVoucher,
          onChanged: (val) => setState(() => _approveDeficitVoucher = val),
          title: Text(
            lang.approveDeficitVoucher,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
          activeColor: AppColors.green,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildApproveButton(ThemeData theme, dynamic spacing, S lang) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<MoreActionsBloc>().add(
          AccreditePOSInvoicesEvent(
            request: AccreditePOSInvoicesRequest(
              employeesId: ApiConstants.empId,
              drawerCash: drowerCashController.text.isNotEmpty
                  ? double.tryParse(drowerCashController.text)
                  : 0,
              printRecsWithSaving: true,
              createCashDeficitReceipt: true,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
      ),
      icon: const Icon(Icons.check_circle_outline),
      label: Text(
        lang.approve,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPrintButton(ThemeData theme, dynamic spacing, S lang) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary),
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
      ),
      icon: const Icon(Icons.print_outlined),
      label: Text(lang.printReceipt),
    );
  }
}

class _TabletPanel extends StatelessWidget {
  const _TabletPanel({
    required this.theme,
    required this.spacing,
    required this.child,
  });

  final ThemeData theme;
  final dynamic spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _MetricsSummaryCard extends StatelessWidget {
  const _MetricsSummaryCard({this.bordered = true, this.data});
  final RestaurantInvoiceAccreditingData? data;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    final content = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: lang.totalInvoices,
                amount: data?.totalOfInvoices.toString() ?? "0",
                icon: Icons.receipt_long_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _MetricTile(
                title: lang.cardNetwork,
                amount: data?.totalCredit.toString() ?? "0",
                icon: Icons.credit_card,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
        Divider(color: theme.colorScheme.outlineVariant, height: spacing.lg),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: lang.cash,
                amount: data?.totalCash.toString() ?? "0",
                icon: Icons.payments_outlined,
                color: AppColors.green,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _MetricTile(
                title: lang.returns,
                amount: data?.totalOfReturns.toString() ?? "0",
                icon: Icons.assignment_return_outlined,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        Divider(color: theme.colorScheme.outlineVariant, height: spacing.lg),

        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: lang.deliveryManCustody,
                amount: data?.deliveryMen.toString() ?? "0",
                icon: Icons.payments_outlined,
                color: AppColors.green,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _MetricTile(
                title: lang.deliveryCompanyReceivables,
                amount: data?.totalOfReturns.toString() ?? "0",
                icon: Icons.assignment_return_outlined,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ],
    );

    if (!bordered) return content;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: content,
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _MetricTile({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: spacing.xs),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Text(
          '$amount ${lang.currencySarShort}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}

class _ExpectedCashCard extends StatelessWidget {
  const _ExpectedCashCard({this.totalExpectedCash});
  final double? totalExpectedCash;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            lang.expectedTotalCash,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            '${totalExpectedCash ?? 0} ${lang.currencySarShort}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountInputField extends StatelessWidget {
  final String label;
  final Color valueColor;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  const _AmountInputField({
    required this.label,

    required this.valueColor,
    this.readOnly = false,
    this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.start,
          style: theme.textTheme.titleLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            suffixIcon: Padding(
              padding: EdgeInsets.all(spacing.sm),
              child: Text(
                lang.currencySarShort,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryFixed,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
