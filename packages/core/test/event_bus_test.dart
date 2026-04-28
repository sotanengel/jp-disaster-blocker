import 'dart:async';

import 'package:core/core.dart';
import 'package:test/test.dart';

class _TestEvent extends AppEvent {
  const _TestEvent(this.payload);
  final String payload;
}

void main() {
  group('EventBus', () {
    setUp(EventBus.reset);
    tearDown(EventBus.reset);

    test('emitted event is received by listener', () async {
      final received = Completer<AppEvent>();
      EventBus.stream.listen(received.complete);

      EventBus.emit(const _TestEvent('hello'));

      final event = await received.future.timeout(const Duration(seconds: 1));
      expect(event, isA<_TestEvent>());
      expect((event as _TestEvent).payload, 'hello');
    });

    test('multiple listeners each receive the event', () async {
      final results = <String>[];
      final done = Completer<void>();

      EventBus.stream.listen((e) => results.add('A:${(e as _TestEvent).payload}'));
      EventBus.stream.listen((e) {
        results.add('B:${(e as _TestEvent).payload}');
        done.complete();
      });

      EventBus.emit(const _TestEvent('ping'));
      await done.future.timeout(const Duration(seconds: 1));

      expect(results, containsAll(['A:ping', 'B:ping']));
    });
  });
}
