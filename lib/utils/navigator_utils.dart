import 'package:flutter/material.dart';

class NavigatorUtils {

  static void push(BuildContext context, Widget targetWidget){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
        targetWidget));
  }

}