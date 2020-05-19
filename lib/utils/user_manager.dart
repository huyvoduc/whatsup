import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';

import '../model/user_model.dart';
import 'firebase_auth_service.dart';
import 'firebase_auth_service.dart';
import 'preferences.dart';

class UserManager  {
  static final UserManager instance = UserManager();


  ValueNotifier<UserStatus> userStatusNotifier
  = ValueNotifier<UserStatus>(null);

  UserModel currentUser;
  // để đánh dấu lại vị trí user login
  // để biết mà quay về sau khi login xong
  String loginAtScreen = '';

  // ignore: use_setters_to_change_properties
  void updateUserAfterLogin(UserModel user,{bool isNotify = true}) {
    currentUser = user;
    if (isNotify) {
      userStatusNotifier.value = UserStatus.loggedIn;
      _notify();
    }
    preferences.saveUserInfo(user);
  }

  void _notify() {
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    userStatusNotifier.notifyListeners();
  }

  UserStatus getUserStatus() {
    if (currentUser == null) {
      return UserStatus.notLoggedIn;
    }
    return currentUser.username != null &&
        currentUser.username.isNotEmpty ? UserStatus.loggedIn
        : UserStatus.notCompleteProfile;
  }

  void logOut() {
    currentUser = null;
    WhatsupAuthService.instance.logout();
    preferences.saveUserInfo(currentUser);
    userStatusNotifier.value = UserStatus.loggedIn;
    _notify();
  }

  Future<void> loadUser() async {
    final fbUser = await WhatsupAuthService.instance.getCurrentUser();
    if (fbUser != null) {
      debugPrint('Đã login acc ${fbUser.uid}');
      currentUser = await preferences.loadUserInfo();
      userStatusNotifier.value = getUserStatus();
    } else {
      currentUser = null;
      userStatusNotifier.value = getUserStatus();
    }
    _notify();
  }
}
