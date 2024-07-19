import '../../constants/keys.dart';
import '../base/event_bus.dart';
import '../loader/loader_bloc.dart';

mixin AppLoader {
  void showAppLoading({String? message}) {
    EventBus().event<LoaderBloc>(Keys.Blocs.loaderBloc, LoaderRun(message));
  }

  void hideAppLoading() {
    EventBus().event<LoaderBloc>(Keys.Blocs.loaderBloc, LoaderStopped());
  }
}