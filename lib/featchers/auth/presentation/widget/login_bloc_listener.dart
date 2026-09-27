// ignore_for_file: use_build_context_synchronously

import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/auth/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/auth/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/auth/presentation/bloc/auth_state.dart';
import 'package:apex_restaurant/featchers/auth/presentation/pages/login_screen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      listenWhen: (_, curr) =>
          curr is Loading || curr is Success || curr is Error,
      listener: (context, state) {
        state.whenOrNull(
          success: (loginResponse) =>
              _onSuccess(context, loginResponse as BaseResponse<LoginData?>),
          error: (error) => _onError(context, error),
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Success
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onSuccess(
    BuildContext context,
    BaseResponse<LoginData?> response,
  ) async {
    context.read<AuthBloc>().loadingLogin = false;

    if (response.result != 1) {
      showAppDialog(
        context,
        type: AppDialogType.error,
        title: S.of(context).requestFailed,
        message: response.errorMessageAr ?? S.of(context).unexpectedError,
        confirmLabel: S.of(context).okDialog,
      );
      return;
    }

    final data = response.data;
    if (data == null) return;

    // ── Not a restaurant account ──────────────────────────────────────────
    if (data.isRestaurant == false) {
      showAppDialog(
        context,
        type: AppDialogType.warning,
        title: S.of(context).accessDenied,
        message: S.of(context).notRestaurantCompany,
        confirmLabel: S.of(context).okDialog,
      );
      return;
    }

    final token = data.authToken?.token ?? '';
    final userInfo = data.authToken?.userInfo;

    // ── SignalR — stop old connection then start fresh ────────────────────
    // Using the global instance ensures the old connection is always cleaned
    // up before we create a new one, regardless of how many times the user
    // logs in during this app session.
    await mySignalRService.stopConnection();
    await mySignalRService.startConnection(token);

    // ── Persist credentials ───────────────────────────────────────────────
    await Future.wait([
      SharedPrefHelper.setData(RestaurantConstants.myToken, token),
      SharedPrefHelper.setData(
        RestaurantConstants.loggedDBName,
        context.read<AuthBloc>().dbController.text,
      ),
      SharedPrefHelper.setData(
        RestaurantConstants.loggedUserName,
        userInfo?.userName ?? '',
      ),
      SharedPrefHelper.setData(
        RestaurantConstants.userId,
        int.parse(userInfo?.userId ?? '0'),
      ),
      SharedPrefHelper.setData(
        RestaurantConstants.empId,
        userInfo?.employeesId ?? '',
      ),
      SharedPrefHelper.setData(
        RestaurantConstants.imageUrl,
        data.authToken?.userInfo?.imageUrl,
      ),
      if (widget.rememberMe)
        SharedPrefHelper.setData(RestaurantConstants.isLoggedIn, true),
    ]);

    // ── In-memory state ───────────────────────────────────────────────────
    RestaurantConstants.permissions = data.permissions ?? [];
    RestaurantConstants.image = data.authToken?.userInfo?.imageUrl;
    ApiConstants.userId = int.parse(userInfo?.userId ?? '0');
    ApiConstants.empId = userInfo?.employeesId;
    DioFactory.setToken(token);

    // ── Navigate ──────────────────────────────────────────────────────────
    if (!context.mounted) return;
    context.goNamed(Routes.homeScreen);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Error
  // ─────────────────────────────────────────────────────────────────────────

  void _onError(BuildContext context, String error) {
    context.read<AuthBloc>().loadingLogin = false;
    showAppDialog(
      context,
      type: AppDialogType.error,
      title: S.of(context).requestFailed,
      message: error,
      confirmLabel: S.of(context).okDialog,
    );
  }
}
