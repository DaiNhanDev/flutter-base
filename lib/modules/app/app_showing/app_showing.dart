
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/show_message/show_message_bloc.dart';
// import '../../../common/common.dart';
import '../loading/loading.dart';
import '../lost_connection/lost_connection.dart';

class AppShowing extends StatefulWidget {
  const AppShowing({
    super.key,
    required this.app,
  });

  final Widget app;

  @override
  State<StatefulWidget> createState() {
    return _AppShowingState();
  }
}

class _AppShowingState extends State<AppShowing> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('======>state $state ');
    switch (state) {
      case AppLifecycleState.resumed:
        {
          // log.info('App Resumed from Background');
        }
        break;
      case AppLifecycleState.inactive:
        {
          // log.info('App Change to Inactive');
        }
        break;
      case AppLifecycleState.paused:
        {
          // log.info('App Paused');
        }
        break;
      case AppLifecycleState.detached:
        {
          // log.info('Widget is detached');
        }
        break;
      case AppLifecycleState.hidden:
        // log.info('App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShowMessageBloc, ShowMessageState>(
          listener: (_, state) {
            // if (state is ShowWarningMessageSuccess) {
            //   Toast(
            //     S.of(context).translate(
            //           state.messageKey ?? '',
            //           params: state.params,
            //         ),
            //     success: state.isSuccess,
            //   ).show(AppRouting().context);
            // } else if (state is ShowErrorMessageSuccess) {
            //   if (AppRouting().context != null) {
            //     PopupDrawer.of(AppRouting().context!)
            //         .alert(
            //           title: S
            //               .of(context)
            //               .translate(Strings.Common.error),
            //           message: S.of(context).translate(
            //                 state.messageKey ?? '',
            //                 params: state.params,
            //               ),
            //         )
            //         .show();
            //   }
            // }
          },
        ),
      ],
      child: Stack(
        children: <Widget>[
          widget.app,
          const LostConnection(),
          const Loading(),
        ],
      ),
    );
  }
}
