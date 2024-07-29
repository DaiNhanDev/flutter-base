import '../../models/authorization.dart';
import '../../models/user.dart';

abstract class UserDao {
  Future<void> saveUser(User user);

  Future<void> saveAuthorization(Authorization authorization);

  User? loadUser();

  Authorization? loadAuthorization();

  Future<void> saveRegisteredDeviceToken({required String deviceToken});

  Future<void> clearAuthentication();
}
