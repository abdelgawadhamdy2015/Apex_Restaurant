import 'package:apex_restaurant/core/helpers/permission_checker.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/shift_start_dialog.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.changeLanguage});
  final Function(Locale) changeLanguage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEmployeeBranches();
    });
  }

  void _loadEmployeeBranches() {
    context.read<HomeBloc>().add(LoadBranchesEvent());
    context.read<HomeBloc>().add(LoadUserDataEvent(id: ApiConstants.userId!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      drawer: SideNav(changeLanguage: widget.changeLanguage),

      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                final branches = state.branches
                    .whereType<EmployeeBranch>()
                    .toList();
                final current = branches.isNotEmpty ? branches.first : null;
                if (current != null && state.selectedEmployeeBranch == null) {
                  context.read<HomeBloc>().add(SelectBranchEvent(current));
                }
                return PosTopBar();
              },
            ),
            Expanded(
              child: Row(
                children: [
                  // ── Main content
                  Expanded(child: _MainContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Content

// ignore: must_be_immutable
class _MainContent extends StatelessWidget {
  _MainContent();
  late S lang;
  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Greeting
              Text(
                '${lang.welcome}، ${state.userDataModel?.employees?.arabicName}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A4A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'الرجاء اختيار الإجراء المطلوب للمتابعة',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6)),
              ),
              const SizedBox(height: 48),
              // ── Action cards
              Expanded(
                child: Row(
                  children: [
                    // شاشة البيع
                    if (PermissionChecker(
                      RestaurantConstants.permissions,
                    ).hasAnyAccess(AppPermission.itemCardRestaurant))
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.point_of_sale,
                          iconColor: const Color(0xFF8A94A6),
                          iconBg: const Color(0xFFDDE3EE),
                          title: lang.salesScreen,
                          subtitle: 'الوصول إلى لوحة التحكم والطلبات والمبيعات',
                          badge: _Badge(
                            text: 'يرجى تسجيل الحضور أولاً',
                            color: const Color(0xFF2563EB),
                            isLink: true,
                            onTap: () {},
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ShiftStartDialog();
                              },
                            );
                          },
                        ),
                      ),
                    SizedBox(width: AppSpacing.lg),
                    // تسجيل الحضور
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.person_pin_rounded,
                        iconColor: Colors.white,
                        iconBg: const Color(0xFF2563EB),
                        title: lang.signIn,
                        subtitle: 'قم بتسجيل حضورك لبدء وردية العمل الجديدة',
                        badge: _Badge(
                          text: 'الوردية لم تبدأ بعد',
                          color: const Color(0xFFF97316),
                          isLink: false,
                          icon: Icons.info_outline,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // ── Status bar
              _StatusBar(),
            ],
          ),
        );
      },
    );
  }
}

// Action Card

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget badge;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 38, color: iconColor),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A4A),
                ),
              ),
              const SizedBox(height: 10),
              badge,
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A94A6),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Badge widget (link style or pill style)
class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isLink;
  final IconData? icon;
  final VoidCallback? onTap;

  const _Badge({
    required this.text,
    required this.color,
    required this.isLink,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLink) {
      return GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
            decoration: TextDecoration.underline,
            decorationColor: color,
          ),
        ),
      );
    }
    // Pill badge
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Status Bar (bottom)
class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // الحالة الحالية
          const Icon(Icons.circle, size: 10, color: Color(0xFFE53935)),
          const SizedBox(width: 8),
          const Text(
            'الحالة الحالية: خارج الوردية',
            style: TextStyle(fontSize: 13, color: Color(0xFF2D3748)),
          ),
          const Spacer(),
          // آخر تسجيل خروج
          _StatusItem(label: 'آخر تسجيل خروج', value: 'أمس، 11:30 م'),
          const SizedBox(width: 32),
          // توقيت النظام
          _StatusItem(label: 'توقيت النظام', value: '09:15 ص'),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatusItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8A94A6)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}
