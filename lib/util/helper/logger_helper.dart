import 'package:logger/logger.dart';

class LoggerHelper {
  late Logger _logger;

  LoggerHelper._({bool longLog = false}) {
    _logger = Logger(
      printer: PrettyPrinter(
        noBoxingByDefault: true,
        stackTraceBeginIndex: 0,
        methodCount: 0,
        errorMethodCount: 0,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  factory LoggerHelper.create({bool longLog = false}) =>
      LoggerHelper._(longLog: longLog);

  void info(String message, {Object? error, StackTrace? trace}) =>
      _logger.i(message, error: error, stackTrace: trace);

  void warning(String message, {Object? error, StackTrace? trace}) =>
      _logger.w(message, error: error, stackTrace: trace);

  void debug(String message, {Object? error, StackTrace? trace}) =>
      _logger.d(message, error: error, stackTrace: trace);

  void trace(String message, {Object? error, StackTrace? trace}) =>
      _logger.t(message, error: error, stackTrace: trace);

  void error(String message, {Object? error, StackTrace? trace}) =>
      _logger.e(message, error: error, stackTrace: trace);
}
