import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/theme/theme_color.dart';

class SettingSocicalNetworkScreen extends StatefulWidget {
  @override
  _SettingSocicalNetworkScreenState createState() =>
      _SettingSocicalNetworkScreenState();
}

class _SettingSocicalNetworkScreenState
    extends State<SettingSocicalNetworkScreen> {
  bool connectFacebook = true;
  bool connectGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Liên kết tài khoản'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  'Lưu',
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColor.primaryColor,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      'MẠNG XÃ HỘI',
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: AppColor.defaultTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _buildSocialNetworkItem(
                    checkConnect: connectFacebook,
                    title: 'Facebook',
                    context: context,
                  ),
                  _buildSocialNetworkItem(
                    checkConnect: connectGoogle,
                    title: 'Google',
                    context: context,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialNetworkItem({
    String title,
    bool checkConnect,
    BuildContext context,
  }) {
    return Container(
      color: AppColor.lineTextColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          if (title == 'Facebook') {
            _handleClickMe(
              checkConnect: connectFacebook,
              onClick: () {
                setState(() {
                  connectFacebook = !connectFacebook;
                });
              },
            );
          } else {
            _handleClickMe(
              checkConnect: connectGoogle,
              onClick: () {
                setState(() {
                  connectGoogle = !connectGoogle;
                });
              },
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.title.copyWith(
                    color: AppColor.defaultTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  checkConnect == true ? 'Đã kết nối' : 'Chưa kết nối',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: checkConnect != true
                            ? AppColor.defaultTextColor
                            : Colors.white,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: checkConnect != true
                      ? AppColor.defaultTextColor
                      : Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleClickMe({
    bool checkConnect,
    Function onClick,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            checkConnect == true
                ? 'Bạn có muốn ngắt kết nối tài khoản?'
                : 'Bạn có muốn kết nối tài khoản?',
            style: Theme.of(context).textTheme.title.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                onClick();
                Navigator.of(context).pop();
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );
  }
}
