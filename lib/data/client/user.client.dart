import '../../models/user.dart';

abstract class UserClient {
  Future<User> getProfile();

  Future<void> signOut({String? deviceToken});

  Future<bool> registerDevice({
    required String deviceToken,
    required int deviceType,
    required String deviceUdid,
  });

  Future<User> logIn();
}
