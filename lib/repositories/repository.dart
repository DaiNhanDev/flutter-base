library repository;

// import 'package:repository/client/client.dart';
// import 'package:repository/configs.dart';
// import 'package:repository/dao/dao.dart';
// import 'package:repository/model/authorization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/authorization.dart';

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
    print('=====> OK');
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool get isAuthorized => authorization != null;

  // // Repository
  // UserRepository get userRepository => UserRepositoryImpl(
  //       userClient: userClient,
  //       userDao: userDao,
  //     );

  // SettingRepository get settingRepository => SettingRepositoryImpl(
  //       settingDao: settingDao,
  //       supportedLanguges: Configs().supportedLanguages,
  //     );

  // // Dao
  // UserDao get userDao => UserDaoImpl(preferences: _sharedPreferences);

  // SettingDao get settingDao => SettingDaoImpl(preferences: _sharedPreferences);

  // // Client
  // UserClient get userClient =>
  //     UserClientImpl(host: Configs().baseUrl, authorization: authorization);
}
