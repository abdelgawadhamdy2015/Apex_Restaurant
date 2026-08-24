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

    // 1. طلب فحص الجلسة الحالية من الـ PosBloc
    context.read<PosBloc>().add(CurrentRestaurantPosSessionEvent());

    if (ApiConstants.userId != null) {
      homeBloc.add(LoadUserDataEvent(id: ApiConstants.userId!));
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
              // Top Bar
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final branches = state.branches
                      .whereType<EmployeeBranch>()
                      .toList();
                  final current = branches.isNotEmpty ? branches.first : null;
                  if (current != null && state.selectedEmployeeBranch == null) {
                    context.read<HomeBloc>().add(SelectBranchEvent(current));
                  }
                  return const PosTopAppBar();
                },
              ),
              // Session Start Screen Container
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, homeState) {
                    return _SessionStartContent(
                      userDataModel: homeState.userDataModel,
                      selectedEmployeeBranch: homeState.selectedEmployeeBranch,
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
        // الاستماع لـ HomeBloc عند بدء فتح جلسة جديدة
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == HomeStatus.openSessionLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state.status == HomeStatus.openSessionLoaded) {
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state.sessionModel != null && state.sessionModel!.id != 0) {
                context.push(Routes.posScreen);
              } else {
                showDialog(
                  context: context,
                  builder: (_) => const OpeningBalanceDialog(),
                );
              }
            } else if (state.status == HomeStatus.error) {
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty) {
                HelperMethods.showSnackBar(
                  context: context,
                  message: state.errorMessage!,
                  isError: true,
                );
              }
            }
          },
        ),

        // الاستماع لـ PosBloc لعرض أخطاء جلب الجلسة الحالية إن وجدت
        BlocListener<PosBloc, PosState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == PosStatus.error &&
                state.errorMessage != null &&
                state.errorMessage!.isNotEmpty) {
              HelperMethods.showSnackBar(
                context: context,
                message: state.errorMessage!,
                isError: true,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, posState) {
          final userName = userDataModel?.employees?.arabicName ?? 'المستخدم';
          final jobTitle =
              userDataModel?.employees?.arabicName ?? 'مدير النظام المالي';
          final branchName =
              selectedEmployeeBranch?.arabicName ??
              selectedEmployeeBranch?.latinName ??
              'الفرع الرئيسي';
          final firstLetter = userName.isNotEmpty ? userName.trim()[0] : 'أ';

          // التحقق من وجود جلسة نشطة عبر PosBloc
          final bool hasActiveSession =
              posState.currentSessionId != null &&
              posState.currentSessionId != 0;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  const _AppLogo(),
                  SizedBox(height: spacing.xl),

                  // Session Card
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
                        // Greeting Header
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

                        // User Info Card
                        _UserProfileCard(
                          userName: userName,
                          active: userDataModel?.employees?.status == 1,
                          jobTitle: jobTitle,
                          firstLetter: firstLetter,
                        ),
                        SizedBox(height: spacing.lg),

                        // Details List
                        _SessionDetailItem(
                          icon: Icons.apartment_rounded,
                          label: 'الفرع المعتمد',
                          value: branchName,
                        ),
                        Divider(
                          color: theme.dividerColor.withOpacity(0.4),
                          height: spacing.md,
                        ),
                        const _SessionDetailItem(
                          icon: Icons.shield_outlined,
                          label: 'مستوى الصلاحية',
                          value: 'وصول كامل (آمن)',
                        ),
                        Divider(
                          color: theme.dividerColor.withOpacity(0.4),
                          height: spacing.md,
                        ),
                        const _SessionDetailItem(
                          icon: Icons.code_rounded,
                          label: 'عنوان الخادم IP',
                          value: '192.168.1.14',
                        ),
                        SizedBox(height: spacing.xl),

                        // Start / Continue Session Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (hasActiveSession) {
                                // الانتقال للـ POS مباشرة عند وجود جلسة فعالة
                                context.push(Routes.posScreen);
                              } else {
                                // إرسال حدث فتح الجلسة لـ HomeBloc
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
                                borderRadius: BorderRadius.circular(
                                  spacing.radiusSm,
                                ),
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
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: spacing.xs),
                                Icon(
                                  hasActiveSession
                                      ? Icons.play_arrow_rounded
                                      : Icons.arrow_forward,
                                  size: context.iconSizes.sm,
                                  color: colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.sm),

                        // Logout Button
                        TextButton(
                          onPressed: () {
                            context.go(Routes.loginScreen);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
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
        },
      ),
    );
  }
}

/// Header Logo Widget
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

/// User Info Badge Box
class _UserProfileCard extends StatelessWidget {
  final String userName;
  final String jobTitle;
  final String firstLetter;
  final bool active;

  const _UserProfileCard({
    required this.userName,
    required this.jobTitle,
    required this.firstLetter,
    required this.active,
  });

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
          // User Avatar
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

          // User Info Text
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
                  style: textTheme.bodySmall?.copyWith(),
                ),
              ],
            ),
          ),

          // Status Indicator Badge
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
                  active ? 'متصل' : "غير متصل",
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

/// Session Details List Row
class _SessionDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SessionDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label + Icon (Right)
        Row(
          children: [
            Text(label, style: textTheme.bodyMedium?.copyWith()),
            SizedBox(width: context.spacing.xs),
            Icon(icon, size: context.iconSizes.sm),
          ],
        ),
        // Value (Left)
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
