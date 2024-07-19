import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../../global/provider.dart';
import '../../services/user_service.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';
import '../constants.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends BaseBloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService;

  AuthenticationBloc(
    super.key, {
    required UserService userService,
  })  : _userService = userService,
        super(initialState: AuthenticationInitial()) {
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
  }

  factory AuthenticationBloc.instance() {
    final key = Keys.Blocs.authenticationBloc;
    return EventBus().newBlocWithConstructor<AuthenticationBloc>(
      key,
      () => AuthenticationBloc(
        key,
        userService: Provider().userService,
      ),
    );
  }

  Future<void> _onAuthenticationLoggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLogInInProgress());

      final user = await _userService.logIn(
        email: event.email,
        password: event.password,
      );

      EventBus().broadcast(
        BroadcastEvent.justLoggedIn,
        params: {'user': user, 'justSignUp': false},
      );

      emit(AuthenticationLogInSuccess());
    } catch (e) {
      emit(AuthenticationLogInFailure());
    }
  }
}
