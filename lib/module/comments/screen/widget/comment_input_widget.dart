import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/user_manager.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

class CommentInputWidget extends StatefulWidget {
  @override
  _CommentInputWidgetState createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends BaseState<CommentInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      color: const Color(0xFF20242F),
      padding: EdgeInsets.only(top: 10,bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: TextField(
                keyboardType: TextInputType.multiline,
                autofocus: false,
                controller: TextEditingController(),
                style: ThemeText.textStyleNormalWhite15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Viết bình luận ...',
                  hintStyle: ThemeText.textStyleNormalWhite15,
                  filled: true,
                  fillColor: Color(0xFF485164),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: UserStatusWidget(
                currentRoute: RouteList.featuredPost,
                onTap: () {
                  print('commenttttttttttttttttt');
                },
                builder: (context, status) {
                  return IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (status == UserStatus.notLoggedIn) {
                          UserManager.instance.loginAtScreen =
                              RouteList.featuredPost;
                          pushScreen(routerName: RouteList.loginHome);
                        } else if (status == UserStatus.notCompleteProfile) {
                          UserManager.instance.loginAtScreen =
                              RouteList.featuredPost;
                          pushScreen(
                              routerName: RouteList.loginInputBirthDay,
                              param: UserManager.instance.currentUser);
                        } else if (status == UserStatus.loggedIn) {
                          print('sendingggggggggg commentttttttttt');

                        }
                      });
                },
              )),
        ],
      ),
    );
  }
}
