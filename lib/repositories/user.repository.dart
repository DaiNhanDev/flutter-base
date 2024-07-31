import '../models/authorization.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<Authorization> logIn({
    required String email,
    required String password,
  });

  Future<void> signOut({String? deviceToken});

  Future<void> saveUser(User user, {Authorization? authorization});

  Future<void> clearAuthentication();

  User? getLoggedInUser();

  Future<User> getLatestLoggedInUser();

  Authorization? getLoggedInAuthorization();

  Future<void> saveAuthorization(Authorization authorization);
  Future<List<User>> loadUsers({Map<String, dynamic> params});
}
