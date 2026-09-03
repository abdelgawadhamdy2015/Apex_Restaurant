// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

import 'restaurant_constants.dart';
import 'shared_prf_helper.dart';
import '../router/routes.dart';
import '../service/dio_factory.dart';
import '../shared/model/base_response.dart';
import '../shared/widgets/mytextfile.dart';
import '../shared/widgets/pos_toast.dart';
import '../shared/widgets/setup_dialog.dart';
import '../shared/widgets/toast_snack_bar.dart';
import '../../featchers/cart/data/models/pos_client_model.dart';
import '../../featchers/cart/presentation/bloc/cart_bloc.dart';
import '../../featchers/cart/presentation/bloc/cart_event.dart';
import '../../featchers/cart/presentation/ui/widgets/customer_picker_sheet.dart';
import '../../featchers/auth/presentation/pages/login_screen.dart';
import '../../featchers/pos/data/models/category_model.dart';
import '../../featchers/pos/domain/entities/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

class HelperMethods {
  static bool anyItemHasDiscount(List<OrderItem> items) {
    return items.any((item) => item.discount > 0);
  }

  /// Helper to send raw PDF file/bytes or PDF URL directly to the printing service
  static Future<void> printDirectPdf(
    BuildContext context,
    dynamic pdfSource,
    String jobName,
  ) async {
    if (pdfSource == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: "No PDF file available to print",
        isError: true,
      );
      return;
    }

    try {
      Uint8List? pdfBytes;

      if (pdfSource is Uint8List) {
        pdfBytes = pdfSource;
      } else if (pdfSource is File) {
        pdfBytes = await pdfSource.readAsBytes();
      } else if (pdfSource is String) {
        final uri = Uri.tryParse(pdfSource);

        // 1. Web / Remote URL
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          final response = await http.get(uri);
          if (response.statusCode == 200) {
            pdfBytes = response.bodyBytes;
          } else {
            HelperMethods.showSnackBar(
              context: context,
              message: "Failed to download PDF (${response.statusCode})",
              isError: true,
            );
            return;
          }
        }
        // 2. Local File Path
        else if (pdfSource.startsWith('/')) {
          final file = File(pdfSource);
          if (await file.exists()) {
            pdfBytes = await file.readAsBytes();
          }
        }
        // 3. Base64 String
        else {
          pdfBytes = base64Decode(pdfSource);
        }
      }

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes!,
          name: jobName,
        );
      } else {
        HelperMethods.showSnackBar(
          context: context,
          message: "Could not read PDF file bytes.",
          isError: true,
        );
      }
    } catch (e) {
      HelperMethods.showSnackBar(
        context: context,
        message: "Error printing file: $e.",
        isError: true,
      );
    }
  }

  static Future<void> openPicker(
    BuildContext context,
    List<PosClientModel> persons,
  ) async {
    final cartBloc = context.read<CartBloc>();
    final picked = await showModalBottomSheet<PosClientModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CustomerPickerSheet(persons: persons),
    );
    if (picked != null) {
      cartBloc.add(SelectPersonEvent(picked));
    }
  }

  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';

    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Helper method to merge two lists of addons without duplicating identical ones
  static List<AdditiveModel> mergeAddons(
    List<AdditiveModel> existingAddons,
    List<AdditiveModel> newAddons,
  ) {
    final List<AdditiveModel> merged = List.from(existingAddons);

    for (final addon in newAddons) {
      // Avoid duplicate addon entries
      if (!merged.contains(addon)) {
        merged.add(addon);
      }
    }

    return merged;
  }
  // ── Snackbar / Toast ───────────────────────────────────────────────────────

  static void showSnackBar({
    required BuildContext context,
    required String message,
    required bool isError,
  }) {
    TopSnackBar.show(context: context, message: message, isError: isError);
  }

  // ── Auth ───────────────────────────────────────────────────────────────────

  static Future<void> logOut(BuildContext context) async {
    await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
    DioFactory.clearToken();
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
              response.alert?.messageAr ??
              S.of(context).noDataFound
        : response.errorMessageEn ??
              response.alert?.messageEn ??
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
