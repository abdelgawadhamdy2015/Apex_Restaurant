// ignore_for_file: use_build_context_synchronously

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
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_event.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_state.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_bloc_listener.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late S lang;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
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
    lang = S.of(context);
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? lang.arabic
        : lang.english;

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
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    final double logoW = AppSizes.wFraction(0.48);
    final double logoH = AppSizes.hFraction(0.08);

    return SizedBox(
      height: AppSizes.hFraction(0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: AppPadding.allLg,
              child: Assets.images.apexTime.image(
                width: logoW,
                color: AppColors.white,
                cacheWidth: (logoW * dpr).round(),
                cacheHeight: (logoH * dpr).round(),
              ),
            ),
          ),
          AppSizes.gapW24,
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
      borderRadius: BorderRadius.circular(AppRadius.xl),
      style: AppFonts.displayMedium.colored(AppColors.primaryDark).bold(),
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
            style: AppFonts.displayLarge.colored(AppColors.white).bold(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoginForm() {
    return SizedBox(
      height: AppSizes.hFraction(0.8),
      child: BodyContainer(
        child: SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Form(
              key: context.read<AuthBloc>().formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapH16,
                  _buildLoginTitle(),
                  AppSizes.gapH16,
                  _buildTextField(
                    lang.dbName,
                    context.read<AuthBloc>().dbController,
                    lang.insertDBName,
                  ),
                  _buildTextField(
                    lang.email,
                    context.read<AuthBloc>().emailController,
                    lang.insertEmail,
                  ),
                  _buildTextField(
                    lang.insertPassword,
                    context.read<AuthBloc>().passwordController,
                    lang.password,
                    obsecure: true,
                  ),
                  _buildRememberAndForget(),
                  AppSizes.gapH8,
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
        lang.login,
        style: AppFonts.displayLarge.colored(AppColors.textPrimary).bold(),
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
        horizontal: AppPadding.sm,
        vertical: AppPadding.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.displayMedium
                .colored(AppColors.textPrimary)
                .semiBold(),
          ),
          AppSizes.gapH8,
          MyTextForm(
            hight: AppSizes.inputHeight,
            inputTextStyle: AppFonts.displayMedium
                .colored(AppColors.textPrimary)
                .bold(),
            hintStyle: AppFonts.bodyLarge.colored(AppColors.textMuted),
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
      padding: EdgeInsets.only(top: AppPadding.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildRememberCheckbox(),
              AppSizes.gapW12,
              Text(
                lang.rememberMe,
                style: AppFonts.displayMedium.colored(AppColors.textPrimary),
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
          borderRadius: BorderRadius.circular(AppRadius.sm),
          color: rememberMe ? AppColors.primaryLight : Colors.transparent,
        ),
        padding: AppPadding.allXs,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: AppSizes.w20,
          height: AppSizes.h20,
          child: rememberMe
              ? Icon(Icons.check, size: AppSizes.iconSm, color: AppColors.white)
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
          lang.forgetPassword,
          style: AppFonts.displayMedium.copyWith(
            fontFamily: RestaurantConstants.cairoFont,
            fontWeight: FontWeightHelper.medium,
            color: AppColors.white,
            decoration: TextDecoration.underline,
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
                butonText: lang.login,
                onPressed: () => _validateThenLogin(context),
                textStyle: AppFonts.displayMedium
                    .colored(AppColors.white)
                    .bold(),
              )
            : const MyProgressIndicator(scale: 0.5);
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
