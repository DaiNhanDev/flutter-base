import 'dart:ui';

import '../../data/dao/setting_dao.dart';
import '../setting.repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingDao _settingDao;
  final String _supportedLanguages;

  SettingRepositoryImpl({
    required SettingDao settingDao,
    required String supportedLanguges,
  })  : _settingDao = settingDao,
        _supportedLanguages = supportedLanguges;

  @override
  Locale getCurrentLocale() {
    final languageCode = _settingDao.getCurrentLocaleLanguageCode();

    return languageCode != null ? Locale(languageCode) : const Locale('en');
  }

  @override
  List<Locale> getSupportedLocales() {
    return _supportedLanguages.split(',').map(Locale.new).toList();
  }
}
