import 'package:flutter/material.dart';
import 'package:whatsup/module/profile/list_user_screen.dart';
import 'package:whatsup/module/profile/settings/setting_listuser_screen.dart';
import 'package:whatsup/module/profile/settings/setting_notitfication_screen.dart';
import 'package:whatsup/module/profile/settings/setting_privacy_screen.dart';
import 'package:whatsup/module/profile/settings/setting_screen.dart';
import 'package:whatsup/module/profile/settings/setting_socialnetwork_screen.dart';
import '../../common/constanst/route_constants.dart';
import 'profile_screen.dart';

class ProfileRoute {
  static Map<String, WidgetBuilder> getAll() {
    return {
      RouteList.profile: (context) => ProfileScreen(),
      RouteList.setting: (context) => SettingScreen(),
      RouteList.settingNotification: (context) => SettingNotificationScreen(),
      RouteList.settingPrivacy: (context) => SettingPrivacyScreen(),
      RouteList.settingSocialNetwork: (context) =>
          SettingSocicalNetworkScreen(),
      RouteList.settingListUser: (context) => SettingListUserScreen(),
      RouteList.listUser: (context) => ListUserScreen(),
    };
  }
}
