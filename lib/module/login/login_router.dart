import 'package:flutter/material.dart';
import 'package:whatsup/module/login/screen/birthday_screen.dart';
import 'package:whatsup/module/login/screen/forget_pass_screen.dart';
import 'package:whatsup/module/login/screen/input_password_screen.dart';
import 'package:whatsup/module/login/screen/login_home_screen.dart';
import 'package:whatsup/module/login/screen/sign_up_screen.dart';
import 'package:whatsup/module/login/screen/user_info_screen.dart';

import '../../common/constanst/route_constants.dart';

class LoginRouter {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.loginHome: (context) => LoginScreen(),
      RouteList.loginSignUp: (context) => SignUpScreen(),
      RouteList.loginInputPass: (context) => InputPasswordScreen(),
      RouteList.loginInputBirthDay: (context) => BirthDayScreen(),
      RouteList.loginInputUserInfo: (context) => RegisterUserInfoScreen(),
      RouteList.loginResetPass: (context) => ResetPasswordScreen(),
    };
  }
}
