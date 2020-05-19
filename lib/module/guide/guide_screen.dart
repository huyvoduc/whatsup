import 'package:flutter/material.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/screen/post_list_screen.dart';
import '../../common/const.dart';
import '../../common/constanst/route_constants.dart';
import '../../presentation/theme/theme_text.dart';
import '../../utils/preferences.dart';
import '../dummy_screen.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> _tipScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _tipScaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Guide screen',
                style: ThemeText.textStyleNormalWhite15,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: number_20),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(number_20),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RouteList.featuredPost);
                },
                child: Padding(
                    padding: const EdgeInsets.all(number_10),
                    child: Text('Bạn đã có tài khoản Whatsup',
                        style: ThemeText.textStyleNormalBlack15)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(number_20),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GuideScreenNo1Screen();
                  }));
                },
                child: Padding(
                    padding: const EdgeInsets.all(number_10),
                    child: Text('Bạn chưa có tài khoản Whatsup',
                        style: ThemeText.textStyleNormalBlack15)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GuideScreenNo1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: (){
          preferences.processLocalConfig({isFirstTime: isFirstTime});
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
//              DummyScreen()
          PostScreen.newInstance(PostListType.featuredPost)
              ,settings: const RouteSettings(
                  name : '/dummy'
              )),
                  (Route<dynamic> route) => false);
//          Navigator.pushNamedAndRemoveUntil(context, RouteList.postFeatured,
//                  (Route<dynamic> route) => false);
        },
        child: Scaffold(
          body: Center(
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(number_10),
                  child: Text('Tap any where to continue',
                      style: ThemeText.textStyleNormalBlack15)),
            ),
          ),
        ),
      ),
    );
  }
}
