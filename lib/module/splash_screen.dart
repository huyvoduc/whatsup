import 'package:flutter/material.dart';

import '../utils/dimension.dart';
import 'dummy_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.width = MediaQuery.of(context).size.width;
    Dimension.statusBarHeight = MediaQuery.of(context).padding.top;
    Dimension.bottomPadding = MediaQuery.of(context).padding.bottom;

    Future.delayed(
      const Duration(milliseconds: 1100),
    ).then(
      (onValue) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DummyScreen(),
          ),
        );
      },
    );

    return Scaffold(
      body: Container(
        width: Dimension.width,
        height: Dimension.height,
        child: Center(
          child: Icon(
            Icons.ac_unit,
            size: 100,
            color: Colors.blue[300],
          ),
        ),
      ),
    );
  }
}
