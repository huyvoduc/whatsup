import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'lifecycle.dart';

/// Provides common utilities and functions to build ui and handle app lifecycle
abstract class BaseState<T extends StatefulWidget> extends LifeCycleState<T> {
  Size screenSize;

  Size designScreenSize;

  /// Called when the app is temporarily closed or a new route is pushed
  @override
  void onPause() {}

  void pushScreen({@required String routerName,Object param}) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => screen),
//    );
    Navigator.pushNamed(context,routerName,arguments :param);
    //Navigator.of(context).pushNamed(routerName,arguments :param);
  }

  Future<void> pushScreenOther(Widget screen) async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  dynamic getRouteParam() {
    return ModalRoute.of(context).settings.arguments;
  }

  bool _isShowLoading = false;

  Future showSimpleDialog({String title = '',
    String message = '',Function() ok}) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
              ok();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void popToRoot() {
    Navigator.of(context).popUntil((e) => e.isFirst);
  }


  void popToRoute({String route}) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  void showLoading() {
    _isShowLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      child: const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )),
    );
  }

  void hideLoading() {
    if (_isShowLoading) {
      _isShowLoading = false;
      Navigator.pop(context);
    }
  }

  // ignore: avoid_shadowing_type_parameters
  T getCurrentBloc<T extends Bloc>() {
    return BlocProvider.of<T>(context);
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void presentScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => screen));
  }

  /// Called when users return to the app or
  /// the adjacent route of this widget is popped
  @override
  void onResume() {}

  /// Called once when this state's widget finished building
  @override
  void onFirstFrame() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    designScreenSize = getDesignSize() ?? const Size(360, 640);
  }

  /// Override to define new design size for ui
  Size getDesignSize() => null;

  String get packageName => null;

  /// Scale the provided 'designSize' proportionally to the screen's width
  double scaleWidth(num designSize, {bool preventScaleDown = false}) {
    if (designSize == null) {
      return null;
    }
    final scaledSize = screenSize.width * designSize / designScreenSize.width;

    if (preventScaleDown && scaledSize < designSize) {
      return designSize?.toDouble();
    }

    return scaledSize;
  }

  /// Scale the provided 'designSize' proportionally to the screen's height
  double scaleHeight(num designSize, {bool preventScaleDown = false}) {
    if (designSize == null) {
      return null;
    }

    final scaledSize = screenSize.height * designSize / designScreenSize.height;

    if (preventScaleDown && scaledSize < designSize) {
      return designSize?.toDouble();
    }

    return scaledSize;
  }

  Widget buildAssetsImage(String path,
      {BoxFit fit = BoxFit.contain, num width, num height, String package}) {
    return Image.asset(path,
        height: height?.toDouble(),
        width: width?.toDouble(),
        package: package ?? packageName,
        fit: fit);
  }

  DecorationImage buildDecorationImage(String path,
      {BoxFit fit = BoxFit.contain, ColorFilter filter, String package}) {
    return DecorationImage(
        image: AssetImage(path, package: package ?? packageName),
        fit: fit,
        colorFilter: filter);
  }

  @override
  RouteObserver<Route> get routeObserver => null;
}
