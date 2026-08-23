import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/restaurant_constants.dart';
import '../../../../core/service/api_result.dart';
import '../../data/models/login_request_body.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';
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
          isLoginFromMobile: true,
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
    } catch (error) {
      emit(AuthState.error(error: RestaurantConstants.unexpectedError));

      loadingLogin = false;
    }
  }
}
