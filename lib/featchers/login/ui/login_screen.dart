import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/featchers/login/ui/widget/login_mobile_screen.dart';
import 'package:flutter/material.dart';

SignalRService mySignalRService = SignalRService();

class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const LoginScreen({super.key, required this.changeLanguage});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // if (SizeConfig.screenWidth! <= 600) {
    return LoginMobileScreen(changeLanguage: widget.changeLanguage);
  }
}
