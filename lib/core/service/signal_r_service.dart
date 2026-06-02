import 'dart:developer';

import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/api_error_model.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SignalRService {
  HubConnection? hubConnection;
  // LocalNotificationService localNotificationService =
  //     LocalNotificationService();
  SignalRService();
  Future<void> startConnection(String token) async {
    //localNotificationService.initNotification();
    hubConnection = HubConnectionBuilder()
        .withUrl(
          '${ApiConstants.baseUsrl}NotificationHub',
          options: HttpConnectionOptions(accessTokenFactory: () async => token),
        )
        .build();
    await hubConnection?.start();
    hubConnection!.on(RestaurantConstants.logoutNotification, (message) async {
      List? listMessage = message;
      Map<String, dynamic> map = listMessage!.first;
      ApiErrorModel apiErrorModel = ApiErrorModel.fromJson(map);
      try {
        setupResendRequestDialogState(
          navigatorKey.currentContext!,
          Intl.defaultLocale == RestaurantConstants.arabic
              ? apiErrorModel.errorMessageAr!
              : apiErrorModel.errorMessageEn!,
          [S.of(navigatorKey.currentContext!).okDialog],
          () {
            HelperMethods.logOut(navigatorKey.currentContext!);
          },
          SvgPicture.asset(Assets.alert),
        );
        stopConnection();
      } catch (error) {}
    });

    hubConnection!.on(RestaurantConstants.pushNotification, (message) async {
      List? listMessage = message;
      Map<String, dynamic> map = listMessage!.first;
      ApiErrorModel apiErrorModel = ApiErrorModel.fromJson(map);
      try {
        setupResendRequestDialogState(
          navigatorKey.currentContext!,
          Intl.defaultLocale == RestaurantConstants.arabic
              ? apiErrorModel.errorMessageAr!
              : apiErrorModel.errorMessageEn!,
          [S.of(navigatorKey.currentContext!).okDialog],
          () {
            HelperMethods.logOut(navigatorKey.currentContext!);
          },
          SvgPicture.asset(Assets.alert),
        );
        stopConnection();
      } catch (error) {
        log(error.toString());
      }
    });
    // final NotificationService notificationService = NotificationService();

    // hubConnection?.on("LogoutNotification", (arguments) {
    //   String messageTitle = "New Notification";
    //   String messageBody = arguments?[0] ?? "No content";

    //   // إظهار الإشعار
    //   notificationService.showNotification(messageTitle, messageBody);
    // });

    mySignalRService = this;
  }

  void stopConnection() {
    hubConnection?.stop();
    hubConnection!.state == HubConnectionState.Disconnected
        ? print("signalRService stopped")
        : print("signalRService ${hubConnection!.state}");
  }

  void listenToMessages(Function(String) onMessageReceived) {
    hubConnection?.on('LogoutNotification', (arguments) {
      final user = arguments![0] as ApiErrorModel;
      // final message = arguments[1] as String;
      onMessageReceived(user.errorMessageEn!);
    });
  }

  Future<void> sendMessage(String user, String message) async {
    await hubConnection?.invoke('SendMessage', args: [user, message]);
  }
}
