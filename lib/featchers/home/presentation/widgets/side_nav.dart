import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
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

    final theme = Theme.of(context);
    final avatarSize = MediaQuery.sizeOf(context).width * 0.1;

    return Material(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 32),

            // User profile
            Column(
              children: [
                CircleAvatar(
                  radius: avatarSize / 2,
                  child: ClipOval(
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: theme.colorScheme.onSurfaceVariant,
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          state.userDataModel?.employees?.arabicName ?? "",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.userDataModel?.isActive == true
                              ? lang.active
                              : lang.notActive,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

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
              padding: const EdgeInsets.only(bottom: 24, right: 20, left: 20),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.logout,
                      color: theme.colorScheme.error,
                      size: 24,
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
    final theme = Theme.of(context);
    final msg = _selected.languageCode == 'ar'
        ? 'تم تغيير اللغة إلى العربية ✓'
        : 'Language changed to English ✓';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: theme.colorScheme.onSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(strings.language, style: theme.textTheme.titleMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._languages.map(
                (lang) => _LanguageTile(
                  option: lang,
                  isSelected:
                      _selected.languageCode == lang.locale.languageCode,
                  onTap: () => setState(() => _selected = lang.locale),
                ),
              ),
              const SizedBox(height: 4),
              Divider(height: 24, color: theme.dividerColor),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        side: BorderSide(color: theme.dividerColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        strings.cancel,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        strings.apply,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: .08)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: .15)
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(option.flag, style: theme.textTheme.titleLarge),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.nativeName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
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
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Icon(
            icon,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onTap: onTap,
          hoverColor: theme.scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          minLeadingWidth: 20,
        ),
      ),
    );
  }
}
