import '../../models/authorization.dart';
import '../../models/user.dart';

abstract class UserClient {
  Future<Authorization> logIn(String email, String password);

  Future<User> getProfile();

  Future<void> signOut({String? deviceToken});
}
