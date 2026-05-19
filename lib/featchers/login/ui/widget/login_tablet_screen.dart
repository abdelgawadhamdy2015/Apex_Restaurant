// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:ttech_attendance/core/helpers/constants.dart';
// import 'package:ttech_attendance/core/helpers/extensions.dart';
// import 'package:ttech_attendance/core/helpers/helper_methods.dart';
// import 'package:ttech_attendance/core/helpers/shared_pref_helper.dart';
// import 'package:ttech_attendance/core/theming/size_config.dart';
// import 'package:ttech_attendance/core/routing/routes.dart';
// import 'package:ttech_attendance/core/services/signal_r_service.dart';
// import 'package:ttech_attendance/core/theming/colors.dart';
// import 'package:ttech_attendance/core/theming/font_weight_helper.dart';
// import 'package:ttech_attendance/core/theming/text_styles.dart';
// import 'package:ttech_attendance/core/widgets/app_text_button.dart';
// import 'package:ttech_attendance/core/widgets/body_container.dart';
// import 'package:ttech_attendance/core/widgets/grediant_container.dart';
// import 'package:ttech_attendance/core/widgets/indicator/my_progress_indicator.dart';
// import 'package:ttech_attendance/core/widgets/mytextfile.dart';
// import 'package:ttech_attendance/featchers/login/logic/cubit/login_cubit.dart';
// import 'package:ttech_attendance/featchers/login/logic/cubit/login_state.dart';
// import 'package:ttech_attendance/featchers/login/ui/widget/login_bloc_listener.dart';
// import 'package:ttech_attendance/gen/assets.gen.dart';
// import 'package:ttech_attendance/generated/l10n.dart';
// import 'package:ttech_attendance/core/settings/location_aware.dart';

// SignalRService mySignalRService = SignalRService();

// class LoginTabletScreen extends StatefulWidget {
//   final Function(Locale) changeLanguage;

//   const LoginTabletScreen({super.key, required this.changeLanguage});

//   @override
//   LoginTabletScreenState createState() => LoginTabletScreenState();
// }

// class LoginTabletScreenState extends State<LoginTabletScreen> {
//   bool rememberMe = false;
//   late String selectedLanguage;
//   bool finish = false;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     await SharedPrefHelper.removeData(MyConstants.myToken);
//     context.read<LoginCubit>().dbController.text =
//         await SharedPrefHelper.getString(MyConstants.loggedDBName);
//     context.read<LoginCubit>().emailController.text =
//         await SharedPrefHelper.getString(MyConstants.loggedUserName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     selectedLanguage = Intl.defaultLocale == MyConstants.arabic
//         ? S.of(context).arabic
//         : S.of(context).english;

//     return PopScope(
//       canPop: finish,
//       onPopInvokedWithResult: _handlePop,
//       child: LocationAwareWidget(
//         child: Scaffold(
//           body: GradientContainer(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeader(),
//                   _buildLoginForm(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handlePop(bool didPop, dynamic result) {
//     if (didPop) {
//       HelperMethods.exitApp(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(S.of(context).exitApp),
//             duration: const Duration(seconds: 1)),
//       );
//       setState(() => finish = true);
//       Future.delayed(
//           const Duration(seconds: 2), () => setState(() => finish = false));
//     }
//   }

