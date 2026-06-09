import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show Intl;

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
        width: AppSizes.wFraction(0.4),
        color: AppColors.background,
        child: Column(
          children: [
            AppSizes.gapH32,

            // User profile
            Column(
              children: [
                CircleAvatar(
                  radius: AppRadius.full,
                  child: ClipOval(
                    child: Container(
                      width: AppSizes.wFraction(0.1),
                      height: AppSizes.wFraction(0.1),
                      color: AppColors.textMuted,
                      child: Icon(
                        Icons.person,
                        size: AppSizes.iconLg,
                        color: AppColors.priceBadgeText,
                      ),
                    ),
                  ),
                ),
                AppSizes.gapH16,
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          state.userDataModel?.employees?.arabicName ?? "",
                          style: AppFonts.titleLarge.colored(
                            AppColors.primaryDark,
                          ),
                        ),
                        AppSizes.gapH8,
                        Text(
                          state.userDataModel?.isActive == true
                              ? lang.active
                              : lang.notActive,
                          style: AppFonts.titleSmall.colored(AppColors.accent),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            AppSizes.gapH24,

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
              onTap: () => _showLanguageDialog(context),
            ),

            const Spacer(),

            Padding(
              padding: EdgeInsets.only(
                bottom: AppPadding.xxl,
                right: AppPadding.xl,
                left: AppPadding.xl,
              ),
              child: GestureDetector(
                onTap: () => showLogOutDialogState(context, lang.logout, [
                  lang.okDialog,
                  lang.cancel,
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.logout,
                      style: AppFonts.titleMedium.colored(AppColors.error),
                    ),
                    AppSizes.gapW8,
                    Icon(
                      Icons.logout,
                      color: AppColors.error,
                      size: AppSizes.iconLg,
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
    widget.changeLanguage(_selected);
    Navigator.of(context).pop();
    _showToast(context);
  }

  void _showToast(BuildContext context) {
    final msg = _selected.languageCode == 'ar'
        ? 'تم تغيير اللغة إلى العربية ✓'
        : 'Language changed to English ✓';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: AppPadding.allXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(strings.language, style: AppFonts.titleMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: AppPadding.allXs,
                      decoration: BoxDecoration(
                        color: AppColors.unSelectedColor,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: AppSizes.iconMd,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH16,
              ..._languages.map(
                (lang) => _LanguageTile(
                  option: lang,
                  isSelected:
                      _selected.languageCode == lang.locale.languageCode,
                  onTap: () => setState(() => _selected = lang.locale),
                ),
              ),
              AppSizes.gapH4,
              const Divider(height: 24, color: AppColors.divider),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: EdgeInsets.symmetric(vertical: AppPadding.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(strings.cancel, style: AppFonts.titleLarge),
                    ),
                  ),
                  AppSizes.gapW8,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: AppPadding.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        strings.apply,
                        style: AppFonts.titleLarge.colored(AppColors.white),
                      ),
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
        margin: EdgeInsets.only(bottom: AppPadding.sm),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarActive : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.w40,
              height: AppSizes.h40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.selectedColor
                    : AppColors.unSelectedColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(option.flag, style: AppFonts.titleLarge),
              ),
            ),
            AppSizes.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: AppFonts.titleLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.gapH4,
                  Text(
                    option.nativeName,
                    style: AppFonts.titleSmall.colored(
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: AppSizes.w24,
                height: AppSizes.h24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconSm,
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
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.lg,
          vertical: AppPadding.xs,
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColors.textSecondary,
            size: AppSizes.iconMd,
          ),
          title: Text(
            label,
            style: AppFonts.titleLarge
                .colored(AppColors.textPrimary)
                .semiBold(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          onTap: onTap,
          hoverColor: AppColors.background,
          contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.md),
          minLeadingWidth: AppSizes.w20,
        ),
      ),
    );
  }
}
