import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/common.dart';
import '../../constants/keys.dart';
import '../../constants/strings.dart';
import '../../global/provider.dart';
import '../../models/user.dart';
import '../../repositories/repository.dart';
import '../../services/session_service.dart';
import '../../services/user_service.dart';
import '../base/base_bloc.dart';
import '../base/broadcast.dart';
import '../base/event_bus.dart';
import '../constants.dart';
import '../mixin/app_loader.dart';
part 'session_state.dart';
part 'session_event.dart';

class SessionBloc extends BaseBloc<SessionEvent, SessionState> with AppLoader {
  final SessionService _sessionService;
  final UserService _userService;

  SessionBloc(
    super.key, {
    required SessionService sessionService,
    required UserService userService,
  })  : _sessionService = sessionService,
        _userService = userService,
        super(
          initialState: SessionInitial(),
        ) {
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionGuestModeStarted>(_onSessionGuestModeStarted);
    on<SessionUserLoggedIn>(_onSessionUserLoggedIn);
    on<SessionShouldSetUpMessaging>(_onSessionShouldSetUpMessaging);
    on<SessionUserSignedOut>(_onSessionUserSignedOut);
  }

  factory SessionBloc.instance() {
    final key = Keys.Blocs.sessionBloc;
    return EventBus().newBlocWithConstructor<SessionBloc>(
      key,
      () => SessionBloc(
        key,
        sessionService: Provider().sessionService,
        userService: Provider().userService,
      ),
    );
  }

  @override
  List<Broadcast> subscribes() {
    return [
      Broadcast(
        blocKey: key,
        event: BroadcastEvent.justLoggedIn,
        onNext: (data) {
          final User user = data['user'];
          final justSignUp = data['justSignUp'];
          add(SessionUserLoggedIn(user, justSignUp: justSignUp));
        },
      )
    ];
  }

  Future<void> _onSessionLoaded(
      SessionLoaded event, Emitter<SessionState> emit) async {
    final authorization = _sessionService.getLoggedInAuthorization();
         print('authorization $authorization');

    if (authorization != null) {
      Repository().authorization = authorization;
      log.info('''
              SESSION LOADED 
                >> TOKEN >> ${Repository().authorization?.accessToken}
            ''');

      try {
        final loggedInUser =
            await _sessionService.getLoggedInUser(forceToUpdate: true);

        if (loggedInUser != null) {
          emit(
            SessionUserLogInSuccess(
              user: loggedInUser,
            ),
          );
        }
      } catch (e) {
        log.error(e);
        emit(SessionReadyToLogIn());
      }
    } else {
          log.info('''
              SESSION LOADED 
                >> TOKEN >> $authorization
            ''');
      if (await _sessionService.isFirstTimeLaunching()) {
        emit(SessionFirstTimeLaunchSuccess());
      } else if (await _sessionService.isInGuestMode()) {
        emit(SessionRunGuestModeSuccess());
      } else {
        emit(SessionReadyToLogIn());
      }
    }
  }

  Future<void> _onSessionGuestModeStarted(
      SessionGuestModeStarted event, Emitter<SessionState> emit) async {
    await _sessionService.markBeInGuestMode();

    emit(SessionRunGuestModeSuccess());
  }

  Future<void> _onSessionUserLoggedIn(
      SessionUserLoggedIn event, Emitter<SessionState> emit) async {
    final authorization = _sessionService.getLoggedInAuthorization();
    if (authorization != null) {
      try {
        emit(
          SessionUserLogInSuccess(
            user: event.loggedInUser,
            justSignUp: event.justSignUp,
          ),
        );
      } catch (_) {
        emit(
          SessionUserLogInSuccess(
            user: event.loggedInUser,
            justSignUp: event.justSignUp,
          ),
        );
      }
    }
  }

  Future<void> _onSessionShouldSetUpMessaging(
      SessionShouldSetUpMessaging event, Emitter<SessionState> emit) async {
    emit(
      SessionUserReadyToSetUpMessasing(
        user: state.loggedInUser!,
      ),
    );
  }

  Future<void> _onSessionUserSignedOut(
      SessionUserSignedOut event, Emitter<SessionState> emit) async {
    showAppLoading(message: Strings.Common.loading);

    try {
      await _userService.signOut();

      hideAppLoading();

      // EventBus().event<MessagingBloc>(
      //     Keys.Blocs.messagingBloc, MessagingAllTopicsUnsubscribed());

      emit(SessionSignOutSuccess());
    } catch (e) {
      hideAppLoading();
      log.error('Sign out error >> $e');
      emit(SessionSignOutSuccess());
    }
  }

  void markDoneLandingScreen() {
    _sessionService.markDoneFirstTimeLaunching();
  }
}
