// Side Navigation
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Material(
      child: Container(
        width: SizeConfig.screenWidth! * 0.4,
        color: AppColors.background,
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xxxl),
            // ── User profile
            Column(
              children: [
                CircleAvatar(
                  radius: AppRadius.full,
                  //  backgroundColor:,
                  child: ClipOval(
                    child: Container(
                      width: SizeConfig.screenWidth! * .1,
                      height: SizeConfig.screenWidth! * .1,
                      color: AppColors.textMuted,
                      child: Icon(
                        Icons.person,
                        size: AppTheme.theme.iconTheme.size,
                        color: AppColors.priceBadgeText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            state.userDataModel?.employees?.arabicName ?? "",
                            style: TextStyles.darkBlueRegulerStyle(
                              fontSize:
                                  AppTheme.theme.textTheme.bodySmall!.fontSize!,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          (state.userDataModel?.isActive == true)
                              ? lang.active
                              : lang.notActive,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xxl),
            // ── Nav items
            _NavItem(
              icon: Icons.home_sharp,
              label: lang.home,
              onTap: () => context.goNamed(Routes.homeScreen),
            ),
            _NavItem(
              icon: Icons.point_of_sale_outlined,
              label: lang.pos,
              onTap: () => context.goNamed(Routes.posScreen),
            ),
            _NavItem(
              icon: Icons.list_alt_outlined,
              label: lang.requests,
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.table_restaurant_outlined,
              label: lang.tables,
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.bar_chart_outlined,
              label: lang.reports,
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.language_outlined,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.logout,
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
                    ? AppColors.selectedColor
                    : AppColors.unSelectedColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  option.flag,
                  style: TextStyle(fontSize: SizeConfig.fontSize3),
                ),
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
                      fontSize: SizeConfig.fontSize5,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    option.nativeName,
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize4,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
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
                width: SizeConfig.screenWidth! * .05,
                height: SizeConfig.screenHeight! * .05,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: SizeConfig.iconSize1! * .5,
                  color: AppColors.background,
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
          leading: Icon(
            icon,
            color: AppColors.textSecondary,
            size: SizeConfig.iconSize1,
          ),
          title: Text(
            label,
            style: TextStyles.blackMediumStyle(
              fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          onTap: onTap,
          hoverColor: AppColors.background,
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
