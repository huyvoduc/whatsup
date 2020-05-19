import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/model/user_model.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/utils/firebase_database_service.dart';
import 'package:whatsup/utils/user_manager.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import '../common/constanst/route_constants.dart';
import '../utils/firebase_database_service.dart';

class DummyScreen extends StatefulWidget {
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserManager.instance.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              _buildLogin(),

//              CupertinoButton(
//                color: Colors.brown,
//                onPressed: () {
//                  Navigator.pushNamed(context, RouteList.home);
//                },
//                child: const Text('Login'),
//              ),
              const SizedBox(height: 10),
              CupertinoButton(
                color: Colors.amber,
                onPressed: () {
                  Navigator.pushNamed(context, RouteList.profile);
                },
                child: const Text('Profile'),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, RouteList.featuredPost);
                },
                child: const Text('Featured Post'),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, RouteList.newestPost);
                },
                child: const Text('Newest Post'),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                color: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, RouteList.subscriptionPost);
                },
                child: const Text('Subscription Post'),
              ),
              const SizedBox(height: 10),

              CupertinoButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, RouteList.menuScreen);
                },
                child: const Text('Menu Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: UserStatusWidget(
        currentRoute: '/dummy',
        onTap: () {
          // ignore: avoid_debugPrint
          debugPrint('action khi click vào UserStatusWidget');
        },
        builder: (context,status) {
          if (status == UserStatus.loggedIn) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                WText('Chào mừng '
                    '${UserManager.instance.currentUser.fullName}'),
                RaisedButton(
                  onPressed: UserManager.instance.logOut,
                  child: const WText('Đăng xuất'),
                )
              ],
            );
          } else if (status == UserStatus.notCompleteProfile) {
            return const WText('Chỉ còn 1 bước để hoàn thành đăng kí,'
                ' hoàn thành nào',
                textAlign: TextAlign.center ,color: Colors.black
            );
          }
          else {
            return const WText('Bạn chưa đăng nhập, Đăng nhập ngay',
              textAlign: TextAlign.center ,color: Colors.black
            );
          }
        },
      ),
    );
  }
}
