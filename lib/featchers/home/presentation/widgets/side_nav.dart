// Side Navigation
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show Intl;

// ignore: must_be_immutable
class SideNav extends StatefulWidget {
  const SideNav({super.key, required this.changeLanguage});
  final Function(Locale) changeLanguage;

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  late String selectedLanguage;
  late S lang;
  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? lang.arabic
        : lang.english;
    return Container(
      width: SizeConfig.screenWidth! * 0.4, // 25% of screen width
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),
          // ── User profile
          Column(
            children: [
              CircleAvatar(
                radius: AppRadius.full,
                backgroundColor: const Color(0xFFDDE3EE),
                child: ClipOval(
                  child: Container(
                    width: 76,
                    height: 76,
                    color: const Color(0xFFB0BDD6),
                    child: Icon(
                      Icons.person,
                      size: AppTheme.theme.iconTheme.size,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'فرع الرياض الرئيسي',
                  style: TextStyles.darkBlueRegulerStyle(
                    fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
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
          // ── Nav items
          _NavItem(
            icon: Icons.home_sharp,
            label: 'الصفحة الرئيسية',
            onTap: () => context.goNamed(Routes.homeScreen),
          ),
          _NavItem(
            icon: Icons.point_of_sale_outlined,
            label: 'نقطة البيع',
            onTap: () => context.goNamed(Routes.posScreen),
          ),
          _NavItem(
            icon: Icons.list_alt_outlined,
            label: 'الطلبات',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.table_restaurant_outlined,
            label: 'الطاولات',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.bar_chart_outlined,
            label: 'التقارير',
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.bar_chart_outlined,
            label: selectedLanguage,
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Spacer(),
          // ── Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 28, right: 20, left: 20),
            child: GestureDetector(
              onTap: () {
                setupLogOutDialogState(context, lang.logout, [
                  lang.okDialog,
                  lang.cancel,
                ]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'تسجيل الخروج',
                    style: TextStyles.lightRedRegulerStyle(
                      fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.logout,
                    color: Color(0xFFE53935),
                    size: AppTheme.theme.iconTheme.size,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ChangeLanguageDialog(
        currentLocale: Locale(Intl.defaultLocale!),
        changeLanguage: widget.changeLanguage,
      ),
    );
  }
}

class ChangeLanguageDialog extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) changeLanguage;

  const ChangeLanguageDialog({
    super.key,
    required this.currentLocale,
    required this.changeLanguage,
  });

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  late Locale _selected;

  static const _languages = [
    _LanguageOption(
      locale: Locale('en'),
      flag: '🇺🇸',
      name: 'English',
      nativeName: 'English',
    ),
    _LanguageOption(
      locale: Locale('ar'),
      flag: '🇸🇦',
      name: 'Arabic',
      nativeName: 'العربية',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLocale;
  }

  void _apply() {
    setState(() {});
    widget.changeLanguage(_selected);
    Navigator.of(context).pop();
    _showToast(context);
  }

  void _showToast(BuildContext context) {
    final isArabic = _selected.languageCode == 'ar';
    final msg = isArabic
        ? 'تم تغيير اللغة إلى العربية ✓'
        : 'Language changed to English ✓';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF1A1A1A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    S strings = S.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    strings.language,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language options
              ..._languages.map(
                (lang) => _LanguageTile(
                  option: lang,
                  isSelected:
                      _selected.languageCode == lang.locale.languageCode,
                  onTap: () => setState(() => _selected = lang.locale),
                ),
              ),

              const SizedBox(height: 4),
              const Divider(height: 24, color: Color(0xFFEEEEEE)),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF666666),
                        side: const BorderSide(color: Color(0xFFDDDDDD)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(strings.cancel),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF378ADD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(strings.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Language tile ────────────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F1FB) : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF378ADD)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Flag circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB5D4F4)
                    : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(option.flag, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF0C447C)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.nativeName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? const Color(0xFF185FA5)
                          : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF378ADD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _LanguageOption {
  final Locale locale;
  final String flag;
  final String name;
  final String nativeName;

  const _LanguageOption({
    required this.locale,
    required this.flag,
    required this.name,
    required this.nativeName,
  });
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
            style: TextStyles.blackMediumStyle(
              fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: onTap,
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
