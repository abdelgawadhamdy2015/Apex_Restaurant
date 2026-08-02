import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/tables/data/models/tables_screen_arg.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MoreOptions extends StatelessWidget {
  const MoreOptions({super.key});

  Future<void> _openTables(BuildContext context) async {
    final cartBloc = context.read<CartBloc>();

    if (cartBloc.state.persons.isEmpty) {
      cartBloc.add(LoadCartDataEvent());
      await cartBloc.stream.firstWhere((state) => !state.isLoading);
    }

    if (!context.mounted) return;

    final homeState = context.read<HomeBloc>().state;

    context.pushNamed(
      Routes.tableScreen,
      extra: TablesScreenArgs(
        branchId: homeState.selectedEmployeeBranch?.branchId ?? 0,
        personList: cartBloc.state.persons,
        inCartScreen: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    final options = <OptionItem>[
      OptionItem(
        title: lang.cashierCustody,
        icon: Icons.payments,
        onTap: () => context.pushNamed(Routes.cashierCustodyScreen),
      ),
      OptionItem(
        title: lang.tables,
        icon: Icons.receipt_long,
        onTap: () => _openTables(context),
      ),
      OptionItem(
        title: lang.returns,
        icon: Icons.receipt_long,
        onTap: () => context.pushNamed(Routes.returnsScreen),
      ),
      OptionItem(
        title: lang.closeCustody,
        icon: Icons.lock_clock_rounded,
        onTap: () {},
      ),
      OptionItem(
        title: lang.suspendSession,
        icon: Icons.pause_circle_outline,
        iconColor: colorScheme.secondary,
        onTap: () {},
      ),
      OptionItem(
        title: lang.closeSession,
        icon: Icons.power_settings_new,
        iconColor: colorScheme.errorContainer,
        isLogOut: true,
        onTap: () {},
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.outlineVariant,
        appBar: CustomAppBar(title: lang.more, showBackButton: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              children: [
                const Header(customerName: 'Abdelgawad', employeeType: 'Admin'),
                SizedBox(height: spacing.lg),
                for (final option in options) ...[
                  option,
                  SizedBox(height: spacing.lg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.customerName,
    required this.employeeType,
  });

  final String customerName;
  final String employeeType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconSizes = context.iconSizes;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spacing.radiusSm),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: spacing.radiusXl,
            backgroundColor: colorScheme.primary.withOpacity(.5),
            child: Icon(
              Icons.person,
              size: iconSizes.lg,
              color: colorScheme.inversePrimary,
            ),
          ),
          SizedBox(width: spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(employeeType),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.isLogOut = false,
  });

  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final bool isLogOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          color: isLogOut
              ? colorScheme.errorContainer.withOpacity(.08)
              : colorScheme.onPrimary,
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: ListTile(
          title: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isLogOut ? colorScheme.error : Colors.black,
            ),
          ),
          leading: Container(
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              color: isLogOut
                  ? colorScheme.onErrorContainer
                  : colorScheme.primary.withOpacity(.2),
              borderRadius: BorderRadius.circular(spacing.radiusSm),
            ),
            child: Icon(icon, color: iconColor ?? colorScheme.primary),
          ),
          trailing: Icon(
            isLogOut ? Icons.logout : Icons.arrow_forward_ios,
            color: isLogOut
                ? colorScheme.errorContainer
                : colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
