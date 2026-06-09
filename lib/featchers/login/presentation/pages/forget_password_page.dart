import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/shared/widgets/body_container.dart';
import 'package:apex_restaurant/core/shared/widgets/grediant_container.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
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

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(
                height: AppSizes.hFraction(0.8),
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
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    final double logoW = AppSizes.wFraction(0.48);
    final double logoH = AppSizes.hFraction(0.08);

    return SizedBox(
      height: AppSizes.hFraction(0.2),
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
                    color: AppColors.textPrimary,
                    size: AppSizes.iconXl,
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
                      padding: EdgeInsets.only(top: AppPadding.sm),
                      child: Assets.images.apexTime.image(
                        width: logoW,
                        color: AppColors.textSecondary,
                        cacheWidth: (logoW * dpr).round(),
                        cacheHeight: (logoH * dpr).round(),
                      ),
                    ),
                  ),
                  _buildLanguageDropdown(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      dropdownColor: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      style: AppFonts.bodyMedium.colored(AppColors.primaryDark).bold(),
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
            style: AppFonts.bodyMedium.colored(AppColors.white).bold(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: AppPadding.sm),
            child: Text(
              lang.forgetPassword,
              style: AppFonts.titleLarge.colored(AppColors.textPrimary),
            ),
          ),
        ),
        AppSizes.gapH16,
        _buildTextField(lang.dbName, companyText, lang.dbName),
        _buildTextField(S.of(context).email, emailText, lang.email),
        AppSizes.gapH16,
        Center(child: _buildLoginButton()),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool? obsecure,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.sm,
        vertical: AppPadding.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.bodySmall.colored(AppColors.textPrimary).semiBold(),
          ),
          AppSizes.gapH8,
          MyTextForm(
            hight: AppSizes.inputHeight,
            inputTextStyle: AppFonts.bodyMedium
                .colored(AppColors.textPrimary)
                .bold(),
            hintStyle: AppFonts.bodySmall.colored(AppColors.textMuted),
            fillColor: AppColors.textSecondary,
            hint: hint,
            excep: label,
            obsecure: obsecure,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return AppButtonText(
      linearGradient: ColorManger.mainBlueGrediant,
      butonText: lang.send,
      onPressed: () => _validateThenSend(context),
      textStyle: AppFonts.bodyMedium.colored(AppColors.white).bold(),
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
