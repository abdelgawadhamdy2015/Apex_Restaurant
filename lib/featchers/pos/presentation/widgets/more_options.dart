import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../core/shared/widgets/setup_dialog.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../screens/close_session_dialog.dart';
import '../../../more_actions/presentation/screens/daily_close_screen.dart';
import '../../../tables/data/models/tables_screen_arg.dart';
import '../../../../generated/l10n.dart';
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

  /// فتح دايالوج إغلاق الجلسة وتمرير sessionId
  void _showCloseSessionDialog(BuildContext context, int sessionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // نمرر الـ PosBloc نفسه للـ Dialog إذا كان يعتمد عليه
        return BlocProvider.value(
          value: context.read<PosBloc>(),
          child: CloseSessionDialog(sessionId: sessionId),
        );
      },
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
        icon: Icons.account_balance_wallet_outlined,
        onTap: () {
          context.pushNamed(
            Routes.cashierCustodyScreen,
            extra:
                context.read<HomeBloc>().state.userDataModel?.employeesId ?? 0,
          );
        },
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
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Material(child: DailyCloseScreen());
            },
          );
        },
      ),

      OptionItem(
        title: lang.suspendSession,
        icon: Icons.pause_circle_outline,
        iconColor: colorScheme.secondary,
        onTap: () {},
      ),
      OptionItem(
        title: lang.navSettings,
        icon: Icons.settings,
        onTap: () {
          context.pushNamed(Routes.settingsScreen);
        },
      ),
      OptionItem(
        title: lang.closeSession,
        icon: Icons.power_settings_new,
        iconColor: colorScheme.errorContainer,
        onTap: () {
          // طلب بيانات الجلسة الحالية من الـ Bloc
          context.read<PosBloc>().add(CurrentRestaurantPosSessionEvent());
        },
      ),
      OptionItem(
        title: lang.logout,
        icon: Icons.logout,
        iconColor: colorScheme.errorContainer,
        isLogOut: true,
        onTap: () {
          showLogOutDialogState(context, lang.needSignOut, [
            lang.confirm,
            lang.cancel,
          ]);
        },
      ),
    ];

    return BlocListener<PosBloc, PosState>(
      listenWhen: (previous, current) {
        // الاستماع عند النجاح أو تغير بيانات الجلسة أو وجود خطأ
        return previous.currentSessionId != current.currentSessionId ||
            previous.status != current.status;
      },
      listener: (context, state) {
        // 1. في حالة تم جلب بيانات الجلسة الحالية بنجاح
        if (state.currentSessionId != null &&
            state.status == PosStatus.closeSession) {
          final sessionId = state.currentSessionId ?? 0;
          _showCloseSessionDialog(context, sessionId);
        }

        // 2. في حالة حدوث خطأ أثناء جلب الجلسة
        if (state.status == PosStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: CustomAppBar(title: lang.more, showBackButton: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                children: [
                  const Header(
                    customerName: 'Abdelgawad',
                    employeeType: 'Admin',
                  ),
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
        color: colorScheme.onSurface,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: spacing.radiusXl,
            backgroundColor: AppColors.background,
            child: Icon(
              Icons.person,
              size: iconSizes.lg,
              color: colorScheme.primary,
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
              Text(
                employeeType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSecondary,
                ),
              ),
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
        padding: EdgeInsets.all(spacing.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          color: isLogOut
              ? colorScheme.errorContainer.withOpacity(.08)
              : colorScheme.onSurface,
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: ListTile(
          title: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isLogOut ? colorScheme.error : colorScheme.onPrimary,
            ),
          ),
          leading: Container(
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              color: isLogOut
                  ? colorScheme.onErrorContainer
                  : context.appExtraTheme.totalAmountColor,
              borderRadius: BorderRadius.circular(spacing.radiusSm),
            ),
            child: Icon(icon, color: iconColor ?? colorScheme.primary),
          ),
          trailing: isLogOut
              ? null
              : Icon(
                  Icons.arrow_forward_ios,
                  color: isLogOut
                      ? colorScheme.errorContainer
                      : colorScheme.onSecondary,
                ),
        ),
      ),
    );
  }
}
