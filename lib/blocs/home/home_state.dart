part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<User> users;
  const HomeState(this.users);

  @override
  List<Object> get props => [users];
}

class HomeInitial extends HomeState {
  const HomeInitial(super.users);
}

class LoadUsersInProgress extends HomeState {
  const LoadUsersInProgress(super.users);
}

class LoadUsersSuccess extends HomeState {
  const LoadUsersSuccess(super.users);
}

class LoadUsersFailure extends HomeState {
  const LoadUsersFailure(super.users);
}
