import '../repositories/repository.dart';
import '../services/auth.service.dart';
import '../services/impl/auth.service.impl.dart';
import '../services/impl/session.service.impl.dart';
import '../services/impl/setting.service.impl.dart';
import '../services/impl/user.service.impl.dart';
import '../services/session_service.dart';
import '../services/setting_service.dart';
import '../services/user_service.dart';

class Provider {
  static final Provider _singleton = Provider._internal();

  factory Provider() {
    return _singleton;
  }

  Provider._internal();

  // Service
    AuthService get authService => AuthServiceImpl(
        authRepository: Repository().authRepository,
      );

  UserService get userService => UserServiceImpl(
        userRepository: Repository().userRepository,
      );

  SessionService get sessionService =>
      SessionServiceImpl(userRepository: Repository().userRepository);

  SettingService get settingService =>
      SettingServiceImpl(settingRepository: Repository().settingRepository);

  
}
