library repository;

// import 'package:repository/client/client.dart';
// import 'package:repository/configs.dart';
// import 'package:repository/dao/dao.dart';
// import 'package:repository/model/authorization.dart';
import 'package:base_app/repositories/setting.repository.dart';
import 'package:base_app/repositories/user.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/configs/configs.dart';
import '../data/client/impl/user_client_impl.dart';
import '../data/client/user_client.dart';
import '../data/dao/impl/setting_dao.impl.dart';
import '../data/dao/impl/user_dao_impl.dart';
import '../data/dao/setting_dao.dart';
import '../data/dao/user_dao.dart';
import '../models/authorization.dart';
import 'impl/setting.repository.impl.dart';
import 'impl/user.repository.impl.dart';

// import 'repository/repository.dart';

// export 'repository/repository.dart';
// export 'exception/exception.dart';
// export 'exception/error_codes.dart';
// export 'enum/enum.dart';
// export 'model/model.dart';
// export 'test_data.dart';

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

  // // Repository
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
