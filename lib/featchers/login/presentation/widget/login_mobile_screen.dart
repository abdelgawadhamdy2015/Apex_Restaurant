// ignore_for_file: use_build_context_synchronously

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/shared/widgets/my_progress_indicator.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_event.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_state.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_bloc_listener.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final theme = Theme.of(context);
    lang = S.of(context);
    selectedLanguage = Intl.defaultLocale == RestaurantConstants.arabic
        ? lang.arabic
        : lang.english;

    return PopScope(
      canPop: finish,
      onPopInvokedWithResult: _handlePop,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeader(context), _buildLoginForm(context)],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePop(bool didPop, dynamic result) {
    if (didPop) {
      HelperMethods.exitApp();
    } else {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).exitApp,
        isError: false,
      );
      setState(() => finish = true);
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => finish = false),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double dpr = mediaQuery.devicePixelRatio;
    final double logoW = mediaQuery.size.width * 0.48;
    final double logoH = mediaQuery.size.height * 0.08;

    return SizedBox(
      height: mediaQuery.size.height * 0.2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Assets.images.apexLogo.image(
                width: logoW,
                // color: theme.colorScheme.onPrimary,
                cacheWidth: (logoW * dpr).round(),
                cacheHeight: (logoH * dpr).round(),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // _buildLanguageDropdown(context),
        ],
      ),
    );
  }

  // Widget _buildLanguageDropdown(BuildContext context) {
  //   final theme = Theme.of(context);

  //   return DropdownButton<String>(
  //     value: selectedLanguage,
  //     icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onPrimary),
  //     dropdownColor: Colors.transparent,
  //     borderRadius: BorderRadius.circular(12),
  //     underline: const SizedBox(),
  //     onChanged: (String? newValue) {
  //       if (newValue != null) {
  //         setState(() {
  //           selectedLanguage = newValue;
  //           widget.changeLanguage(
  //             selectedLanguage == lang.arabic
  //                 ? const Locale("ar")
  //                 : const Locale("en"),
  //           );
  //         });
  //       }
  //     },
  //     items: [S.of(context).english, lang.arabic].map((value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(
  //           value,
  //           style: theme.textTheme.titleMedium?.copyWith(
  //             color: theme.colorScheme.onPrimary,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildLoginForm(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final spacing = context.spacing;
    return SizedBox(
      height: mediaQuery.size.height * 0.8,
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Form(
            key: context.read<AuthBloc>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildLoginTitle(context),
                const SizedBox(height: 16),

                _buildTextField(
                  context,
                  lang.email,
                  context.read<AuthBloc>().emailController,
                  lang.insertEmail,
                ),
                _buildTextField(
                  context,
                  lang.password,
                  context.read<AuthBloc>().passwordController,
                  lang.insertPassword,
                  obsecure: true,
                ),
                _buildTextField(
                  context,
                  lang.dbName,
                  context.read<AuthBloc>().dbController,
                  lang.insertDBName,
                ),
                //   _buildRememberAndForget(context),
                const SizedBox(height: 8),
                _buildLoginButton(context),
                SizedBox(height: spacing.lg),
                _buildForgetPasswordLink(context),
                AuthBlocListener(rememberMe: rememberMe),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        lang.login,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Now relies entirely on the app's InputDecorationTheme + textTheme
  /// (defined in AppTheme) instead of passing custom fill colors, hint
  /// styles or input styles per field.
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
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: obsecure ?? false,
            decoration: InputDecoration(
              hintText: hint,
              fillColor: theme.colorScheme.onSurface,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildRememberAndForget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildRememberCheckbox(context),
              const SizedBox(width: 12),
              Text(
                lang.rememberMe,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          _buildForgetPasswordLink(context),
        ],
      ),
    );
  }

  Widget _buildRememberCheckbox(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => rememberMe = !rememberMe),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline, width: 2),
          borderRadius: BorderRadius.circular(6),
          color: rememberMe ? theme.colorScheme.primary : Colors.transparent,
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 20,
          height: 20,
          child: rememberMe
              ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary)
              : null,
        ),
      ),
    );
  }

  Widget _buildForgetPasswordLink(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: InkWell(
        onTap: () {
          // context.read<AuthBloc>().formKey.currentState!.reset();
          // context.pushNamed(Routes.forgetPasswordScreen);
        },
        child: Text(
          lang.forgetPassword,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return !context.read<AuthBloc>().loadingLogin
            ? AppButtonText(
                backgroundColor: theme.colorScheme.primary,
                padding: EdgeInsets.zero,
                width: double.infinity,
                buttonText: lang.login,
                icon: Icons.check_circle_outline,
                onPressed: () => _validateThenLogin(context),
                textStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
