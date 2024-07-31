import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../../global/provider.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';
// import '../constants.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc
    extends BaseBloc<HomeEvent, HomeState> {
  final UserService _userService;

  HomeBloc(
    super.key, {
    required UserService userService,
  })  : _userService = userService,
        super(initialState: const HomeInitial([])) {
    on<LoadUsers>(_onAuthenticationLoggedIn);
  }

  factory HomeBloc.instance() {
    final key = Keys.Blocs.homeBloc;
    return EventBus().newBlocWithConstructor<HomeBloc>(
      key,
      () => HomeBloc(key, userService: Provider().userService),
    );
  }

  Future<void> _onAuthenticationLoggedIn(
      LoadUsers event, Emitter<HomeState> emit) async {
    try {
      emit(LoadUsersInProgress([]));
      final users = await _userService.loadUsers();
     
      emit(LoadUsersSuccess([]));
    } catch (e) {
      emit(LoadUsersFailure([]));
    }
  }
}
