import 'package:flutter/material.dart';

import '../../common/constanst/route_constants.dart';
import '../../model/post_model.dart';
import 'screen/post_list_screen.dart';

class PostRoute {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.featuredPost: (context) =>
          PostScreen.newInstance(PostListType.featuredPost),
      RouteList.newestPost: (context) =>
          PostScreen.newInstance(PostListType.newestPost,),
      RouteList.subscriptionPost: (context) => PostScreen.newInstance(
          PostListType.subscriptionPost, ),
    };
  }
}
