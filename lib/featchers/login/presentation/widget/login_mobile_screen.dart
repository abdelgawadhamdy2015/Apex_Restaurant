// ignore_for_file: use_build_context_synchronously

import 'package:apex_restaurant/core/helpers/app_string.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/shared/widgets/body_container.dart';
import 'package:apex_restaurant/core/shared/widgets/grediant_container.dart';
import 'package:apex_restaurant/core/shared/widgets/my_progress_indicator.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/core/theme/font_weight_helper.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_event.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_state.dart';

import 'package:apex_restaurant/featchers/login/presentation/widget/login_bloc_listener.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

SignalRService mySignalRService = SignalRService();

class LoginMobileScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const LoginMobileScreen({super.key, required this.changeLanguage});

  @override
  State<LoginMobileScreen> createState() => LoginMobileScreenState();
}

class LoginMobileScreenState extends State<LoginMobileScreen> {
  bool rememberMe = false;
  late String selectedLanguage;
  bool finish = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Future<void> _initData() async {
    await SharedPrefHelper.removeData(RestaurantConstants.myToken);

    context.read<AuthBloc>().dbController.text =
        await SharedPrefHelper.getString(RestaurantConstants.loggedDBName);

    context.read<AuthBloc>().emailController.text =
        await SharedPrefHelper.getString(RestaurantConstants.loggedUserName);
  }

  @override
  Widget build(BuildContext context) {
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? AppStrings.current.arabic
        : AppStrings.current.english;

    return PopScope(
      canPop: finish,
      onPopInvokedWithResult: _handlePop,
      child: Scaffold(
        body: GradientContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeader(), _buildLoginForm()],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePop(bool didPop, dynamic result) {
    if (didPop) {
      HelperMethods.exitApp(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).exitApp),
          duration: const Duration(seconds: 1),
        ),
      );

      setState(() => finish = true);

      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => finish = false),
      );
    }
  }

  Widget _buildHeader() {
    return SizedBox(
      height: SizeConfig.screenHeight! * .2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .01),
              child: Assets.images.apexTime.image(
                width: SizeConfig.defaultSize! * 20,
                color: AppColors.white,
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

  Widget _buildLoginForm() {
    return SizedBox(
      height: SizeConfig.screenHeight! * .8,
      child: BodyContainer(
        child: SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Form(
              key: context.read<AuthBloc>().formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HelperMethods.verticalSpacing(.02),

                  _buildLoginTitle(),

                  HelperMethods.verticalSpacing(.02),

                  _buildTextField(
                    AppStrings.current.dbName,
                    context.read<AuthBloc>().dbController,
                    AppStrings.current.insertDBName,
                  ),

                  _buildTextField(
                    AppStrings.current.email,
                    context.read<AuthBloc>().emailController,
                    AppStrings.current.insertEmail,
                  ),

                  _buildTextField(
                    AppStrings.current.insertPassword,
                    context.read<AuthBloc>().passwordController,
                    AppStrings.current.password,
                    obsecure: true,
                  ),

                  _buildRememberAndForget(),

                  HelperMethods.verticalSpacing(.01),

                  _buildLoginButton(),

                  AuthBlocListener(rememberMe: rememberMe),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTitle() {
    return Center(
      child: Text(
        AppStrings.current.login,
        style: TextStyles.blackBoldStyle(
          fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
        ),
      ),
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
              fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
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
            fillColor: AppColors.white,
            hint: hint,
            excep: label,
            obsecure: obsecure,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildRememberAndForget() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildRememberCheckbox(),

              HelperMethods.horizontalSpacing(.03),

              Text(
                AppStrings.current.rememberMe,
                style: TextStyles.blackRegulerStyle(
                  fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
                ),
              ),
            ],
          ),
          _buildForgetPasswordLink(),
        ],
      ),
    );
  }

  Widget _buildRememberCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => rememberMe = !rememberMe),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textSecondary, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: rememberMe ? AppColors.primaryLight : Colors.transparent,
        ),
        padding: const EdgeInsets.all(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 20,
          height: 20,
          child: rememberMe
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  Widget _buildForgetPasswordLink() {
    return InkWell(
      onTap: () {
        context.read<AuthBloc>().formKey.currentState!.reset();

        context.pushNamed(Routes.forgetPasswordScreen);
      },
      child: ShaderMask(
        shaderCallback: (bounds) =>
            ColorManger.mainBlueGrediant.createShader(bounds),
        child: Text(
          AppStrings.current.forgetPassword,
          style: TextStyle(
            fontFamily: RestaurantConstants.cairoFont,
            fontWeight: FontWeightHelper.medium,
            color: Colors.white,
            decoration: TextDecoration.underline,
            fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return !context.read<AuthBloc>().loadingLogin
            ? AppButtonText(
                linearGradient: ColorManger.mainBlueGrediant,
                butonText: AppStrings.current.login,
                onPressed: () => _validateThenLogin(context),
                textStyle: TextStyles.whiteBoldStyle(
                  fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
                ),
              )
            : MyProgressIndicator(scale: SizeConfig.screenHeight! * .0005);
      },
    );
  }

  void _validateThenLogin(BuildContext context) {
    if (context.read<AuthBloc>().formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(const AuthEvent.loginSubmitted());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
