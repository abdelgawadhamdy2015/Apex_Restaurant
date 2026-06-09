import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;
  static double? fontSize1;
  static double? fontSize2;
  static double? fontSize4;
  static double? fontSize3;
  static double? fontSize5;
  static double? iconSize1;
  static double? iconSize2;
  static double? imageSize1;
  static double? devicePixelRatio;
  static bool isTablet = false;
  static double? textScaleFactor;
  void init(BuildContext context) {
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    orientation = MediaQuery.of(context).orientation;
    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * .024
        : screenWidth! * .024;
    isTablet = screenWidth! >= 600 ? true : false;
    textScaleFactor = (screenWidth! / 375.0).clamp(0.9, 1.3);
    // Check platform
    final bool isIOS = Platform.isIOS;
    final bool isAndroid = Platform.isAndroid;
    log("Platform is iOS: $isIOS, Platform is Android: $isAndroid");
    if (isIOS) {
      IOSSizes().init(screenWidth, defaultSize, isTablet);
    } else if (isAndroid) {
      AndroidSizes().init(screenWidth, defaultSize, isTablet);
    } else {
      // fallback for other platforms
      AndroidSizes().init(screenWidth, defaultSize, isTablet);
    }

    // fontSize1 = isTablet ? (defaultSize! * .2).sp : (screenWidth! * .02).sp;
    // fontSize2 = isTablet ? (defaultSize! * .3).sp : (screenWidth! * .03).sp;

    // fontSize3 = isTablet ? (defaultSize! * .25).sp : (screenWidth! * .04).sp;
    // fontSize4 = isTablet ? (defaultSize! * .4).sp : (screenWidth! * .05).sp;
    // fontSize5 = isTablet
    //     ? (defaultSize! * .7).sp
    //     : (MediaQuery.sizeOf(context).width * .06).sp;
    // iconSize1 = isTablet ? (defaultSize! * 1.5) : (screenWidth! * .05);
    // iconSize2 = isTablet ? (defaultSize! * 3) : (screenWidth! * .08);
    // imageSize1 = defaultSize! * 5;
    // log("width: $screenWidth , hieght: $screenHeight , textFactor: $textScaleFactor , defoultSize: $defaultSize");
  }

  getScreenPadding({double? horizintal, double? vertical}) {
    return EdgeInsets.only(
      right: isTablet
          ? defaultSize! * .5
          : SizeConfig.screenWidth! * (horizintal ?? .04),
      left: isTablet
          ? defaultSize! * .5
          : SizeConfig.screenWidth! * (horizintal ?? .04),
      top: SizeConfig.screenHeight! * (vertical ?? .01),
      bottom: defaultSize! * (vertical ?? .1),
    );
  }
}

class IOSSizes {
  init(double? screenWidth, double? defaultSize, bool isTablet) {
    SizeConfig.fontSize1 = isTablet
        ? (defaultSize! * .2).sp
        : (screenWidth! * .02).sp;
    SizeConfig.fontSize2 = isTablet
        ? (defaultSize! * .25).sp
        : (screenWidth! * .055).sp;
    SizeConfig.fontSize3 = isTablet
        ? (defaultSize! * .3).sp
        : (screenWidth! * .06).sp;
    SizeConfig.fontSize4 = isTablet
        ? (defaultSize! * .4).sp
        : (screenWidth! * .07).sp;
    SizeConfig.fontSize5 = isTablet
        ? (defaultSize! * .7).sp
        : (screenWidth! * .08).sp;
    SizeConfig.iconSize1 = (screenWidth! * .05);
    SizeConfig.iconSize2 = (screenWidth * .08);
    SizeConfig.imageSize1 = screenWidth * .12;
  }
}

class AndroidSizes {
  init(double? screenWidth, double? defaultSize, bool isTablet) {
    SizeConfig.fontSize1 = isTablet
        ? (defaultSize! * .2).sp
        : (screenWidth! * .02).sp;
    SizeConfig.fontSize2 = isTablet
        ? (defaultSize! * .25).sp
        : (screenWidth! * .045).sp;
    SizeConfig.fontSize3 = isTablet
        ? (defaultSize! * .3).sp
        : (screenWidth! * .05).sp;
    SizeConfig.fontSize4 = isTablet
        ? (defaultSize! * .4).sp
        : (screenWidth! * .055).sp;
    SizeConfig.fontSize5 = isTablet
        ? (defaultSize! * .7).sp
        : (screenWidth! * .07).sp;

    SizeConfig.iconSize1 = (screenWidth! * .05);
    SizeConfig.iconSize2 = (screenWidth * .08);
    SizeConfig.imageSize1 = screenWidth * .12;
  }
}
