abstract interface class Logger {
  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warning(String message, {Object? error, StackTrace? stackTrace});
  void severe(String message, {Object? error, StackTrace? stackTrace});
}

final class ConsoleLogger implements Logger {
  const ConsoleLogger(this.name);

  final String name;

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) =>
      _log('DEBUG', message, error, stackTrace);

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) =>
      _log('INFO', message, error, stackTrace);

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      _log('WARN', message, error, stackTrace);

  @override
  void severe(String message, {Object? error, StackTrace? stackTrace}) =>
      _log('ERROR', message, error, stackTrace);

  void _log(String level, String message, Object? error, StackTrace? st) {
    // ignore: avoid_print
    print('[$level] $name: $message${error != null ? '\n$error' : ''}');
  }
}
