import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/service/signal_r_service.dart';
import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/featchers/login/ui/widget/login_mobile_screen.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

void setupDialogState(
  BuildContext context,
  dynamic data, {
  Widget? icon,
  String? route,
  String? departureType,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: ApiConstants.dioExceptionType == DioExceptionType.badResponse
          ? SvgPicture.asset(Assets.closing)
          : icon,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: data is String
                ? Text(
                    data,
                    style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
                    textAlign: TextAlign.center,
                  )
                : data,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButtonText(
                horizontalPadding: 0,
                verticalPadding: 0,
                linearGradient: ColorManger.mainBlueGrediant,
                borderRadius: SizeConfig.screenWidth! * .02,
                buttonHeight: SizeConfig.screenHeight! * .06,
                textStyle: TextStyles.whiteRegulerStyle(SizeConfig.fontSize3!),
                butonText: S.of(context).okDialog,
                onPressed: () async {
                  context.pop();
                  if (ApiConstants.dioExceptionType ==
                      DioExceptionType.badResponse) {
                    ApiConstants.dioExceptionType = DioExceptionType.unknown;
                    await SharedPrefHelper.setData(
                      RestaurantConstants.myToken,
                      "",
                    );
                    DioFactory.deletTokenHeaderAfterLogOut();
                    // ignore: use_build_context_synchronously
                    if (!context.mounted) return;
                    context.pushReplacementNamed(Routes.loginScreen);
                  } else if (ApiConstants.dioExceptionType ==
                      DioExceptionType.connectionTimeout) {
                    return;
                  } else {
                    if (route == null) {
                      context.pushNamed(Routes.homeScreen);
                    } else if (route != Routes.loginScreen &&
                        route != RestaurantConstants.previousRoute) {
                      context.pushReplacementNamed(route, extra: departureType);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void setupLogOutDialogState(
  BuildContext context,
  String data,
  List<String> actions,
) {
  showDialog(
    context: navigatorKey.currentContext ?? context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.logout_outlined, color: Colors.amber, size: 32),
      content: Text(
        textAlign: TextAlign.center,
        data,
        style: TextStyles.blackBoldStyle(SizeConfig.fontSize3 ?? 10),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            actions.length > 1
                ? TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      actions[1],
                      style: TextStyles.blackBoldStyle(
                        SizeConfig.fontSize3 ?? 10,
                      ),
                    ),
                  )
                : Container(),
            actions.length > 1 ? const Spacer() : Container(),
            TextButton(
              onPressed: () async {
                context.pop();

                await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
                DioFactory.deletTokenHeaderAfterLogOut();
                if (!context.mounted) return;
                context.pushReplacementNamed(Routes.loginScreen);
                mySignalRService.stopConnection();
              },
              child: Text(
                actions[0],
                style: TextStyles.blackBoldStyle(SizeConfig.fontSize3 ?? 10),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void setupResendRequestDialogState(
  BuildContext context,
  String data,
  List<String> actions,
  Function() oKButtonClick,
  Widget icon, {
  Function()? cancelClick,
}) {
  showDialog(
    context: navigatorKey.currentContext ?? context,
    builder: (BuildContext dialogContext) => AlertDialog(
      icon: icon,
      content: Text(
        textAlign: TextAlign.center,
        data,
        style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButtonText(
                horizontalPadding: 0,
                verticalPadding: 0,
                linearGradient: ColorManger.mainBlueGrediant,
                borderRadius: SizeConfig.screenWidth! * .02,
                buttonHeight: SizeConfig.screenHeight! * .06,
                textStyle: TextStyles.whiteRegulerStyle(SizeConfig.fontSize3!),
                butonText: actions[0],
                onPressed: () {
                  oKButtonClick();
                },
              ),
            ),
            if (actions.length > 1) HelperMethods.horizontalSpacing(.01),
            if (actions.length > 1)
              Expanded(
                child: AppButtonText(
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  backGroundColor: ColorManger.lighterGray,
                  borderRadius: SizeConfig.screenWidth! * .02,
                  buttonHeight: SizeConfig.screenHeight! * .06,
                  textStyle: TextStyles.whiteRegulerStyle(
                    SizeConfig.fontSize3!,
                  ),
                  butonText: actions[1],
                  onPressed: (cancelClick != null)
                      ? cancelClick
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

void showFingerprintDialog(
  BuildContext context, {
  bool success = true,
  required String data,
  required List<String> actions,
  Function()? onclick,
}) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: ColorManger.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight! * .05,
          horizontal: SizeConfig.screenWidth! * .02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            success
                ? SvgPicture.asset(Assets.success)
                : SvgPicture.asset(Assets.error),
            HelperMethods.verticalSpacing(.03),

            Text(
              data,
              style: TextStyles.blackMediumStyle(SizeConfig.fontSize3!),
              textAlign: TextAlign.center,
            ),

            HelperMethods.verticalSpacing(.03),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (actions.length > 1)
                  Expanded(
                    child: AppButtonText(
                      verticalPadding: 0,
                      horizontalPadding: 0,
                      backGroundColor: ColorManger.redButtonColor,
                      borderRadius: SizeConfig.screenWidth! * .02,
                      buttonHeight: SizeConfig.screenHeight! * .06,
                      icon: Icons.replay,
                      textStyle: TextStyles.whiteRegulerStyle(
                        SizeConfig.fontSize3!,
                      ),
                      butonText: S.of(context).retry,
                      onPressed: () {
                        onclick!();
                      },
                    ),
                  ),
                // if (actions.length > 1) HelperMethods.horizontalSpacing(.01),
                Expanded(
                  child: AppButtonText(
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    linearGradient: ColorManger.mainBlueGrediant,
                    borderRadius: SizeConfig.screenWidth! * .02,
                    buttonHeight: SizeConfig.screenHeight! * .06,
                    icon: Icons.home_sharp,
                    textStyle: TextStyles.whiteRegulerStyle(
                      SizeConfig.fontSize3!,
                    ),
                    butonText: S.of(context).home,
                    onPressed: () {
                      context.pushReplacementNamed(Routes.homeScreen);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
