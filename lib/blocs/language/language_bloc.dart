import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys.dart';
import '../../global/provider.dart';
import '../../services/setting_service.dart';
import '../base/base_bloc.dart';
import '../base/event_bus.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends BaseBloc<LanguageEvent, LanguageState> {
  final SettingService settingService;

  LanguageBloc(super.key, {required this.settingService})
      : super(
          initialState: LanguageInitial(
            settingService.getCurrentLocale(),
            settingService.getSupportedLocales(),
          ),
        ) {
    on<LanguageUpdated>(_onLanguageUpdated);
  }

  factory LanguageBloc.instance() {
    final key = Keys.Blocs.languageBloc;
    return EventBus().newBlocWithConstructor<LanguageBloc>(
      key,
      () => LanguageBloc(
        key,
        settingService: Provider().settingService,
      ),
    );
  }

  void _onLanguageUpdated(LanguageUpdated event, Emitter<LanguageState> emit) {
    if (event.newLanguage.languageCode == state.locale.languageCode) {
      return;
    }
    emit(
      LanguageUpdateSuccess(event.newLanguage, state.supportedLocales),
    );
  }
}