//   Widget _buildHeader() {
//     return SizedBox(
//       height: SizeConfig.screenHeight! * .2,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Center(
//             child: Padding(
//               padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .01),
//               child: Assets.images.apexTime.image(
//                 width: SizeConfig.defaultSize! * 20,
//                 color: ColorManger.lightGray,
//                 cacheWidth: ((SizeConfig.defaultSize! * 20) *
//                         SizeConfig.devicePixelRatio!)
//                     .round(),
//                 cacheHeight: ((SizeConfig.defaultSize! * 8) *
//                         SizeConfig.devicePixelRatio!)
//                     .round(),
//               ),
//             ),
//           ),
//           _buildLanguageDropdown(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLanguageDropdown() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: DropdownButton<String>(
//         value: selectedLanguage,
//         icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//         dropdownColor: Colors.transparent,
//         // borderRadius: BorderRadius.circular(20.r),
//         style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize2!),
//         underline: const SizedBox(),
//         onChanged: (String? newValue) {
//           if (newValue != null) {
//             setState(() {
//               selectedLanguage = newValue;
//               widget.changeLanguage(
//                 selectedLanguage == S.of(context).arabic
//                     ? const Locale("ar")
//                     : const Locale("en"),
//               );
//             });
//           }
//         },
//         items: [S.of(context).english, S.of(context).arabic].map((value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value,
//                 style: TextStyles.whiteBoldStyle(SizeConfig.fontSize1!)),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return SizedBox(
//       height: SizeConfig.screenHeight! * .8,
//       child: BodyContainer(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: SizeConfig.defaultSize!),
//           child: Form(
//             key: context.read<LoginCubit>().formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildLoginTitle(),
//                 _buildTextField(
//                     S.of(context).dbName,
//                     context.read<LoginCubit>().dbController,
//                     S.of(context).insertDBName),
//                 _buildTextField(
//                     S.of(context).email,
//                     context.read<LoginCubit>().emailController,
//                     S.of(context).insertEmail),
//                 _buildTextField(
//                     S.of(context).insertPassword,
//                     context.read<LoginCubit>().passwordController,
//                     S.of(context).password,
//                     obsecure: true),
//                 _buildRememberAndForget(),
//                 HelperMethods.verticalSpacing(.01),
//                 _buildLoginButton(),
//                 LoginBlocListener(rememberMe: rememberMe),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginTitle() {
//     return Center(
//       child: Text(
//         S.of(context).login,
//         style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, TextEditingController controller, String hint,
//       {bool? obsecure}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.screenWidth! * .016,
//         vertical: SizeConfig.screenHeight! * .016,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label,
//               style: TextStyles.blackMediumStyle(SizeConfig.fontSize2!)),
//           HelperMethods.verticalSpacing(.01),
//           MyTextForm(
//             hight: SizeConfig.defaultSize! * 5,
//             inputTextStyle: TextStyles.blackBoldStyle(SizeConfig.fontSize2!),
//             hintStyle: TextStyles.blackRegulerStyle(SizeConfig.fontSize2!),
//             fillColor: ColorManger.lightGray,
//             hint: hint,
//             excep: label,
//             obsecure: obsecure,
//             controller: controller,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRememberAndForget() {
//     return Padding(
//       padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildRememberCheckbox(),
//               HelperMethods.horizontalSpacing(.03),
//               Text(S.of(context).rememberMe,
//                   style: TextStyles.blackRegulerStyle(SizeConfig.fontSize2!)),
//             ],
//           ),
//           _buildForgetPasswordLink(),
//         ],
//       ),
//     );
//   }

//   Widget _buildRememberCheckbox() {
//     return GestureDetector(
//       onTap: () => setState(() => rememberMe = !rememberMe),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: ColorManger.gray, width: 2),
//           borderRadius: BorderRadius.circular(10),
//           color: rememberMe ? ColorManger.radioButtonBlue : Colors.transparent,
//         ),
//         padding: const EdgeInsets.all(4),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           width: 40,
//           height: 40,
//           child: rememberMe
//               ? const Icon(Icons.check, size: 40, color: Colors.white)
//               : null,
//         ),
//       ),
//     );
//   }

//   Widget _buildForgetPasswordLink() {
//     return InkWell(
//       onTap: () {
//         context.read<LoginCubit>().formKey.currentState!.reset();
//         context.pushNamed(Routes.forgetPasswordSccreen);
//       },
//       child: ShaderMask(
//         shaderCallback: (bounds) =>
//             ColorManger.mainBlueGrediant.createShader(bounds),
//         child: Text(
//           S.of(context).forgetPassword,
//           style: TextStyle(
//             fontFamily: MyConstants.cairoFont,
//             fontWeight: FontWeightHelper.medium,
//             color: Colors.white,
//             decoration: TextDecoration.underline,
//             fontSize: SizeConfig.fontSize3!,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginButton() {
//     return BlocBuilder<LoginCubit, LoginState>(
//       builder: (context, state) {
//         return !context.read<LoginCubit>().loadingLogin
//             ? AppButtonText(
//                 verticalPadding: 0,
//                 buttonHeight: SizeConfig.defaultSize! * 4,
//                 linearGradient: ColorManger.mainBlueGrediant,
//                 butonText: S.of(context).login,
//                 onPressed: () => _validateThenLogin(context),
//                 textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize2!),
//               )
//             : MyProgressIndicator(
//                 scale: SizeConfig.screenHeight! * .0005,
//               );
//       },
//     );
//   }

//   void _validateThenLogin(BuildContext context) {
//     if (context.read<LoginCubit>().formKey.currentState!.validate()) {
//       context.read<LoginCubit>().emitLoginStates();
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
