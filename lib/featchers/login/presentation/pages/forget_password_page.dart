import 'package:apex_restaurant/core/helpers/app_string.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/shared/widgets/body_container.dart';
import 'package:apex_restaurant/core/shared/widgets/grediant_container.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool lang = true;
  late String selectedLanguage;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? AppStrings.current.arabic
        : AppStrings.current.english;

    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(
                height: SizeConfig.screenHeight! * .8,
                child: BodyContainer(
                  child: Form(key: formKey, child: _buildForm()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: SizeConfig.screenHeight! * .2,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textPrimary,
                    size: SizeConfig.iconSize2!,
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
                      padding: EdgeInsets.only(
                        top: SizeConfig.screenHeight! * .01,
                      ),
                      child: Assets.images.apexTime.image(
                        width: SizeConfig.defaultSize! * 20,
                        color: AppColors.textSecondary,
                        cacheWidth:
                            ((SizeConfig.defaultSize! * 20) *
                                    SizeConfig.devicePixelRatio!)
                                .round(),
                        cacheHeight:
                            ((SizeConfig.defaultSize! * 8) *
                                    SizeConfig.devicePixelRatio!)
                                .round(),
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
      borderRadius: BorderRadius.circular(20.r),
      style: TextStyles.darkBlueBoldStyle(
        fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
      ),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedLanguage = newValue;
            widget.changeLanguage(
              selectedLanguage == AppStrings.current.arabic
                  ? const Locale("ar")
                  : const Locale("en"),
            );
          });
        }
      },
      items: [S.of(context).english, AppStrings.current.arabic].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyles.whiteBoldStyle(
              fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
            ),
          ),
        );
      }).toList(),
    );
  }

  myLogoText() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        AppStrings.current.forgetPassword,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: myLogoText()),
        _buildTextField(
          AppStrings.current.dbName,
          companyText,
          AppStrings.current.dbName,
        ),
        _buildTextField(
          S.of(context).email,
          emailText,
          AppStrings.current.email,
        ),
        HelperMethods.verticalSpacing(.02),
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
        horizontal: SizeConfig.screenWidth! * .016,
        vertical: SizeConfig.screenHeight! * .016,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.blackMediumStyle(
              fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
            ),
          ),
          HelperMethods.verticalSpacing(.01),
          MyTextForm(
            hight: SizeConfig.defaultSize! * 5,
            inputTextStyle: TextStyles.blackBoldStyle(
              fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
            ),
            hintStyle: TextStyles.blackRegulerStyle(
              fontSize: AppTheme.theme.textTheme.bodySmall!.fontSize!,
            ),
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
      butonText: AppStrings.current.send,
      onPressed: () => _validateThenLogin(context),
      textStyle: TextStyles.whiteBoldStyle(
        fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
      ),
    );
  }

  void _validateThenLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // context.read<ForgetPasswordCubit>().emitForgetPasswordStates(
      //   company: companyText.text,
      //   email: emailText.text,
      // );
    }
  }
}
