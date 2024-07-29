import 'package:shared_preferences/shared_preferences.dart';

import '../common/configs/configs.dart';
import '../data/client/impl/user.client.impl.dart';
import '../data/client/user.client.dart';
import '../data/dao/impl/setting_dao.impl.dart';
import '../data/dao/impl/user_dao_impl.dart';
import '../data/dao/setting_dao.dart';
import '../data/dao/user_dao.dart';
import '../models/authorization.dart';
import 'impl/setting.repository.impl.dart';
import 'impl/user.repository.impl.dart';
import 'setting.repository.dart';
import 'user.repository.dart';

class Repository {
  static final Repository _singleton = Repository._internal();
  late SharedPreferences _sharedPreferences;
  Authorization? authorization;

  factory Repository() {
    return _singleton;
  }

  Repository._internal();

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool get isAuthorized => authorization != null;

  UserRepository get userRepository => UserRepositoryImpl(
        userClient: userClient,
        userDao: userDao,
      );

  SettingRepository get settingRepository => SettingRepositoryImpl(
        settingDao: settingDao,
        supportedLanguges: Configs().supportedLanguages,
      );

  // // Dao
  UserDao get userDao => UserDaoImpl(preferences: _sharedPreferences);

  SettingDao get settingDao => SettingDaoImpl(preferences: _sharedPreferences);

  // Client
  UserClient get userClient =>
      UserClientImpl(host: Configs().baseUrl, authorization: authorization);
}
