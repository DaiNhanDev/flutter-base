import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/base/event_bus.dart';
import '../../blocs/launching/launching_bloc.dart';
import '../../blocs/session/session_bloc.dart';
import '../../common/common.dart';
import '../../constants/app_context.dart';
import '../../constants/app_images.dart';
import '../../constants/keys.dart';
import '../../constants/screens.dart';
import '../../constants/strings.dart';
import '../../global/app_routing.dart';
import '../../global/localization.dart';
import '../../models/screen_size.dart';
import '../../widgets/app_image/app_image.dart';
import '../../widgets/loading_text/loading_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      AppContext.screenSize = screenSizeFromDevice(screenWidth: size.width);
      log.info('Screen Size >> $size >> ${AppContext.screenSize}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<LaunchingBloc, LaunchingState>(
            listener: (_, state) {
              if (state is LaunchingPreloadDataSuccess) {
                print('====>LaunchingState: $state');

                EventBus().event<SessionBloc>(
                    Keys.Blocs.sessionBloc, SessionLoaded());
              } else if (state is LaunchingPreloadDataFailure) {
                EventBus().event<LaunchingBloc>(
                    Keys.Blocs.launchingBloc, LaunchingPreloadDataStarted());
              }
            },
          ),
          BlocListener<SessionBloc, SessionState>(
            listener: (_, state) async {
              print('====> state: $state');
              await Future.delayed(const Duration(milliseconds: 1500));
              if (state is SessionFirstTimeLaunchSuccess) {
                AppRouting().pushReplacementNamed(Screens.landing);
              } else if (state is SessionReadyToLogIn) {
                AppRouting().pushReplacementNamed(Screens.logIn);
              } else if (state is SessionRunGuestModeSuccess) {
                AppRouting().pushReplacementNamed(Screens.landing);
              } else if (state is SessionUserLogInSuccess) {
                AppRouting().pushReplacementNamed(Screens.landing);
              }
            },
          ),
        ],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xffefefef),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: AppImage(
                  image: AppImagesAsset.logoSologan,
                  width: 214,
                  height: 240,
                ),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: LoadingText(
                        text: S.of(context).translate(Strings.Common.loading),
                        showAfter: const Duration(milliseconds: 1500),
                        textStyle: context.bodySmall!,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: AppImage(
                        image: AppImagesAsset.copyright,
                        width: 154,
                        height: 12,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
