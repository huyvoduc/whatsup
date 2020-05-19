import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/user_manager.dart';

class UserStatusWidget extends StatefulWidget {
  final UserStatusWidgetBuilder builder;
  final HitTestBehavior behavior;
  final Function onTap;
  final String currentRoute;
  

  /// current route để biết là đang đứng ở màn
  /// hình nào mà quay về sau khi login xong
  ///
  UserStatusWidget(
      {@required this.builder,
        @required this.currentRoute,
        this.onTap,
        this.behavior = HitTestBehavior.translucent,
        }) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(builder != null,'Phải có builder');
    // ignore: prefer_asserts_in_initializer_lists
    assert(currentRoute != null,'phải cho biết bạn đang ở màn hình nào');
  }

  @override
  _UserStatusWidgetState createState() => _UserStatusWidgetState();
}

class _UserStatusWidgetState extends BaseState<UserStatusWidget> {
  UserStatus _status;

  @override
  void initState() {
    super.initState();
    _status = UserManager.instance.getUserStatus();
    UserManager.instance.userStatusNotifier.addListener(handleStatusChange);
  }

  @override
  Widget build(BuildContext context) {
    final action = () {
      // chưa login thì login
      if (_status == UserStatus.notLoggedIn) {
        UserManager.instance.loginAtScreen = widget.currentRoute;
        pushScreen(routerName: RouteList.loginHome);
      }
      // chưa hoàn thành profile thì phải complete
      else if (_status == UserStatus.notCompleteProfile) {
        UserManager.instance.loginAtScreen = widget.currentRoute;
        pushScreen(routerName: RouteList.loginInputBirthDay,
            param: UserManager.instance.currentUser);
      } else { // login rồi thì thực hiện action của widget này
        if (widget.onTap != null) {
          widget.onTap();
        }
      }
    };

    return GestureDetector(
      behavior: widget.behavior,
      onTap: action,
      child: widget.builder(context, _status),
    );
  }

  void handleStatusChange() {
    setState(() {
      _status = UserManager.instance.getUserStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    UserManager.instance.userStatusNotifier.removeListener(handleStatusChange);
  }
}

/// A function that builds a widget based on user status
typedef UserStatusWidgetBuilder = Widget Function(
    BuildContext context, UserStatus status);

//enum ButtonType { none, bouncing }

enum UserStatus {
  loggedIn,
  notLoggedIn,
  notCompleteProfile
}
