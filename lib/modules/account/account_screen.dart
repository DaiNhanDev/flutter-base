import 'package:flutter/material.dart';

import '../../blocs/base/event_bus.dart';
import '../../blocs/session/session_bloc.dart';
import '../../constants/keys.dart';
import '../../widgets/button/x_link_button.dart';
import '../../widgets/text/x_text.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const XText.displayMedium('Account'),
          const SizedBox(
            height: 24,
          ),
          XLinkButton(
            title: 'Log Out',
            onPressed: () {
              EventBus().event<SessionBloc>(
                Keys.Blocs.sessionBloc,
                SessionUserSignedOut(),
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
