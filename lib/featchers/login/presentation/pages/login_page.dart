import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:flutter/material.dart';

SignalRService mySignalRService = SignalRService();

class LoginPage extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const LoginPage({super.key, required this.changeLanguage});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // if (SizeConfig.screenWidth! <= 600) {
    return LoginMobileScreen(changeLanguage: widget.changeLanguage);
  }
}
