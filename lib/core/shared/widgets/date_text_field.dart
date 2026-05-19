import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class DateTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool? isDate;

  const DateTextField({
    super.key,
    this.label,
    required this.controller,
    required this.onTap,
    this.isDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Text(
                label!,
                style: TextStyles.lighterGrayBoldStyle(SizeConfig.fontSize2!),
              )
            : SizedBox.shrink(),
        label != null ? HelperMethods.verticalSpacing(.01) : SizedBox.shrink(),
        MyTextForm(
          textAllign: TextAlign.center,
          contentPadding: EdgeInsets.only(
            right: SizeConfig.screenWidth! * .003,
          ),
          hintStyle: TextStyles.blackRegulerStyle(SizeConfig.fontSize2!),
          inputTextStyle: TextStyles.lighterGrayBoldStyle(
            SizeConfig.fontSize2!,
            fontFamily: RestaurantConstants.droidArabicKufi,
          ),
          fillColor: ColorManger.whiteColor,
          readOnly: true,
          excep: label,
          suffixIcon: Icon(
            isDate! ? Icons.calendar_today : Icons.access_time,
            size: SizeConfig.iconSize1!,
          ),
          controller: controller,
          onTab: onTap,
        ),
      ],
    );
  }
}
