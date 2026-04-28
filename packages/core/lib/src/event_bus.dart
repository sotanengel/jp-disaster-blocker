import 'dart:async';

abstract class AppEvent {
  const AppEvent();
}

class EventBus {
  EventBus._();

  static StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  static Stream<AppEvent> get stream => _controller.stream;

  static void emit(AppEvent event) => _controller.add(event);

  static void reset() {
    if (!_controller.isClosed) _controller.close();
    _controller = StreamController<AppEvent>.broadcast();
  }
}
