// ignore_for_file: use_build_context_synchronously

import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/presentation/providers/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/presentation/providers/auth_state.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AuthBlocListener extends StatefulWidget {
  final bool rememberMe;

  const AuthBlocListener({super.key, required this.rememberMe});

  @override
  State<AuthBlocListener> createState() => _AuthBlocListenerState();
}

class _AuthBlocListenerState extends State<AuthBlocListener> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is Loading || current is Success || current is Error;
      },
      listener: (context, state) {
        state.whenOrNull(
          success: (loginResponse) async {
            BaseResponse<LoginData> response = loginResponse;

            context.read<AuthBloc>().loadingLogin = false;

            if (response.result == 1) {
              /// SignalR
              SignalRService().startConnection(
                response.data!.authToken!.token!,
              );

              /// Save Token
              await SharedPrefHelper.setData(
                RestaurantConstants.myToken,
                response.data!.authToken!.token!,
              );

              /// Save Permissions
              RestaurantConstants.permissions =
                  response.data?.premissions ?? [];

              /// Save DB Name
              await SharedPrefHelper.setData(
                RestaurantConstants.loggedDBName,
                context.read<AuthBloc>().dbController.text,
              );

              /// Save Username
              await SharedPrefHelper.setData(
                RestaurantConstants.loggedUserName,
                response.data!.authToken!.userInfo!.userName!,
              );

              /// Set Dio Token
              DioFactory.setTokenToHeaderAfterLogin(
                response.data!.authToken!.token!,
              );

              /// User Data
              ApiConstants.userId = int.parse(
                response.data!.authToken!.userInfo!.userId!,
              );

              ApiConstants.empId =
                  response.data!.authToken!.userInfo!.employeesId!;

              /// Save UserId
              await SharedPrefHelper.setData(
                RestaurantConstants.userId,
                int.parse(response.data!.authToken!.userInfo!.userId!),
              );

              /// Save EmployeeId
              await SharedPrefHelper.setData(
                RestaurantConstants.empId,
                response.data!.authToken!.userInfo!.employeesId!,
              );

              /// Save Image
              RestaurantConstants.image =
                  response.data?.authToken?.userInfo?.imageUrl;

              await SharedPrefHelper.setData(
                RestaurantConstants.imageUrl,
                response.data?.authToken?.userInfo?.imageUrl,
              );

              /// Remember Me
              if (widget.rememberMe) {
                await SharedPrefHelper.setData(
                  RestaurantConstants.isLoggedIn,
                  true,
                );
              }

              /// Navigate
              context.pushReplacementNamed(Routes.homeScreen);
            } else {
              setupDialogState(
                context,
                response.errorMessageAr!,
                route: Routes.loginScreen,
                icon: SvgPicture.asset(Assets.error),
              );
            }
          },

          /// Error State
          error: (error) {
            context.read<AuthBloc>().loadingLogin = false;

            setupDialogState(
              context,
              error,
              route: Routes.loginScreen,
              icon: SvgPicture.asset(Assets.error),
            );
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
