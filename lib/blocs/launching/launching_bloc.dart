import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/common.dart';
import '../../constants/keys.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';

part 'launching_state.dart';
part 'launching_event.dart';

class LaunchingBloc extends BaseBloc<LaunchingEvent, LaunchingState> {
  LaunchingBloc(super.key) : super(initialState: LaunchingInitial()) {
    on<LaunchingPreloadDataStarted>(_onLaunchingPreloadDataStarted);
  }

  factory LaunchingBloc.instance() {
    final key = Keys.Blocs.launchingBloc;
    return EventBus().newBlocWithConstructor<LaunchingBloc>(
      key,
      () => LaunchingBloc(key),
    );
  }

  Future<void> _onLaunchingPreloadDataStarted(
      LaunchingPreloadDataStarted event, Emitter<LaunchingState> emit) async {
    try {
        emit(LaunchingPreloadDataInProgress());

        // do something
        
        emit(LaunchingPreloadDataSuccess());
      } catch (e) {
        log.error(e.toString());
        emit(LaunchingPreloadDataFailure(errorMessage: e.toString()));
      }
  }
}
