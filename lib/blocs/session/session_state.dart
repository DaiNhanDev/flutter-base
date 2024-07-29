part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  final User? loggedInUser;
  final DateTime lastUpdatedTime;

  SessionState({
    this.loggedInUser,
  }): lastUpdatedTime = DateTime.now();

  @override
  List<Object> get props => [lastUpdatedTime];
}

class SessionInitial extends SessionState {
  SessionInitial() : super();
}

class SessionFirstTimeLaunchSuccess extends SessionState {
  SessionFirstTimeLaunchSuccess() : super();
}

class SessionReadyToLogIn extends SessionState {
  SessionReadyToLogIn() : super();
}
class SessionUserLogInSuccess extends SessionState {
  final bool justSignUp;

  SessionUserLogInSuccess({
    required User user,
    this.justSignUp = false,
  }) : super(
          loggedInUser: user,
        );
}

class SessionSignOutSuccess extends SessionState {
  SessionSignOutSuccess() : super();
}
