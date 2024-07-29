import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../../global/provider.dart';
import '../../services/session_service.dart';
import '../../services/user_service.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';
import '../constants.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends BaseBloc<AuthenticationEvent, AuthenticationState> {
  final SessionService _sessionService;
  final UserService _userService;

  AuthenticationBloc(
    super.key, {
    required SessionService sessionService,
    required UserService userService,
  })  : _sessionService = sessionService,
        _userService = userService,
        super(initialState: AuthenticationInitial()) {
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
  }

  factory AuthenticationBloc.instance() {
    final key = Keys.Blocs.authenticationBloc;
    return EventBus().newBlocWithConstructor<AuthenticationBloc>(
      key,
      () => AuthenticationBloc(key,
          sessionService: Provider().sessionService,
          userService: Provider().userService),
    );
  }

  Future<void> _onAuthenticationLoggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLogInInProgress());
    final loggedInUser =  await _userService.logIn(
        email: event.email,
        password: event.password,
      );

      EventBus().broadcast(
        BroadcastEvent.justLoggedIn,
        params: {'user': loggedInUser, 'justSignUp': false},
      );

      emit(AuthenticationLogInSuccess());
    } catch (e) {
      emit(AuthenticationLogInFailure());
    }
  }
}
