import 'dart:developer';

import 'package:apex_restaurant/core/helpers/app_string.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/shared/widgets/toast_design.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../generated/l10n.dart';

class HelperMethods {
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
    //fToast.removeCustomToast();
  }

  static Future<void> logOut(BuildContext context) async {
    await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
    DioFactory.deletTokenHeaderAfterLogOut();
    RestaurantConstants.image = null;
    // ignore: use_build_context_synchronously
    context.pushReplacementNamed(
      Routes.loginScreen,
      extra: (Route<dynamic> route) {
        return true;
      },
    );
    mySignalRService.stopConnection();
  }

  static bool checkIfNull(List list) {
    bool isNull = true;
    list.any(
      (e) => e == null || e.toString().isEmpty ? isNull = true : isNull = false,
    );
    return isNull;
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case RestaurantConstants.waiting:
        return AppColors.warning;
      case RestaurantConstants.approved:
        return AppColors.success;
      case RestaurantConstants.rejected:
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  static String getRequestType(int? type, BuildContext context) {
    switch (type) {
      case 1:
        return AppStrings.current.permission;
      case 2:
        return AppStrings.current.annual;
      default:
        return "";
    }
  }

  static bool containsModelWithId(List models, int targetId) {
    return models.any((model) => model.id == targetId);
  }

  static SizedBox verticalSpacing(double height) =>
      SizedBox(height: SizeConfig.screenHeight! * height.h);
  static SizedBox horizontalSpacing(double width) =>
      SizedBox(width: SizeConfig.screenWidth! * width.w);

  static String? getFormattedTimeOfDay(String shift, BuildContext context) {
    if (shift.isNotEmpty && shift != "____") {
      TimeOfDay shiftTime = TimeOfDay(
        hour: int.parse(shift.split(":")[0].padLeft(2, "0")),
        minute: int.parse(shift.split(":")[1].padLeft(2, "0")),
      );
      final localizations = MaterialLocalizations.of(context);
      String formattedTimeOfDay = localizations.formatTimeOfDay(shiftTime);
      return formattedTimeOfDay;
    } else {
      return null;
    }
  }

  static DateTime? getDateTimeFromString(String shift, BuildContext context) {
    if (shift.isNotEmpty && shift != "____") {
      TimeOfDay shiftTime = TimeOfDay(
        hour: int.parse(shift.split(":")[0].padLeft(2, "0")),
        minute: int.parse(shift.split(":")[1].padLeft(2, "0")),
      );

      return DateTime(0, 0, 0, shiftTime.hour, shiftTime.minute);
    } else {
      return null;
    }
  }

  static String getHours(String time, BuildContext context) {
    TimeOfDay shiftTime = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
    return "${shiftTime.hour} ${shiftTime.minute != 00 ? ": ${shiftTime.minute}" : ""} ${S.of(context).hours}";
  }

  static String getShift(int shift, BuildContext context) {
    switch (shift) {
      case 1:
        return AppStrings.current.shift1;
      case 2:
        return AppStrings.current.shift2;
      case 3:
        return AppStrings.current.shift3;
      case 4:
        return AppStrings.current.shift4;
    }
    return "";
  }

  static DateTime convertStringToTime(String shift) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(shift.split(":")[0]),
      int.parse(shift.split(":")[1]),
    );
  }

  static String? validate(String value, BuildContext context, String expec) {
    if (value.isEmpty) {
      return "\u26A0 ${S.of(context).pleaseFill} $expec ";
    } else {
      return null;
    }
  }

  // static bool checkFingerType(BuildContext context) {
  //   int? lastNonNullIndex;

  //   context.read<AttendanceCubit>().shifts.asMap().forEach((index, value) {
  //     if (value != null) {
  //       // Update the index each time we find a non-null value
  //       lastNonNullIndex = index;
  //     }
  //   });

  //   if (lastNonNullIndex == null || lastNonNullIndex! % 2 != 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static void popIfPossible(BuildContext context) {
    (didPop, result) {
      if (didPop) {
        if (result != null) {
          context.pushReplacementNamed(Routes.homeScreen);
          log("popIfPossible");
        }
      }
    };
  }

  static void exitApp(BuildContext context) {
    SystemNavigator.pop();
  }

  static Container buildEditText(
    String lable,
    TextEditingController controller, {
    Widget? icon,
  }) {
    return Container(
      padding: SizeConfig().getScreenPadding(vertical: .01),
      child: MyTextForm(
        icon: icon,
        enabled: false,
        fillColor: AppColors.white,
        labelText: lable,
        inputTextStyle: TextStyles.blackRegulerStyle(
          fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
        ),
        hintStyle: TextStyles.lighterGrayRegulerStyle(
          fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
        ),
        controller: controller,
      ),
    );
  }

  static String convertListToString(List data) {
    String result = "";
    for (var item in data) {
      result += "${item.arabicName}, ";
    }
    return result;
  }

  static DateTime convertStringToDate(String dateString) {
    return DateTime.parse(dateString);
  }

  // static String getRequestTypeName(VaccationModel departureModel) {
  //   return departureModel.vacation == null
  //       ? Intl.defaultLocale == MyConstants.arabic
  //             ? departureModel.vacation!.arabicName ?? ""
  //             : departureModel.vacation!.latinName ?? ""
  //       : Intl.defaultLocale == MyConstants.arabic
  //       ? departureModel.vacation!.arabicName ?? ""
  //       : departureModel.vacation!.latinName ?? "";
  // }

  // static String getPermissionTypeName(PermissionModel permissionModel) {
  //   return permissionModel.permissiontype == null
  //       ? Intl.defaultLocale == MyConstants.arabic
  //             ? permissionModel.permissiontype!.arabicName
  //             : permissionModel.permissiontype!.latinName
  //       : Intl.defaultLocale == MyConstants.arabic
  //       ? permissionModel.permissiontype!.arabicName
  //       : permissionModel.permissiontype!.latinName;
  // }
}
