import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/featchers/home/presentation/ui/widgets/shift_start_dialog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        drawer: Directionality.of(context) == TextDirection.ltr
            ? _SideNav()
            : null,

        endDrawer: Directionality.of(context) == TextDirection.rtl
            ? _SideNav()
            : null,

        body: SafeArea(
          child: Column(
            children: [
              const _TopBar(),
              Expanded(
                child: Row(
                  children: [
                    // ── Main content ──────────────────────────
                    const Expanded(child: _MainContent()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Top Bar
// ══════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Icons right side (rtl → appears left)
          Icon(
            Icons.account_circle_outlined,
            size: SizeConfig.iconSize1,
            color: Color(0xFF555E6D),
          ),
          const SizedBox(width: 18),
          Icon(
            Icons.notifications_none_outlined,
            size: SizeConfig.iconSize1,
            color: Color(0xFF555E6D),
          ),
          const Spacer(),
          // App name left side (rtl → appears right)
          const Text(
            'ApexRestaurant',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A6B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 18),

          IconButton(
            icon: const Icon(Icons.menu, size: 26, color: Color(0xFF555E6D)),
            onPressed: () {
              if (Directionality.of(context) == TextDirection.ltr) {
                Scaffold.of(context).openDrawer();
              } else if (Directionality.of(context) == TextDirection.rtl) {
                Scaffold.of(context).openEndDrawer();
              }
            },
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Side Navigation
// ══════════════════════════════════════════════════════════════
class _SideNav extends StatelessWidget {
  const _SideNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),
          // ── User profile ─────────────────────────────────
          Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xFFDDE3EE),
                child: ClipOval(
                  child: Container(
                    width: 76,
                    height: 76,
                    color: const Color(0xFFB0BDD6),
                    child: const Icon(
                      Icons.person,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'فرع الرياض الرئيسي',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'متصل الآن',
                style: TextStyle(fontSize: 11, color: Color(0xFF8A94A6)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // ── Nav items ────────────────────────────────────
          _NavItem(icon: Icons.point_of_sale_outlined, label: 'نقطة البيع'),
          _NavItem(icon: Icons.list_alt_outlined, label: 'الطلبات'),
          _NavItem(icon: Icons.table_restaurant_outlined, label: 'الطاولات'),
          _NavItem(icon: Icons.bar_chart_outlined, label: 'التقارير'),
          const Spacer(),
          // ── Logout ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 28, right: 20, left: 20),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.logout, color: Color(0xFFE53935), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF555E6D), size: 22),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {},
          hoverColor: const Color(0xFFF0F4FF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          minLeadingWidth: 20,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Main Content
// ══════════════════════════════════════════════════════════════
class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Greeting ────────────────────────────────────
          const SizedBox(height: 20),
          const Text(
            'مرحباً بك، أحمد',
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
          // ── Action cards ────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // شاشة البيع
                Expanded(
                  child: _ActionCard(
                    icon: Icons.point_of_sale,
                    iconColor: const Color(0xFF8A94A6),
                    iconBg: const Color(0xFFDDE3EE),
                    title: 'شاشة البيع',
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
                const SizedBox(width: 24),
                // تسجيل الحضور
                Expanded(
                  child: _ActionCard(
                    icon: Icons.person_pin_rounded,
                    iconColor: Colors.white,
                    iconBg: const Color(0xFF2563EB),
                    title: 'تسجيل الحضور',
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
          // ── Status bar ──────────────────────────────────
          _StatusBar(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Action Card
// ══════════════════════════════════════════════════════════════
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

// ══════════════════════════════════════════════════════════════
// Badge widget (link style or pill style)
// ══════════════════════════════════════════════════════════════
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

// ══════════════════════════════════════════════════════════════
// Status Bar (bottom)
// ══════════════════════════════════════════════════════════════
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
