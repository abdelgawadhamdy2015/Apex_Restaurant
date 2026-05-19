// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $ImagesGen {
  const $ImagesGen();

  /// File path: images/apex_time.png
  AssetGenImage get apexTime => const AssetGenImage('images/apex_time.png');

  /// File path: images/logo.svg
  String get logo => 'images/logo.svg';

  /// File path: images/money.png
  AssetGenImage get money => const AssetGenImage('images/money.png');

  /// File path: images/no-wifi.png
  AssetGenImage get noWifi => const AssetGenImage('images/no-wifi.png');

  /// File path: images/small_apex_time.png
  AssetGenImage get smallApexTime =>
      const AssetGenImage('images/small_apex_time.png');

  /// List of all assets
  List<dynamic> get values => [apexTime, logo, money, noWifi, smallApexTime];
}

class Assets {
  const Assets._();

  static const String time = 'assets/Time.svg';
  static const String airFleight = 'assets/air_fleight.svg';
  static const String alert = 'assets/alert.svg';
  static const String ball = 'assets/ball.svg';
  static const String branch = 'assets/branch.svg';
  static const String checked = 'assets/checked.svg';
  static const String closing = 'assets/closing.svg';
  static const String code = 'assets/code.svg';
  static const String credit = 'assets/credit.svg';
  static const String date = 'assets/date.svg';
  static const String department = 'assets/department.svg';
  static const String detailedReport = 'assets/detailed_report.svg';
  static const String edit = 'assets/edit.svg';
  static const String error = 'assets/error.svg';
  static const String eye = 'assets/eye.svg';
  static const String group = 'assets/group.svg';
  static const String id = 'assets/id.svg';
  static const String info = 'assets/info.svg';
  static const String job = 'assets/job.svg';
  static const AssetGenImage loadingGif = AssetGenImage('assets/loading.gif');
  static const String loadingJson = 'assets/loading.json';
  static const String login = 'assets/login.svg';
  static const String logout = 'assets/logout.svg';
  static const String mail = 'assets/mail.svg';
  static const AssetGenImage manPng = AssetGenImage('assets/man.png');
  static const String manSvg = 'assets/man.svg';
  static const String manger = 'assets/manger.svg';
  static const String mobile = 'assets/mobile.svg';
  static const String myRequest = 'assets/my_request.svg';
  static const String notification = 'assets/notification.svg';
  static const String overallReport = 'assets/overall_report.svg';
  static const String permission = 'assets/permission.svg';
  static const String permissionReport = 'assets/permission_report.svg';
  static const String person = 'assets/person.svg';
  static const String print = 'assets/print.svg';
  static const String question = 'assets/question.svg';
  static const String religion = 'assets/religion.svg';
  static const String reports = 'assets/reports.svg';
  static const String section = 'assets/section.svg';
  static const String shift = 'assets/shift.svg';
  static const String status = 'assets/status.svg';
  static const String success = 'assets/success.svg';
  static const String vaccationsReport = 'assets/vaccations_report.svg';
  static const $ImagesGen images = $ImagesGen();

  /// List of all assets
  static List<dynamic> get values => [
    time,
    airFleight,
    alert,
    ball,
    branch,
    checked,
    closing,
    code,
    credit,
    date,
    department,
    detailedReport,
    edit,
    error,
    eye,
    group,
    id,
    info,
    job,
    loadingGif,
    loadingJson,
    login,
    logout,
    mail,
    manPng,
    manSvg,
    manger,
    mobile,
    myRequest,
    notification,
    overallReport,
    permission,
    permissionReport,
    person,
    print,
    question,
    religion,
    reports,
    section,
    shift,
    status,
    success,
    vaccationsReport,
  ];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
