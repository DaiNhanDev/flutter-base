import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/base/simple_bloc_observer.dart';
import 'modules/app.dart';
import 'repositories/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Repository().initialize(),
  ]);
  Bloc.observer = SimpleBlocObserver();

  runApp(const Application());
}
