import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/screen/post_list_screen.dart';
import 'package:whatsup/utils/dimension.dart';
import 'package:whatsup/utils/user_manager.dart';
import '../../common/const.dart';
import '../../presentation/theme/theme_text.dart';
import '../../utils/preferences.dart';

import '../dummy_screen.dart';
import 'guide_screen.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    UserManager.instance.loadUser();
    checkInitConfig();

//    .then((_) {
//      if (seen == isFirstTime) {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//            builder: (context) {
////          return DummyScreen();
//              return Builder(
//                builder: (context) {
//                  return PostScreen.newInstance(PostListType.featuredPost);
//                },
//              );
//            },
//            settings: const RouteSettings(name: '/dummy')));
//      } else {
//        Navigator.of(context)
//            .pushReplacement(MaterialPageRoute(builder: (context) {
//          return GuideScreen();
//        }));
//      }
//    }
//    );
  }

  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.width = MediaQuery.of(context).size.width;
    Dimension.statusBarHeight = MediaQuery.of(context).padding.top;
    Dimension.bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text(
                'Enjoy Whatsup',
                style: ThemeText.textStyleNormalWhite15,
              ),
            ],
          ),
        ),
      ),
    );
//    return PendingScreen();
  }

  var seen;

  Future<void> checkInitConfig() async {
    seen = await preferences.getAppSavedInfo(isFirstTime);
    if (mounted) {
      await Navigator.of(context).pushNamed(RouteList.featuredPost);
//      if (seen == isFirstTime) {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//            builder: (context) {
////          return DummyScreen();
//              return PostScreen.newInstance(PostListType.featuredPost);
//            },
//            settings: const RouteSettings(name: RouteList.featuredPost)));
//      } else {
//        Navigator.of(context)
//            .pushReplacement(MaterialPageRoute(builder: (context) {
//          return GuideScreen();
//        },settings: const RouteSettings(name: RouteList.featuredPost)));
//      }
    }
  }
}
