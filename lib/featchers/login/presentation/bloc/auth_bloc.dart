import 'package:apex_restaurant/core/helpers/crashlytics_logger.dart';
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';
import 'package:apex_restaurant/featchers/login/domain/usecases/auth_usecase.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_event.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;

  AuthBloc({required this._loginUsecase}) : super(const AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dbController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool loadingLogin = false;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    loadingLogin = true;

    try {
      final response = await _loginUsecase(
        LoginRequest(
          username: emailController.text,
          password: passwordController.text,
          companyName: dbController.text,
          isLoginFromMobile: false,
          //fcmToken: FCMService.fcmToken,
        ),
      );

      response.when(
        success: (loginResponse) async {
          emit(AuthState.success(loginResponse));
          loadingLogin = false;
        },
        failure: (error) async {
          emit(
            AuthState.error(
              error:
                  "Code: ${error.apiErrorModel.code} , ${error.getLocalizedMessage()}",
            ),
          );

          loadingLogin = false;
        },
      );
    } catch (error, stackTrace) {
      await CrashlyticsLogger.logError(
        screen: "Login",
        error: error,
        stackTrace: stackTrace,
      );

      emit(AuthState.error(error: RestaurantConstants.unexpectedError));

      loadingLogin = false;
    }
  }
}
