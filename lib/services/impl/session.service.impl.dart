// ignore_for_file: constant_identifier_names
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/authorization.dart';
import '../../models/user.dart';
import '../../repositories/user.repository.dart';
import '../session_service.dart';

const _FirstTimeLaunchingKey = 'key_first_time_launching';

class SessionServiceImpl implements SessionService {
  final UserRepository _userRepository;

  SessionServiceImpl({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<User?> getLoggedInUser({bool forceToUpdate = false}) async {
    if (!forceToUpdate) {
      return _userRepository.getLoggedInUser();
    }
    return _userRepository.getLatestLoggedInUser();
  }

  @override
  Authorization? getLoggedInAuthorization () {
    return _userRepository.getLoggedInAuthorization();
  }

  @override
  Future<bool> isFirstTimeLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_FirstTimeLaunchingKey) ?? false);
  }

  @override
  Future<void> markDoneFirstTimeLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_FirstTimeLaunchingKey, true);
  }

}
