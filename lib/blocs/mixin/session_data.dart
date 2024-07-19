import '../../constants/keys.dart';
import '../base/event_bus.dart';
import '../session/session_bloc.dart';

mixin SessionData {
  bool get isGuest =>
      EventBus()
          .blocFromKey<SessionBloc>(Keys.Blocs.sessionBloc)
          ?.state
          .loggedInUser ==
      null;
}
