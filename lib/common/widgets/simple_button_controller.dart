import 'dart:async';

enum ButtonState { enable, disable }

class SimpleButtonController {
  final StreamController<ButtonState> _controller;

  Stream<ButtonState> get itemStream => _controller.stream;
  ButtonState state;

  SimpleButtonController({
    this.state = ButtonState.enable,
  }) : _controller = StreamController.broadcast();

  void setEnable(bool enable) {
    if (enable) {
      if (state == ButtonState.enable) {
        return;
      }
      state = ButtonState.enable;
    } else {
      if (state == ButtonState.disable) {
        return;
      }
      state = ButtonState.disable;
    }
    if (!_controller.isClosed) {
      _controller.sink.add(state);
    }
  }

  void disposed() {
    _controller?.close();
  }
}
