import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/branches_dialog.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/shared/widgets/auth_listener.dart';
import '../../data/models/employee_branch.dart';
import '../../data/models/user_data_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/opening_balance_dialog.dart';
import '../widgets/side_nav.dart';
import '../../../pos/presentation/bloc/pos_bloc.dart';
import '../../../pos/presentation/bloc/pos_event.dart';
import '../../../pos/presentation/bloc/pos_state.dart';
import '../../../pos/presentation/widgets/pos_top_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final homeBloc = context.read<HomeBloc>();

    homeBloc.add(const LoadBranchesEvent());
    homeBloc.add(const LoadTreasuryEvent());

    context.read<PosBloc>().add(
      const CurrentRestaurantPosSessionEvent(openCloseDialog: true),
    );

    final userId = ApiConstants.userId;

    if (userId != null) {
      homeBloc.add(LoadUserDataEvent(id: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocErrorListener<HomeBloc, HomeState>(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        drawer: SideNav(
          changeLanguage: widget.changeLanguage,
          currentRoute: Routes.homeScreen,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const PosTopAppBar(),

              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return _SessionStartContent(
                      userDataModel: state.userDataModel,
                      selectedEmployeeBranch: state.selectedEmployeeBranch,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionStartContent extends StatelessWidget {
  const _SessionStartContent({this.userDataModel, this.selectedEmployeeBranch});

  final UserDataModel? userDataModel;
  final EmployeeBranch? selectedEmployeeBranch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final spacing = context.spacing;

    return MultiBlocListener(
      listeners: [
        _homeSessionListener(),
        _branchSelectionListener(),
        _homeErrorListener(),
        _posErrorListener(),
      ],
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, posState) {
          return _SessionCard(
            userDataModel: userDataModel,
            selectedEmployeeBranch: selectedEmployeeBranch,
            hasActiveSession:
                posState.currentSessionId != null &&
                posState.currentSessionId != 0,
            theme: theme,
            colorScheme: colorScheme,
            textTheme: textTheme,
            spacing: spacing,
          );
        },
      ),
    );
  }

  BlocListener<HomeBloc, HomeState> _homeSessionListener() {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == HomeStatus.openSessionLoading ||
              current.status == HomeStatus.openSessionLoaded),
      listener: (context, state) {
        switch (state.status) {
          case HomeStatus.openSessionLoading:
            _showLoadingDialog(context);
            break;

          case HomeStatus.openSessionLoaded:
            _closeDialog(context);

            final session = state.sessionModel;

            if (session != null && session.id != 0) {
              context.push(Routes.posScreen);
            } else {
              showDialog(
                context: context,
                builder: (_) => const OpeningBalanceDialog(),
              );
            }
            break;

          default:
            break;
        }
      },
    );
  }

  BlocListener<HomeBloc, HomeState> _branchSelectionListener() {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == HomeStatus.branchSelected,
      listener: (context, state) {
        context.pop();
      },
    );
  }

  BlocListener<HomeBloc, HomeState> _homeErrorListener() {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == HomeStatus.error,
      listener: (context, state) {
        _closeDialog(context);

        final message = state.errorMessage;

        if (message != null && message.isNotEmpty) {
          HelperMethods.showSnackBar(
            context: context,
            message: message,
            isError: true,
          );
        }
      },
    );
  }

  BlocListener<PosBloc, PosState> _posErrorListener() {
    return BlocListener<PosBloc, PosState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == PosStatus.error,
      listener: (context, state) {
        final message = state.errorMessage;

        if (message != null && message.isNotEmpty) {
          HelperMethods.showSnackBar(
            context: context,
            message: message,
            isError: true,
          );
        }
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _closeDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.userDataModel,
    required this.selectedEmployeeBranch,
    required this.hasActiveSession,
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
    required this.spacing,
  });

  final UserDataModel? userDataModel;
  final EmployeeBranch? selectedEmployeeBranch;
  final bool hasActiveSession;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final dynamic spacing;

  @override
  Widget build(BuildContext context) {
    final userName = userDataModel?.employees?.arabicName ?? 'المستخدم';

    final jobTitle =
        userDataModel?.employees?.arabicName ?? 'مدير النظام المالي';

    final firstLetter = userName.trim().isNotEmpty ? userName.trim()[0] : 'أ';

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _AppLogo(),
            SizedBox(height: spacing.xl),

            Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.xl,
                vertical: spacing.xl,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(color: colorScheme.outlineVariant),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مرحباً بك مجدداً',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: spacing.xs),

                  Text(
                    hasActiveSession
                        ? 'توجد جلسة عمل نشطة حالياً، يمكنك المتابعة مباشرة للـ POS'
                        : 'جاهز للبدء؟ يرجى التحقق من تفاصيل الجلسة أدناه لبدء جلسة جديدة',
                    style: textTheme.bodyMedium?.copyWith(height: 1.4),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: spacing.lg),

                  _UserProfileCard(
                    userName: userName,
                    active: userDataModel?.employees?.status == 1,
                    jobTitle: jobTitle,
                    firstLetter: firstLetter,
                  ),

                  SizedBox(height: spacing.lg),

                  _BranchSelector(selectedBranch: selectedEmployeeBranch),

                  Divider(
                    color: theme.dividerColor.withOpacity(0.4),
                    height: spacing.md,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (hasActiveSession) {
                          context.push(Routes.posScreen);
                        } else {
                          context.read<HomeBloc>().add(
                            const OpenRestaurantPosEvent(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusSm),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            hasActiveSession
                                ? 'متابعة جلسة العمل'
                                : 'بدء جلسة العمل',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: spacing.xs),
                          Icon(
                            hasActiveSession
                                ? Icons.play_arrow_rounded
                                : Icons.arrow_forward,
                            size: context.iconSizes.sm,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: spacing.sm),

                  TextButton(
                    onPressed: () {
                      context.go(Routes.loginScreen);
                    },
                    child: Text(
                      'تسجيل الخروج',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
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
}

class _BranchSelector extends StatelessWidget {
  const _BranchSelector({required this.selectedBranch});

  final EmployeeBranch? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.branches != current.branches ||
          previous.selectedEmployeeBranch != current.selectedEmployeeBranch,
      builder: (context, state) {
        final branches = state.branches.whereType<EmployeeBranch>().toList();

        final branch =
            selectedBranch ??
            state.selectedEmployeeBranch ??
            (branches.isNotEmpty ? branches.first : null);

        final branchName =
            branch?.arabicName ?? branch?.latinName ?? 'الفرع الرئيسي';

        return _SessionDetailItem(
          icon: Icons.apartment_rounded,
          label: 'الفرع المعتمد',
          value: branchName,
          onTap: branches.isEmpty
              ? null
              : () {
                  BranchesDialog.show(
                    context: context,
                    branches: branches,
                    currentBranch: branch!,
                  );
                },
        );
      },
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bolt, color: theme.colorScheme.primary, size: 36),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            children: [
              TextSpan(
                text: 'AP',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              const TextSpan(
                text: 'E',
                style: TextStyle(color: Color(0xFF00A859)),
              ),
              TextSpan(
                text: 'X',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              const TextSpan(
                text: ' ERP',
                style: TextStyle(
                  color: Color(0xFF00A859),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard({
    required this.userName,
    required this.jobTitle,
    required this.firstLetter,
    required this.active,
  });

  final String userName;
  final String jobTitle;
  final String firstLetter;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              firstLetter,
              style: textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(width: spacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs / 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(spacing.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: spacing.xs),
                Text(
                  active ? 'متصل' : 'غير متصل',
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF15803D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDetailItem extends StatelessWidget {
  const _SessionDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.spacing.radiusSm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(label, style: textTheme.bodyMedium),
                SizedBox(width: context.spacing.xs),
                Icon(icon, size: context.iconSizes.sm),
              ],
            ),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
