import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'system_lifecycle_listener.dart';

abstract class LifeCycleState<T extends StatefulWidget> extends State<T>
    with
// ignore: prefer_mixin
        RouteAware {
  @override
  void initState() {
    super.initState();
    SystemLifecycleListener.instance.addCallback(handleLifeCycleCallback);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      onFirstFrame();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void handleLifeCycleCallback(AppLifeCycle lifeCycle) {
    if (lifeCycle == AppLifeCycle.onResume) {
      onResume();
    } else if (lifeCycle == AppLifeCycle.onPause) {
      hideKeyboard();
      onPause();
    }
  }

  @override
  void dispose() {
    SystemLifecycleListener.instance.removeCallback(handleLifeCycleCallback);
    super.dispose();
  }

  void onResume() {}

  void onPause() {}

  void onFirstFrame() {}

  RouteObserver<Route> get routeObserver;

  @override
  void didPopNext() {
    SystemLifecycleListener.instance.addCallback(handleLifeCycleCallback);
    onResume();
  }

  @override
  void didPushNext() {
    SystemLifecycleListener.instance.removeCallback(handleLifeCycleCallback);
    hideKeyboard();
    onPause();
  }

  @override
  void didPop() {}

  @override
  void didPush() {}
}

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
