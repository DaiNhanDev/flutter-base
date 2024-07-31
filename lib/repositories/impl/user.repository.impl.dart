import '../../data/client/user.client.dart';
import '../../data/dao/user_dao.dart';
import '../../models/authorization.dart';
import '../../models/user.dart';
import '../user.repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserClient _userClient;
  final UserDao _userDao;

  UserRepositoryImpl({
    required UserClient userClient,
    required UserDao userDao,
  })  : _userClient = userClient,
        _userDao = userDao;

  @override
  Future<Authorization> logIn({
    required String email,
    required String password,
  }) async {
    final authorization = await _userClient.logIn(email, password);
    return authorization;
  }

  @override
  Future<void> saveUser(User user, {Authorization? authorization}) async {
    await _userDao.saveUser(user);

    if (authorization != null) {
      await _userDao.saveAuthorization(authorization);
    }
  }

  @override
  Future<void> saveAuthorization(Authorization authorization) async {
    await _userDao.saveAuthorization(authorization);
  }

  @override
  User? getLoggedInUser({bool forceToUpdate = false}) {
    return _userDao.loadUser();
  }

  @override
  Future<User> getLatestLoggedInUser() async {
    final user = await _userClient.getProfile();
    await _userDao.saveUser(user);
    return user;
  }

  @override
  Authorization? getLoggedInAuthorization() {
    return _userDao.loadAuthorization();
  }

  @override
  Future<void> signOut({String? deviceToken}) async {
    await _userClient.signOut(deviceToken: deviceToken);
  }

  @override
  Future<void> clearAuthentication() {
    return _userDao.clearAuthentication();
  }

  @override
  Future<List<User>> loadUsers({Map<String, dynamic>? params}) {
   return _userClient.loadUsers();
  }
}
