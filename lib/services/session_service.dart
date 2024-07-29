import '../models/authorization.dart';
import '../models/user.dart';

abstract class SessionService {
  Future<bool> isFirstTimeLaunching();

  Future<void> markDoneFirstTimeLaunching();

  Future<User?> getLoggedInUser({bool forceToUpdate});

  Authorization? getLoggedInAuthorization();
}