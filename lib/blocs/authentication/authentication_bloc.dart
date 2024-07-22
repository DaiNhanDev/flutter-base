import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../../global/provider.dart';
import '../../services/auth.service.dart';
import '../../services/session_service.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';
import '../constants.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends BaseBloc<AuthenticationEvent, AuthenticationState> {
  final SessionService _sessionService;
    final AuthService _authService;

  AuthenticationBloc(
    super.key, {
    required SessionService sessionService,
    required AuthService authService,
  })  : _sessionService = sessionService,
  _authService = authService,
        super(initialState: AuthenticationInitial()) {
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
  }

  factory AuthenticationBloc.instance() {
    final key = Keys.Blocs.authenticationBloc;
    return EventBus().newBlocWithConstructor<AuthenticationBloc>(
      key,
      () => AuthenticationBloc(
        key,
        sessionService: Provider().sessionService,
        authService: Provider().authService
      ),
    );
  }

  Future<void> _onAuthenticationLoggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLogInInProgress());
      await _authService.logIn(
        email: event.email,
        password: event.password,
      );

        final loggedInUser =
            await _sessionService.getLoggedInUser(forceToUpdate: true);

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
