import 'dart:developer';

import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/router.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/api_error_model.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';

class SignalRService {
  HubConnection? _hubConnection;

  // ── Public getter so callers can check state without touching internals ───
  HubConnectionState? get state => _hubConnection?.state;
  final transportProtLogger = Logger("SignalR - transport");

  // ─────────────────────────────────────────────────────────────────────────
  // Start
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> startConnection(String token) async {
    // ── Stop any existing connection before creating a new one ─────────────
    await stopConnection();

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          '${ApiConstants.baseUsrl}NotificationHub',
          options: HttpConnectionOptions(accessTokenFactory: () async => token),
        )
        .withAutomaticReconnect() // ← reconnects on transient drops
        .build();
    // ── Register handlers BEFORE starting so no message is missed ──────────
    _registerHandlers();

    try {
      await _hubConnection!.start();
      log('SignalR connected — state: ${_hubConnection?.state?.name}');
      log('Connected ID: ${_hubConnection?.connectionId}');

      // ── Assign global AFTER successful start ──────────────────────────────
      mySignalRService = this;
    } catch (e) {
      log('SignalR start failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Handlers — registered before start() so nothing is missed
  // ─────────────────────────────────────────────────────────────────────────

  void _registerHandlers() {
    // ── Logout notification (server forces sign-out) ───────────────────────
    _hubConnection?.on(RestaurantConstants.logoutNotification, (
      messages,
    ) async {
      log('logoutNotification received: $messages');
      final model = _parseMessage(messages);
      if (model == null) return;

      final context = AppRouter.navigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      final message = _localised(model);
      showAppDialog(
        context,
        type: AppDialogType.error,
        title: _localisedTitle(),
        message: message,
        confirmLabel: _localisedConfirm(),
        onConfirm: () {
          context.pop();
          // logout is handled inside showAppDialog / checkErroAndShowMessage
        },
      );

      await stopConnection();
    });

    // ── Push notification (informational server message) ──────────────────
    _hubConnection?.on(RestaurantConstants.pushNotification, (messages) async {
      log('pushNotification received: $messages');
      final model = _parseMessage(messages);
      if (model == null) return;

      final context = AppRouter.navigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      showAppDialog(
        context,
        type: AppDialogType.info,
        title: _localisedTitle(),
        message: _localised(model),
        confirmLabel: _localisedConfirm(),
      );
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Stop
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> stopConnection() async {
    if (_hubConnection == null) return;
    try {
      await _hubConnection!.stop();
      log('SignalR stopped — state: ${_hubConnection?.state?.name}');
    } catch (e) {
      log('SignalR stop error: $e');
    }
    _hubConnection = null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Send
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> sendMessage(String user, String message) async {
    if (_hubConnection?.state != HubConnectionState.Connected) {
      log('SignalR sendMessage skipped — not connected');
      return;
    }
    try {
      await _hubConnection!.invoke('SendMessage', args: [user, message]);
    } catch (e) {
      log('SignalR sendMessage error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Safely parses the first item in the SignalR message list.
  ApiErrorModel? _parseMessage(List<dynamic>? messages) {
    try {
      final map = messages?.first as Map<String, dynamic>?;
      if (map == null) return null;
      return ApiErrorModel.fromJson(map);
    } catch (e) {
      log('SignalR _parseMessage error: $e');
      return null;
    }
  }

  String _localised(ApiErrorModel model) =>
      Intl.defaultLocale == RestaurantConstants.arabic
      ? model.errorMessageAr ?? ''
      : model.errorMessageEn ?? '';

  // These return plain strings so SignalRService has no BuildContext dependency.
  // Replace with your actual string constants or pass a context if you prefer.
  String _localisedTitle() => Intl.defaultLocale == RestaurantConstants.arabic
      ? 'إشعار'
      : 'Notification';

  String _localisedConfirm() =>
      Intl.defaultLocale == RestaurantConstants.arabic ? 'حسناً' : 'OK';
}
