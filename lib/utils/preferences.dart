import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/const.dart';
import '../model/user_model.dart';

Preferences preferences = Preferences();

class Preferences {
  SharedPreferences _prefs;

  Future<void> _getPrefer() async {
    // ignore: join_return_with_assignment
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<UserModel> loadUserInfo() async {
    await _getPrefer();
    final json = _prefs.getString("user_info");
    if (json != null && json.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future saveUserInfo(UserModel user) async {
    await _getPrefer();
    await _prefs.setString(
        "user_info", user != null ? jsonEncode(user.toJson()) : null);
  }

  Future<String> getAppSavedInfo(String name) async {
    await _getPrefer();
    final result = _prefs.getString(name) ?? '';
    return result;
  }

  Future<bool> setApplicationSavedInfo(String name, String value) async {
    await _getPrefer();
    final result = _prefs.setString(name, value);
    return result;
  }


  Future<void> processLocalConfig(Map<String, dynamic> mapsConfig) async {
    var seen = await preferences.getAppSavedInfo(mapsConfig[isFirstTime]);
    if (seen != isFirstTime) {
      setApplicationSavedInfo(isFirstTime, isFirstTime);
    }
  }

  static final Preferences _preferences = Preferences._internal();

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();
}
