// import 'package:boilerplate_flutter/services/services.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:repository/repository.dart';

import '../repositories/repository.dart';
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

  // bool isPhysicalDevice = true;
  // late PackageInfo packageInfo;

  // Service
  UserService get userService => UserServiceImpl(
        userRepository: Repository().userRepository,
      );

  SessionService get sessionService =>
      SessionServiceImpl(userRepository: Repository().userRepository);

  SettingService get settingService =>
      SettingServiceImpl(settingRepository: Repository().settingRepository);
}
