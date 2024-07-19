import 'package:shared_preferences/shared_preferences.dart';

import '../base_dao.dart';
import '../setting_dao.dart';

const currentLocaleLanguageCodeKey = 'key_current_locale_country_code';

class SettingDaoImpl extends BaseDao implements SettingDao {
  SettingDaoImpl({required SharedPreferences preferences})
      : super(prefs: preferences);

  @override
  String? getCurrentLocaleLanguageCode() {
    final languageCode = getString(currentLocaleLanguageCodeKey);
    return languageCode;
  }
}
