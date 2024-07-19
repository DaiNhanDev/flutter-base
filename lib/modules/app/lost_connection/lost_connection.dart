import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/connectivity/connectivity_bloc.dart';
import '../../../common/common.dart';
import '../../../constants/app_context.dart';
import '../../../constants/strings.dart';
import '../../../global/localization.dart';

class LostConnection extends StatelessWidget {
  const LostConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (!state.isConnected) {
          log.error('Lost Connection !');
        }
        return Visibility(
          visible: !state.isConnected,
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                S.of(context).translate(
                      Strings.Common.noInternetConnection,
                    ),
                style: context.headlineSmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
