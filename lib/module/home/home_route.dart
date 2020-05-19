import 'package:flutter/material.dart';
import 'package:whatsup/module/menu/screen/menu_screen.dart';

import '../../common/constanst/route_constants.dart';
import 'screen/home_screen.dart';

class HomeRoute {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.home: (context) => HomeScreen(),
      RouteList.menuScreen: (context) => MenuScreen(),
    };
  }
}
