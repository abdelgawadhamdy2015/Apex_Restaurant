import 'package:apex_restaurant/core/shared/widgets/body_container.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyContainer(
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.all(10),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.noWifi.image(
                  width: MediaQuery.of(context).size.width * .5,
                ),
                Text(
                  S.of(context).noInternet + S.of(context).waiting,
                  textAlign: TextAlign.center,
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       context.pushNamed(Routes.loginScreen);
                //     },
                //     child: Text(S.of(context).logout))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
