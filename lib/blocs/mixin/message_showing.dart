import '../../constants/keys.dart';
import '../base/event_bus.dart';
import '../show_message/show_message_bloc.dart';

mixin MessageShowing {
  void showFailureMessage(String messageKey,
      {List<dynamic> params = const []}) {
    EventBus().event<ShowMessageBloc>(
      Keys.Blocs.showMessageBloc,
      WarningMessageShowed(
        messageKey,
        params: params,
      ),
    );
  }

  void showSuccessMessage(String messageKey,
      {List<dynamic> params = const []}) {
    EventBus().event<ShowMessageBloc>(
      Keys.Blocs.showMessageBloc,
      WarningMessageShowed(
        messageKey,
        params: params,
        isSuccess: true,
      ),
    );
  }
}