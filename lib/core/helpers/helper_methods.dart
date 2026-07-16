import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/shared/widgets/pos_toast.dart';
import 'package:apex_restaurant/core/shared/widgets/setup_dialog.dart';
import 'package:apex_restaurant/core/shared/widgets/toast_design.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

class HelperMethods {
  // ── Snackbar / Toast ───────────────────────────────────────────────────────

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  static void massageForAlert(
    String massage,
    bool failedData,
    FToast fToast, [
    String backPress = "",
  ]) {
    fToast.showToast(
      child: ToastDesign(
        massage: massage,
        failedData: failedData,
        backPress: backPress,
      ),
      gravity: backPress == "back" ? ToastGravity.BOTTOM : ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  // ── Auth ───────────────────────────────────────────────────────────────────

  static Future<void> logOut(BuildContext context) async {
    await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
    DioFactory.deletTokenHeaderAfterLogOut();
    RestaurantConstants.image = null;
    if (!context.mounted) return;
    context.pushReplacementNamed(
      Routes.loginScreen,
      extra: (Route<dynamic> route) => true,
    );
    mySignalRService.stopConnection();
  }

  // ── Error handling ─────────────────────────────────────────────────────────

  static void checkErroAndShowMessage(
    BaseResponse response,
    BuildContext context,
  ) {
    final message = Intl.defaultLocale == RestaurantConstants.arabic
        ? response.errorMessageAr ??
              response.alart?.messageAr ??
              S.of(context).noDataFound
        : response.errorMessageEn ??
              response.alart?.messageEn ??
              S.of(context).noDataFound;

    final isAuthError =
        (response.result == 0 &&
            response.errorMessageEn == RestaurantConstants.logOutMessage) ||
        response.result == 41;

    if (isAuthError) {
      showDialogState(context, message, route: Routes.loginScreen);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: ToastCard(message: message)));
    }
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  static String? validate(String value, BuildContext context, String expec) {
    if (value.isEmpty) {
      return "\u26A0 ${S.of(context).pleaseFill} $expec ";
    }
    return null;
  }

  static bool checkIfNull(List list) {
    return list.any((e) => e == null || e.toString().isEmpty);
  }

  // ── Formatting ─────────────────────────────────────────────────────────────

  static String? getFormattedTimeOfDay(String shift, BuildContext context) {
    if (shift.isEmpty || shift == "____") return null;
    final time = TimeOfDay(
      hour: int.parse(shift.split(":")[0].padLeft(2, "0")),
      minute: int.parse(shift.split(":")[1].padLeft(2, "0")),
    );
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  static DateTime? getDateTimeFromString(String shift) {
    if (shift.isEmpty || shift == "____") return null;
    return DateTime(
      0,
      0,
      0,
      int.parse(shift.split(":")[0].padLeft(2, "0")),
      int.parse(shift.split(":")[1].padLeft(2, "0")),
    );
  }

  static DateTime convertStringToTime(String shift) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(shift.split(":")[0]),
      int.parse(shift.split(":")[1]),
    );
  }

  static DateTime convertStringToDate(String dateString) =>
      DateTime.parse(dateString);

  static String getHours(String time, BuildContext context) {
    final t = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
    final mins = t.minute != 0 ? ": ${t.minute}" : "";
    return "${t.hour}$mins ${S.of(context).hours}";
  }

  static String getShift(int shift, BuildContext context) {
    switch (shift) {
      case 1:
        return S.of(context).shift1;
      case 2:
        return S.of(context).shift2;
      case 3:
        return S.of(context).shift3;
      case 4:
        return S.of(context).shift4;
      default:
        return "";
    }
  }

  static String getRequestType(int? type, BuildContext context) {
    switch (type) {
      case 1:
        return S.of(context).permission;
      case 2:
        return S.of(context).annual;
      default:
        return "";
    }
  }

  static String convertListToString(List data) =>
      data.map((e) => e.arabicName).join(", ");

  // ── Colors ─────────────────────────────────────────────────────────────────

  /// Now requires [context] to read the live `ColorScheme` instead of the
  /// static `AppColors` constants, so status colors follow the active theme
  /// (light/dark, seed color) instead of being fixed. `waiting`/`rejected`
  /// map onto real ColorScheme roles (`tertiary`/`error`); `approved` has no
  /// themed "success" role yet, so it stays a plain green with a TODO — same
  /// open item flagged in the toast/dialog/branches-list conversions.
  static Color getStatusColor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;

    switch (status) {
      case RestaurantConstants.waiting:
        return scheme.tertiary;
      case RestaurantConstants.approved:
        return Colors.green;
      case RestaurantConstants.rejected:
        return scheme.error;
      default:
        return Colors.grey;
    }
  }

  static bool containsModelWithId(List models, int targetId) =>
      models.any((model) => model.id == targetId);

  // ── Spacing ────────────────────────────────────────────────────────────────

  /// Plain fixed-size gaps — no more `SizeConfig`/ScreenUtil scaling.
  /// [height]/[width] are now taken as literal logical pixels.
  static SizedBox verticalSpacing(double height) => SizedBox(height: height);

  static SizedBox horizontalSpacing(double width) => SizedBox(width: width);

  // ── Widgets ────────────────────────────────────────────────────────────────

  /// Now requires [context]. Relies on the app's `InputDecorationTheme` and
  /// `textTheme` (via `MyTextForm`'s own theme-driven defaults) instead of
  /// the old `AppTheme.theme` / `TextStyles` statics and `SizeConfig`
  /// padding helper.
  static Widget buildEditText(
    BuildContext context,
    String label,
    TextEditingController controller, {
    Widget? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MyTextForm(
        icon: icon,
        enabled: false,
        labelText: label,
        controller: controller,
      ),
    );
  }

  // ── System ─────────────────────────────────────────────────────────────────

  static void exitApp() => SystemNavigator.pop();
}
