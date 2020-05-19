import 'package:flutter/material.dart';
import 'package:whatsup/module/login/login_router.dart';

import '../module/home/home_route.dart';
import '../module/post_content/post_route.dart';
import '../module/profile/profile_route.dart';

class Routes {
  static Map<String, WidgetBuilder> _getCombinedRoutes() => {
        ...HomeRoute.getAll(),
        ...ProfileRoute.getAll(),
        ...PostRoute.getAll(),
        ...LoginRouter.getAll()
      };

  static Map<String, WidgetBuilder> getAll() => _getCombinedRoutes();
}
