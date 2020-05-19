

import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import '../../login/screen/login_home_screen.dart';
// ignore: directives_ordering
import '../../../utils/life_cycle/base.dart';
import '../../../utils/user_manager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xff242A37),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 0,
            child: RaisedButton(
              onPressed: goBack,
              child: Icon(Icons.arrow_back),
            ),
          )
        ],

      ),
    );
  }
}
