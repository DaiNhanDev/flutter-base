import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';

part 'connectivity_state.dart';
part 'connectivity_event.dart';

typedef CheckingInternet = Future<List<InternetAddress>> Function(String host,
    {InternetAddressType type});

class ConnectivityBloc extends BaseBloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  final CheckingInternet _internetCheckingFunction;
  final String _internetCheckingHost;
  late StreamSubscription subscription;

  ConnectivityBloc(
    super.key, {
    Connectivity? connectivity,
    CheckingInternet? internetCheckingFunction,
    String? internetCheckingHost,
  })  : _connectivity = connectivity ?? Connectivity(),
        _internetCheckingHost = internetCheckingHost ?? 'google.com',
        _internetCheckingFunction =
            internetCheckingFunction ?? InternetAddress.lookup,
        super(initialState: const ConnectivityInitial()) {
    subscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      final isConnected = await _checkConnection();

      if (isConnected != state.isConnected) {
        add(ConnectivityChanged(isConnected));
      }
    });

    on<ConnectivityChecked>(_onConnectivityChecked);
    on<ConnectivityChanged>(_onConnectivityChanged);
  }

  factory ConnectivityBloc.instance() {
    final key = Keys.Blocs.connectivityBloc;
    return EventBus().newBlocWithConstructor<ConnectivityBloc>(
      key,
      () => ConnectivityBloc(key),
    );
  }

  Future<bool> _checkConnection() async {
    var hasConnection = state.isConnected;
    try {
      final result = await _internetCheckingFunction(_internetCheckingHost);
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

    } catch (e) {
      hasConnection = false;
    }

    return hasConnection;
  }

  Future<void> _onConnectivityChecked(
      ConnectivityChecked event, Emitter<ConnectivityState> emit) async {
    final isConnected = await _checkConnection();
    if (isConnected != state.isConnected) {
      emit(ConnectivityUpdateSuccess(isConnected));
    }
  }

  Future<void> _onConnectivityChanged(
      ConnectivityChanged event, Emitter<ConnectivityState> emit) async {
    emit(ConnectivityUpdateSuccess(event.isConnected));
  }

  @override
  Future<void> close() async {
    await subscription.cancel();

    await super.close();
  }
}
