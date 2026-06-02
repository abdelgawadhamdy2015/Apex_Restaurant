import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
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
    //super.initState();
    // Add a delay before navigating to the main screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2));
      context.pushReplacement(Routes.loginScreen);
    });
    //get_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Assets.images.apexTime.image(fit: BoxFit.contain),
              SizedBox(height: 16.h, width: double.infinity),
              Text(
                versionNumberOfApp,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
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
//     var lang = S.of(context);
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
