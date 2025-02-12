import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';

part 'loader_state.dart';
part 'loader_event.dart';

class LoaderBloc extends BaseBloc<LoaderEvent, LoaderState> {
  LoaderBloc(super.key)
      : super(initialState: LoaderInitial()) {
        on<LoaderRun>(_onLoaderRun);
        on<LoaderStopped>(_onLoaderStopped);
      }

  factory LoaderBloc.instance() {
    final key = Keys.Blocs.loaderBloc;
    return EventBus().newBlocWithConstructor<LoaderBloc>(
      key,
      () => LoaderBloc(key),
    );
  }

  Future<void> _onLoaderRun(
      LoaderRun event, Emitter<LoaderState> emit) async {
    if (state is LoaderRunSuccess) {
      return;
    }
    emit(LoaderRunSuccess(message: event.loadingMessage));
  }

  Future<void> _onLoaderStopped(
      LoaderStopped event, Emitter<LoaderState> emit) async {
    if (state is LoaderStopSuccess) {
      return;
    }
    emit(LoaderStopSuccess());
  }
}