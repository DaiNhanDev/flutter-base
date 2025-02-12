import 'package:logger/logger.dart';

import '../configs/configs.dart';
import './log.dart';


class LogImpl implements Log {
  static final LogImpl _singleton = LogImpl._internal();

  static Level _getLogLevel() {
    final logLevel = Configs().logLevel;
    var level = Level.error;
    switch (logLevel) {
      case 'trace':
        level = Level.trace;
        break;
      case 'debug':
        level = Level.debug;
        break;
      case 'info':
        level = Level.info;
        break;
      case 'warning':
        level = Level.warning;
        break;
      case 'none':
        level = Level.off;
        break;
    }
    return level;
  }

  factory LogImpl() {
    Logger.level = _getLogLevel();
    return _singleton;
  }

  LogImpl._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        // printTime: false // Should each log print contain a timestamp
        ),
  );

  @override
  void debug(dynamic message) {
    _logger.d(message);
  }

  @override
  void error(dynamic message) {
    _logger.e(message);
  }

  @override
  void fatal(dynamic message) {
    _logger.f(message);
  }

  @override
  void info(dynamic message) {
    _logger.i(message);
  }

  @override
  void trace(dynamic message) {
    _logger.t(message);
  }

  @override
  void warning(dynamic message) {
    _logger.w(message);
  }
}
