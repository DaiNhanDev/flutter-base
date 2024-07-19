import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_context.dart';
import '../../constants/app_images.dart';
import '../../constants/screens.dart';
import '../../constants/strings.dart';
import '../../global/app_routing.dart';
import '../../global/localization.dart';
import '../../widgets/button/x_link_button.dart';
import '../../widgets/text/x_text.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() {
    return _LandingScreenState();
  }
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Container(
        color: context.cardColor,
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            SizedBox(
              height: 120,
              child: Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(AppImagesAsset.appIcon),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              child: Center(
                child: XText.headlineSmall(
                  AppConstants.AppSologan,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  XLinkButton(
                    title: S.of(context).translate(Strings.Button.signIn),
                    onPressed: () {
                      AppRouting().pushReplacementNamed(Screens.logIn);
                    },
                  ),
                  const Spacer(),
                  XLinkButton(
                    title: S.of(context).translate(Strings.Button.tryAsGuest),
                    onPressed: () {
                      AppRouting().pushReplacementNamed(Screens.dashboard);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
