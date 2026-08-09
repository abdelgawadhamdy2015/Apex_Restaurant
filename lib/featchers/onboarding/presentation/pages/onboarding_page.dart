import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = false;
  String versionNumberOfApp = "";
  Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        context.pushReplacement(Routes.loginScreen);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Assets.images.apexLogo.image(fit: BoxFit.contain),
              SizedBox(height: 16.h, width: double.infinity),
              Text(
                versionNumberOfApp,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: context.spacing.md),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// class UpdateDialog extends StatelessWidget {
//   final String? appLink;
//   final String? oldVersion;
//   final String? newVersion;
//   UpdateDialog({Key? key, this.appLink, this.oldVersion, this.newVersion})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var lang =AppStrings.current;
//     return AlertDialog(
//       title: Text(
//         lang.appUpdate,
//         style: TextStyle(
//           fontSize: 21.sp,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       content: Text(
//         "${lang.updateMassageFirst} $newVersion ${lang.updateMassageSecond} $oldVersion",
//         style: TextStyle(fontSize: 18.sp, color: Colors.black),
//       ),
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               onTap: () {
//                 //openLink(Uri.parse(appLink!));
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.r),
//                   color: basicColor,
//                 ),
//                 height: 40.h,
//                 width: 100.w,
//                 child: Center(
//                   child: Text(
//                     lang.update,
//                     style: TextStyle(fontSize: 20.sp, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// Future<void> openLink(Uri url) async {
//   if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
//     print('uld not launch $url');
//   }
