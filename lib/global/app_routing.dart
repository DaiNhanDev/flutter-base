import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRouting {
  static final AppRouting _singleton = AppRouting._internal();

  factory AppRouting() {
    return _singleton;
  }

  AppRouting._internal();

  final _scaffoldMessengerStateKey = GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerState =>
      _scaffoldMessengerStateKey;

  BuildContext? get context => _scaffoldMessengerStateKey.currentContext;

  void pushNamed(String routeName, {Map<String, dynamic>? params}) {
    QR.toName(routeName, params: params);
  }

  void pushReplacementNamed(String routeName, {Map<String, dynamic>? params}) {
    QR.navigator.replaceAllWithName(routeName, params: params);
  }
}
