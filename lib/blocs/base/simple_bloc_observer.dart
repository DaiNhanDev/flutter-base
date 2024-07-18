import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/common.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.trace(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.error('\n ---- ${bloc.toString()}: $error ----');
    super.onError(bloc, error, stackTrace);
  }
}
