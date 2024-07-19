import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';

part 'show_message_state.dart';
part 'show_message_event.dart';

class ShowMessageBloc extends BaseBloc<ShowMessageEvent, ShowMessageState> {
  ShowMessageBloc(super.key) : super(initialState: ShowMessageInitial()) {
    on<WarningMessageShowed>(_onWarningMessageShowed);
    on<ErrorMessageShowed>(_onErrorMessageShowed);
  }

  factory ShowMessageBloc.instance() {
    final key = Keys.Blocs.showMessageBloc;
    return EventBus().newBlocWithConstructor<ShowMessageBloc>(
      key,
      () => ShowMessageBloc(key),
    );
  }

  void _onWarningMessageShowed(
      WarningMessageShowed event, Emitter<ShowMessageState> emit) {
    emit(
      ShowWarningMessageSuccess(
        event.messageKey,
        params: event.params,
        isSuccess: event.isSuccess,
      ),
    );
  }

  void _onErrorMessageShowed(
      ErrorMessageShowed event, Emitter<ShowMessageState> emit) {
    emit(ShowErrorMessageSuccess(event.messageKey, params: event.params));
  }
}
