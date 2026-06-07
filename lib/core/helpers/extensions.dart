import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:intl/intl.dart';

extension AlertMessageExt on BaseResponse {
  String getLocalizedMessage({bool isSuccess = false}) {
    final isArabic = Intl.defaultLocale == RestaurantConstants.arabic;

    return isArabic
        ? alart?.messageAr ??
              (isSuccess
                  ? "تم الحفظ بنجاح"
                  : "فشل الحفظ. يرجى المحاولة مرة أخرى.")
        : alart?.messageEn ??
              (isSuccess
                  ? "Saved successfully"
                  : "Failed to save. Please try again.");
  }
}

extension ErrorMessageExt on ErrorHandler {
  String getLocalizedMessage() {
    final isArabic = Intl.defaultLocale == RestaurantConstants.arabic;

    return isArabic
        ? apiErrorModel.errorMessageAr ?? "حدث خطأ ما"
        : apiErrorModel.errorMessageEn ?? "An error occurred";
  }
}
