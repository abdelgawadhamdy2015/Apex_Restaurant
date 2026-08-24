import '../../../../core/helpers/restaurant_constants.dart';
import '../../../../core/shared/widgets/app_text_button.dart';
import '../../../../core/shared/widgets/body_container.dart';
import '../../../../core/shared/widgets/grediant_container.dart';
import '../../../../core/shared/widgets/mytextfile.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ForgetPasswordPage extends StatefulWidget {
  final Function(Locale) changeLanguage;
  const ForgetPasswordPage({super.key, required this.changeLanguage});
  static const rout = '/forgetpassword';

  @override
  State<ForgetPasswordPage> createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController companyText = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String selectedLanguage;
  late S lang;

  @override
  void dispose() {
    companyText.dispose();
    emailText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? lang.arabic
        : lang.english;

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(
                height: mediaQuery.size.height * 0.8,
                child: BodyContainer(
                  child: Form(key: formKey, child: _buildForm(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final double dpr = mediaQuery.devicePixelRatio;
    final double logoW = mediaQuery.size.width * 0.48;
    final double logoH = mediaQuery.size.height * 0.08;

    return SizedBox(
      height: mediaQuery.size.height * 0.2,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurface,
                    size: 32,
                  ),
                ),
              ],
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Assets.images.logo.image(
                        width: logoW,
                        color: theme.colorScheme.onSurfaceVariant,
                        cacheWidth: (logoW * dpr).round(),
                        cacheHeight: (logoH * dpr).round(),
                      ),
                    ),
                  ),
                  _buildLanguageDropdown(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButton<String>(
      value: selectedLanguage,
      icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onPrimary),
      dropdownColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedLanguage = newValue;
            widget.changeLanguage(
              selectedLanguage == lang.arabic
                  ? const Locale("ar")
                  : const Locale("en"),
            );
          });
        }
      },
      items: [S.of(context).english, lang.arabic].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              lang.forgetPassword,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(context, lang.dbName, companyText, lang.dbName),
        _buildTextField(context, S.of(context).email, emailText, lang.email),
        const SizedBox(height: 16),
        Center(child: _buildLoginButton(context)),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint, {
    bool? obsecure,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          MyTextForm(
            hint: hint,
            excep: label,
            obsecure: obsecure,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final theme = Theme.of(context);

    return AppButtonText(
      linearGradient: LinearGradient(
        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      ),
      buttonText: lang.send,
      onPressed: () => _validateThenSend(context),
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _validateThenSend(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // context.read<ForgetPasswordCubit>().emitForgetPasswordStates(
      //   company: companyText.text,
      //   email: emailText.text,
      // );
    }
  }
}
