import 'package:core/core.dart';
import 'package:test/test.dart';

class _RecordingLogger implements Logger {
  final records = <String>[];

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) =>
      records.add('D:$message');

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) =>
      records.add('I:$message');

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      records.add('W:$message');

  @override
  void severe(String message, {Object? error, StackTrace? stackTrace}) =>
      records.add('E:$message');
}

void main() {
  group('Logger', () {
    test('RecordingLogger captures all levels', () {
      final logger = _RecordingLogger();
      logger.debug('d');
      logger.info('i');
      logger.warning('w');
      logger.severe('e');
      expect(logger.records, ['D:d', 'I:i', 'W:w', 'E:e']);
    });
  });

  group('AppException', () {
    test('message is set', () {
      final ex = AppException('test error');
      expect(ex.message, 'test error');
      expect(ex.toString(), contains('test error'));
    });
  });
}
