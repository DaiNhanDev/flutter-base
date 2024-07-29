import '../models/user.dart';

abstract class UserService {
  Future<User> logIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<User> getLatestLoggedInUser();
  bool isUserAlreadyLoggedIn();
}
