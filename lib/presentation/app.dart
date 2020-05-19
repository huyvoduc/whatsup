import 'package:flutter/material.dart';

import '../module/guide/init_screen.dart';
import 'routes.dart';
import 'theme/theme_data.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsup',
      theme: appTheme(context),
      home: Container(
        color: Theme.of(context).primaryColor,
        child: InitScreen(),
      ),
      routes: Routes.getAll(),
    );
  }
}
