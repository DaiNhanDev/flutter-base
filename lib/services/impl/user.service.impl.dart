import '../../models/user.dart';
import '../../repositories/repository.dart';
import '../../repositories/user.repository.dart';
import '../user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    final authorization =
        await _userRepository.logIn(email: email, password: password);
    Repository().authorization = authorization;
    final user = await _userRepository.getLatestLoggedInUser();

    await _userRepository.saveUser(user, authorization: authorization);

    return user;
  }

  @override
  Future<User> getLatestLoggedInUser() async {
    final user = await _userRepository.getLatestLoggedInUser();

    return user;
  }

  @override
  Future<void> signOut() async {
    await _userRepository.signOut(deviceToken: 'deviceToken');

    Repository().authorization = null;

    // remove all cached data
    await _userRepository.clearAuthentication();
  }

  @override
  bool isUserAlreadyLoggedIn() {
    return _userRepository.getLoggedInUser() != null;
  }

  @override
  Future<List<User>> loadUsers({Map<String, dynamic>? params}) {
    return _userRepository.loadUsers();
  }
}
